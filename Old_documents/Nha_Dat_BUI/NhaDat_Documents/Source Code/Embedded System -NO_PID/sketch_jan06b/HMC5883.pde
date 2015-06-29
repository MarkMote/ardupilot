
///////////////////////////HMC5883ç”µå­�ç½—ç›˜///////////////////////////////
#define HMC5883_ADDR 0x1E // 7 bit address of the HMC5883 used with the Wire library HMC5883 åœ°å�€
#define HMC_POS_BIAS 1  //æ­£åŸºå‡†å€¼é…�ç½®é‡�
#define HMC_NEG_BIAS 2  //è´ŸåŸºå‡†å€¼é…�ç½®é‡�

// HMC5883 å¯„å­˜å™¨å®šä¹‰
#define HMC5883_R_CONFA 0  //Configuration Register A   Read/Write 
#define HMC5883_R_CONFB 1  //Configuration Register B   Read/Write 
#define HMC5883_R_MODE 2   //Mode Register  Read/Write 
#define HMC5883_R_XM 3    //Data Output X MSB Register  Read
#define HMC5883_R_XL 4    //Data Output X LSB Register  Read
#define HMC5883_R_ZM 5    //Data Output Z MSB Register  Read 
#define HMC5883_R_ZL 6    //Data Output Z LSB Register  Read 
#define HMC5883_R_YM 7    //Data Output Y MSB Register  Read 
#define HMC5883_R_YL 8    //Data Output Y LSB Register  Read
#define HMC5883_R_STATUS 9 //Status Register  Read 
#define HMC5883_R_IDA 10   // Identification Register A  Read
#define HMC5883_R_IDB 11   //Identification Register B  Read  
#define HMC5883_R_IDC 12   //Identification Register C  Read

// Local magnetic declination
// I use this web : http://www.ngdc.noaa.gov/geomag-web/#declination
#define MAGNETIC_DECLINATION -6.0    // not used now -> magnetic bearing
float x_scale = 1;
float y_scale = 1;
float z_scale = 1;
float x_max,y_max,z_max;
void compassInit(uint8 setmode)
{
  delay(5);
  if (setmode)
  {
    compassSetMode(0);
  }
 // writeTo(HMC5883_ADDR, HMC5883_R_CONFA, 0x70); //8-average, 15 Hz default, normal measurement æ¯�æ¬¡è¾“å‡ºé‡‡æ ·8æ¬¡ï¼Œ15HZè¾“å‡ºé‡‡æ ·çŽ‡ï¼Œæ™®é€šæ¨¡å¼�
  //writeTo(HMC5883_ADDR, HMC5883_R_CONFB, 0xa0); // Gain=5, or any other desired gain 
  writeTo(HMC5883_ADDR, HMC5883_R_MODE, 0x00); // Set continouos mode (default to 10Hz)
}
void compassSetMode(uint8 mode) 
{ 
  if (mode > 2) 
  {
    return;
  }
  writeTo(HMC5883_ADDR, HMC5883_R_MODE, mode);
  delay(100);
}

void compassCalibrate(uint8 gain) 
{
  int16 compassdata[3]; 
  float fx = 0;
  float fy = 0;
  float fz = 0;
  x_scale = 1; // get actual values
  y_scale = 1;
  z_scale = 1;
  writeTo(HMC5883_ADDR, HMC5883_R_CONFA, 0x10 + HMC_POS_BIAS); // Reg A DOR=0x010 + MS1,MS0 set to pos bias
  compassSetGain(gain);
  float x, y, z, mx=0, my=0, mz=0;
  
  for (uint8 i=0; i<10; i++) 
  { 
    compassSetMode(1);
    compassRead(compassdata); 
  
    fx = ((float) compassdata[0]) / x_scale;
    fy = ((float) compassdata[1]) / y_scale;  
    fz = ((float) compassdata[2]) / z_scale;  
    x= (int16) (fx + 0.5);
    y= (int16) (fy + 0.5);
    z= (int16) (fz + 0.5);
  
    if (x>mx) mx = x;
    if (y>my) my = y;
    if (z>mz) mz = z;
  }
  
  float maxi = 0;
  if (mx>maxi) maxi = mx;
  if (my>maxi) maxi = my;
  if (mz>maxi) maxi = mz;
  x_max = mx;
  y_max = my;
  z_max = mz;
  x_scale = maxi/mx; // calc scales
  y_scale = maxi/my;
  z_scale = maxi/mz;
  writeTo(HMC5883_ADDR, HMC5883_R_CONFA, 0x010); // set RegA/DOR back to default
}


// set data output rate
// 0-6, 4 default, normal operation assumed
void compassSetDOR(uint8 DOR) 
{
  if (DOR>6) return;
  writeTo(HMC5883_ADDR, HMC5883_R_CONFA, DOR<<2);
}


void compassSetGain(uint8 gain)
{ 
  // 0-7, 1 default
  if (gain > 7) return;
  writeTo(HMC5883_ADDR, HMC5883_R_CONFB, gain << 5);
}


void compassRead(int16 * result) 
{
  uint8 buff[6];
  readFrom(HMC5883_ADDR, HMC5883_R_XM, 6, buff);
   // MSB byte first, then LSB, X,Y,Z
  result[0] = (((int16)buff[0]) << 8) | buff[1];    // X axis 
  result[1] = (((int16)buff[4]) << 8) | buff[5];    // Y axis 
  result[2] = (((int16)buff[2]) << 8) | buff[3];    // Z axis
 }

double compassHeading(void)
{
  float fx = 0;
  float fy = 0;
  float heading  = 0;
  int16 compassdata[3]; 
  compassRead(compassdata); 
  delay(67);//å¦‚æžœé‡‡æ ·çŽ‡ä¸º15HZéœ€è¦�å»¶è¿Ÿ67MS

  fx = ((float) compassdata[0]) / x_scale;
  fy = ((float) compassdata[1]) / y_scale;
  heading = atan2(fy, fx);
  
  // Correct for when signs are reversed.
  if(heading < 0)    heading += 2*PI;

  return(heading * 180/PI); 

  
  
     /*ä½¿ç”¨ä¿¯ä»°è§’è¿›è¡Œè¡¥å�¿çš„è®¡ç®—æ–¹å¼�è¯¦è§� SF9DOFä»£ç �
  float MAG_X;
  float MAG_Y;
  float cos_roll;
  float sin_roll;
  float cos_pitch;
  float sin_pitch;
  
  cos_roll = cos(roll);
  sin_roll = sin(roll);
  cos_pitch = cos(pitch);
  sin_pitch = sin(pitch);
  // Tilt compensated Magnetic filed X:
  MAG_X = magnetom_x*cos_pitch+magnetom_y*sin_roll*sin_pitch+magnetom_z*cos_roll*sin_pitch;
  // Tilt compensated Magnetic filed Y:
  MAG_Y = magnetom_y*cos_roll-magnetom_z*sin_roll;
  // Magnetic Heading
  MAG_Heading = atan2(-MAG_Y,MAG_X);
 */
}

void compassTest(void)//HMC5883ç½—ç›˜æµ‹è¯•
{
  while(1)
  {
    int16 res[3]; 
    compassRead(res); 
    //Print out values of each axis
    SerialUSB.print("x: ");
    SerialUSB.print(res[0]);
    SerialUSB.print("  y: ");
    SerialUSB.print(res[1]);
    SerialUSB.print("  z: ");
    SerialUSB.println(res[2]);
    delay(100);
  }  
}

