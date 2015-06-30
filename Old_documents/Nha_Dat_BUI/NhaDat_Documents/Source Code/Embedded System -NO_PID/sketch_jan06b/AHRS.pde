#define twoKpDef  (2.0f * 0.1f) ///< 2 * proportional gain
#define twoKiDef  (2.0f * 0.1e-3f) ///< 2 * integral gain

float iq0, iq1, iq2, iq3;	///< calculation variables
float exInt, eyInt, ezInt;	///< scaled integral error (?)
volatile float twoKp;	///< 2 * proportional gain (Kp)
volatile float twoKi;	///< 2 * integral gain (Ki)
volatile float q0; ///<  quaternion of sensor frame relative to auxiliary frame
volatile float q1; ///<  quaternion of sensor frame relative to auxiliary frame
volatile float q2; ///<  quaternion of sensor frame relative to auxiliary frame
volatile float q3; ///<  quaternion of sensor frame relative to auxiliary frame
volatile float integralFBx,  integralFBy, integralFBz;
uint32 lastUpdate;	///< sample period expressed in milliseconds
uint32 now;	///< sample period expressed in milliseconds 
float sampleFreq;		///< half the sample period expressed in seconds
int16 startLoopTime;

void initAHRS(void)
{
  // initialize quaternion
  q0 = 1.0f;
  q1 = 0.0f;
  q2 = 0.0f;
  q3 = 0.0f;
  exInt = 0.0;
  eyInt = 0.0;
  ezInt = 0.0;

  // Initialize PID parameters
  twoKp = twoKpDef;
  twoKi = twoKiDef;

  integralFBx = 0.0f;
  integralFBy = 0.0f;
  integralFBz = 0.0f;

  lastUpdate = 0;
  now = 0;

  //configure I2C port 1 (pins 5, 9) with no special option flags (second argument)
  i2c_master_enable(I2C1, I2C_FAST_MODE);  //设置I2C1接口，主机模式

  delay(200);
  
  // Accelerometer start
  SerialUSB.println("Initializing the Accelerometer...");
  initAcc();            //初始化加速度计
  delay(200);
  SerialUSB.println("Initializing the Accelerometer... Done!");

  // Gyroscope start
  SerialUSB.println("Initializing the Gyroscope...");
  initGyro();           //初始化陀螺仪
  delay(200);
  SerialUSB.println("Initializing the Gyroscope... Done!");

  SerialUSB.println("Calibrating the Gyroscope...");
  zeroCalibrateGyroscope(128,5);  //零值校正，记录陀螺仪静止状态输出的值将这个值保存到偏移量，采集128次，采样周期5ms
  SerialUSB.println("Calibrating the Gyroscope... Done!");

  // Barometer start
  SerialUSB.println("Calibrating the Barometer...");
  initBMP085();  //初始化气压高度计
  calibOffsetBMP085(100);
  SerialUSB.println("Calibrating the Barometer... Done!");

  // Compass start
  SerialUSB.println("Initializing the Compass...");
  compassInit(false);   //初始化罗盘
  SerialUSB.println("Initializing the Compass... Done!");

  SerialUSB.println("Calibrating the Compass...");
  compassCalibrate(1);  //校准一次罗盘，gain为1.3Ga
  SerialUSB.println("Calibrating the Compass... Done!");
  compassSetMode(0);  //设置为连续测量模式  
}

double kalman_q = 1;
double kalman_r = 32;
double kalman_p = 0;
kalman_state kalman_a_x = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_a_y = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_a_z = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_g_x = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_g_y = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_g_z = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_m_x = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_m_y = kalman_init(kalman_q,kalman_r,kalman_p,0);
kalman_state kalman_m_z = kalman_init(kalman_q,kalman_r,kalman_p,0);

void AHRSgetValues(float * values) 
{  
  float valG[3];
  getGyroscopeData(&valG[0]); //读取 XYZ轴陀螺仪 角速度
  // gyro values are expressed in deg/sec, the * M_PI/180 will convert it to radians/sec
  values[0] = valG[0] * M_PI/180;
  values[1] = valG[1] * M_PI/180;
  values[2] = valG[2] * M_PI/180;
  int16 valA[3];
  getAccelerometerData(&valA[0]);  //读取 XYZ轴加速度原始数据，然后转换成浮点数
  values[3] = ((float) valA[0])/256;
  values[4] = ((float) valA[1])/256;
  values[5] = ((float) valA[2])/256;
  int16 valC[3];
  compassRead(&valC[0]);
  values[6] = ((float) valC[0]);
  values[7] = ((float) valC[1]);
  values[8] = ((float) valC[2]);
}

void AHRSgetFilteredValues(float * values)
{
  float unfiltered[9];
  AHRSgetValues(unfiltered);
  
  kalman_update(&kalman_g_x,unfiltered[0]);
  kalman_update(&kalman_g_y,unfiltered[1]);
  kalman_update(&kalman_g_z,unfiltered[2]);
  kalman_update(&kalman_a_x,unfiltered[3]);
  kalman_update(&kalman_a_y,unfiltered[4]);
  kalman_update(&kalman_a_z,unfiltered[5]);
  kalman_update(&kalman_m_x,unfiltered[6]);
  kalman_update(&kalman_m_y,unfiltered[7]);
  kalman_update(&kalman_m_z,unfiltered[8]);
  
  values[0] = kalman_g_x.x;
  values[1] = kalman_g_y.x;
  values[2] = kalman_g_z.x;
  values[3] = kalman_a_x.x;
  values[4] = kalman_a_y.x;
  values[5] = kalman_a_z.x;
  values[6] = kalman_m_x.x;
  values[7] = kalman_m_y.x;
  values[8] = kalman_m_z.x;
}

float invSqrt(float x) {
  float halfx = 0.5f * x;
  float y = x;
  long i = *(long*)&y;
  i = 0x5f3759df - (i>>1);
  y = *(float*)&i;
  y = y * (1.5f - (halfx * y * y));
  return y;
//  return 1/sqrt(x);
}

void AHRSupdateIMU(float gx, float gy, float gz, float ax, float ay, float az) {
  float recipNorm;
  float halfvx, halfvy, halfvz;
  float halfex, halfey, halfez;
  float qa, qb, qc;

  // Compute feedback only if accelerometer measurement valid (avoids NaN in accelerometer normalisation)
  if(!((ax == 0.0f) && (ay == 0.0f) && (az == 0.0f))) {

    // Normalise accelerometer measurement
    recipNorm = invSqrt(ax * ax + ay * ay + az * az);
    ax *= recipNorm;
    ay *= recipNorm;
    az *= recipNorm;        

    // Estimated direction of gravity and vector perpendicular to magnetic flux
    halfvx = q1 * q3 - q0 * q2;
    halfvy = q0 * q1 + q2 * q3;
    halfvz = q0 * q0 - 0.5f + q3 * q3;

    // Error is sum of cross product between estimated and measured direction of gravity
    halfex = (ay * halfvz - az * halfvy);
    halfey = (az * halfvx - ax * halfvz);
    halfez = (ax * halfvy - ay * halfvx);

    // Compute and apply integral feedback if enabled
    if(twoKi > 0.0f) {
      integralFBx += twoKi * halfex * (1.0f / sampleFreq);	// integral error scaled by Ki
      integralFBy += twoKi * halfey * (1.0f / sampleFreq);
      integralFBz += twoKi * halfez * (1.0f / sampleFreq);
      gx += integralFBx;	// apply integral feedback
      gy += integralFBy;
      gz += integralFBz;
    } 
    else {
      integralFBx = 0.0f;	// prevent integral windup
      integralFBy = 0.0f;
      integralFBz = 0.0f;
    }

    // Apply proportional feedback
    gx += twoKp * halfex;
    gy += twoKp * halfey;
    gz += twoKp * halfez;
  }

  // Integrate rate of change of quaternion
  gx *= (0.5f * (1.0f / sampleFreq));		// pre-multiply common factors
  gy *= (0.5f * (1.0f / sampleFreq));
  gz *= (0.5f * (1.0f / sampleFreq));
  qa = q0;
  qb = q1;
  qc = q2;
  q0 += (-qb * gx - qc * gy - q3 * gz);
  q1 += (qa * gx + qc * gz - q3 * gy);
  q2 += (qa * gy - qb * gz + q3 * gx);
  q3 += (qa * gz + qb * gy - qc * gx); 

  // Normalise quaternion
  recipNorm = invSqrt(q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3);
  q0 *= recipNorm;
  q1 *= recipNorm;
  q2 *= recipNorm;
  q3 *= recipNorm;
}

void AHRSupdate(float gx, float gy, float gz, float ax, float ay, float az, float mx, float my, float mz) {
  float recipNorm;
  float q0q0, q0q1, q0q2, q0q3, q1q1, q1q2, q1q3, q2q2, q2q3, q3q3;  
  float hx, hy, bx, bz;
  float halfvx, halfvy, halfvz, halfwx, halfwy, halfwz;
  float halfex, halfey, halfez;
  float qa, qb, qc;

  // Use IMU algorithm if magnetometer measurement invalid (avoids NaN in magnetometer normalisation)
  if((mx == 0.0f) && (my == 0.0f) && (mz == 0.0f)) {
    AHRSupdateIMU(gx, gy, gz, ax, ay, az);
    return;
  }

  // Compute feedback only if accelerometer measurement valid (avoids NaN in accelerometer normalisation)
  if(!((ax == 0.0f) && (ay == 0.0f) && (az == 0.0f))) {

    // Normalise accelerometer measurement
    recipNorm = invSqrt(ax * ax + ay * ay + az * az);
    ax *= recipNorm;
    ay *= recipNorm;
    az *= recipNorm;     

    // Normalise magnetometer measurement
    recipNorm = invSqrt(mx * mx + my * my + mz * mz);
    mx *= recipNorm;
    my *= recipNorm;
    mz *= recipNorm;   

    // Auxiliary variables to avoid repeated arithmetic
    q0q0 = q0 * q0;
    q0q1 = q0 * q1;
    q0q2 = q0 * q2;
    q0q3 = q0 * q3;
    q1q1 = q1 * q1;
    q1q2 = q1 * q2;
    q1q3 = q1 * q3;
    q2q2 = q2 * q2;
    q2q3 = q2 * q3;
    q3q3 = q3 * q3;   

    // Reference direction of Earth's magnetic field
    hx = 2.0f * (mx * (0.5f - q2q2 - q3q3) + my * (q1q2 - q0q3) + mz * (q1q3 + q0q2));
    hy = 2.0f * (mx * (q1q2 + q0q3) + my * (0.5f - q1q1 - q3q3) + mz * (q2q3 - q0q1));
    bx = sqrt(hx * hx + hy * hy);
    bz = 2.0f * (mx * (q1q3 - q0q2) + my * (q2q3 + q0q1) + mz * (0.5f - q1q1 - q2q2));

    // Estimated direction of gravity and magnetic field
    halfvx = q1q3 - q0q2;
    halfvy = q0q1 + q2q3;
    halfvz = q0q0 - 0.5f + q3q3;
    halfwx = bx * (0.5f - q2q2 - q3q3) + bz * (q1q3 - q0q2);
    halfwy = bx * (q1q2 - q0q3) + bz * (q0q1 + q2q3);
    halfwz = bx * (q0q2 + q1q3) + bz * (0.5f - q1q1 - q2q2);  

    // Error is sum of cross product between estimated direction and measured direction of field vectors
    halfex = (ay * halfvz - az * halfvy) + (my * halfwz - mz * halfwy);
    halfey = (az * halfvx - ax * halfvz) + (mz * halfwx - mx * halfwz);
    halfez = (ax * halfvy - ay * halfvx) + (mx * halfwy - my * halfwx);

    // Compute and apply integral feedback if enabled
    if(twoKi > 0.0f) {
      integralFBx += twoKi * halfex * (1.0f / sampleFreq);	// integral error scaled by Ki
      integralFBy += twoKi * halfey * (1.0f / sampleFreq);
      integralFBz += twoKi * halfez * (1.0f / sampleFreq);
      gx += integralFBx;	// apply integral feedback
      gy += integralFBy;
      gz += integralFBz;
    } 
    else {
      integralFBx = 0.0f;	// prevent integral windup
      integralFBy = 0.0f;
      integralFBz = 0.0f;
    }

    // Apply proportional feedback
    gx += twoKp * halfex;
    gy += twoKp * halfey;
    gz += twoKp * halfez;
  }

  // Integrate rate of change of quaternion
  gx *= (0.5f * (1.0f / sampleFreq));		// pre-multiply common factors
  gy *= (0.5f * (1.0f / sampleFreq));
  gz *= (0.5f * (1.0f / sampleFreq));
  qa = q0;
  qb = q1;
  qc = q2;
  q0 += (-qb * gx - qc * gy - q3 * gz);
  q1 += (qa * gx + qc * gz - q3 * gy);
  q2 += (qa * gy - qb * gz + q3 * gx);
  q3 += (qa * gz + qb * gy - qc * gx); 

  // Normalise quaternion
  recipNorm = invSqrt(q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3);
  q0 *= recipNorm;
  q1 *= recipNorm;
  q2 *= recipNorm;
  q3 *= recipNorm;
}

void AHRSgetQ(float * q) 
{
  float val[9];
  AHRSgetFilteredValues(val);

  now = micros();
  sampleFreq = 1.0 / ((now - lastUpdate) / 1000000.0);
  lastUpdate = now;
  // 9DOF IMU
  AHRSupdate(val[0], val[1], val[2], val[3], val[4], val[5], val[6], val[7], val[8]);
  // 6DOF IMU
  //AHRSupdate(val[0], val[1], val[2], val[3], val[4], val[5], 0.0f, 0.0f, 0.0f);
  q[0] = q0;
  q[1] = q1;
  q[2] = q2;
  q[3] = q3;
}

void Q2E(const float *q, float *euler)
{
  euler[YAW] = atan2(2 * q[1] * q[2] - 2 * q[0] * q[3], 2 * q[0]*q[0] + 2 * q[1] * q[1] - 1) * 180/M_PI; // psi - yaw
  euler[PITCH] = -asin(2 * q[1] * q[3] + 2 * q[0] * q[2]) * 180/M_PI; // theta 
  euler[ROLL] = atan2(2 * q[2] * q[3] - 2 * q[0] * q[1], 2 * q[0] * q[0] + 2 * q[3] * q[3] - 1) * 180/M_PI; // phi
}

//void Q2YPR(const float *q, float *ypr)
//{
//  float gx, gy, gz; // estimated gravity direction
//
//  gx = 2 * (q[1]*q[3] - q[0]*q[2]);
//  gy = 2 * (q[0]*q[1] + q[2]*q[3]);
//  gz = q[0]*q[0] - q[1]*q[1] - q[2]*q[2] + q[3]*q[3];
//
//  ypr[0] = atan2(2 * q[1] * q[2] - 2 * q[0] * q[3], 2 * q[0]*q[0] + 2 * q[1] * q[1] - 1) * 180/M_PI;
//  ypr[1] = atan2(double(gx), sqrt(gy*gy + gz*gz))  * 180/M_PI;
//  ypr[2] = atan2(double(gy), sqrt(gx*gx + gz*gz))  * 180/M_PI;
//}

void AHRSgetEuler(float * angles) 
{
  float q[4]; // quaternion
  AHRSgetQ(q);
  Q2E(q, angles);
//  angles[0] = atan2(2 * q[1] * q[2] - 2 * q[0] * q[3], 2 * q[0]*q[0] + 2 * q[1] * q[1] - 1) * 180/M_PI; // psi
//  angles[1] = -asin(2 * q[1] * q[3] + 2 * q[0] * q[2]) * 180/M_PI; // theta
//  angles[2] = atan2(2 * q[2] * q[3] - 2 * q[0] * q[1], 2 * q[0] * q[0] + 2 * q[3] * q[3] - 1) * 180/M_PI; // phi
}

