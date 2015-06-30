#define	MOTOR0PIN  D28  //电机0控制端口 数字口D28
#define	MOTOR1PIN  D27  //电机1控制端口 数字口D27
#define	MOTOR2PIN  D11  //电机2控制端口 数字口D11
#define	MOTOR3PIN  D12  //电机3控制端口 数字口D12
//#define MOTOR4PIN   D24  //电机3控制端口 数字口D24
//#define MOTOR5PIN   D14  //电机3控制端口 数字口D14

//uint16 MotorData[6] = {0,0,0,0,0,0};

void controlMotors(const uint16 *motorData)    
{
  uint16 PWMData[4] = {0,0,0,0};
  uint8 i;
  for(i=0;i<4;i++)
  {
    if(motorData[i] <= 0)  PWMData[i] = 0;  //PWM占空比调整到0%，接口常低电平。
      else if(motorData[i]  >= 1000) PWMData[i] = 50000;  //PWM占空比100%，接口常高电平。
        else  PWMData[i] = (1000 + motorData[i])*24;
  }     
  //PWM最小1，最大499921，每24个数值对应1US，单值为0时为占空比为0%，当大于499920时为占空比100%
  pwmWrite(MOTOR0PIN,PWMData[0] );
  pwmWrite(MOTOR1PIN,PWMData[1] );
  pwmWrite(MOTOR2PIN,PWMData[2] );
  pwmWrite(MOTOR3PIN,PWMData[3] );
//  pwmWrite(MOTOR4PIN,PWMData[4] );
//  pwmWrite(MOTOR5PIN,PWMData[5] );
}

void initMotors(void)   
{
  //将6个电机控制管脚都设置为推挽输出IO
  pinMode(MOTOR0PIN, PWM);
  pinMode(MOTOR1PIN, PWM);
  pinMode(MOTOR2PIN, PWM);
  pinMode(MOTOR3PIN, PWM);
//  pinMode(MOTOR4PIN, PWM);
//  pinMode(MOTOR5PIN, PWM);
  Timer3.setPeriod(2080);  //数字口D28，D27，D11，D12是Timer3的4个比较输出口，将Timer3的周期设置为2080us,电机更新频率为500HZ
  Timer4.setPeriod(2080);  //数字口D24，D14是Timer4的2个比较输出口，将Timer4的周期设置为2080us,电机更新频率为500HZ
  uint16 motorData[4] = {0, 0, 0, 0};
  controlMotors(motorData);   //计算各个电机控制量之差,将这个值用于定时器产生中断改变相应电机脉冲高电平时间 
 }

 ////////////////////////////////////////////////////////////////////////////////////
//函数原型:  void motorTest(void)
//参数说明:  无                                        
//返回值:    无                                                               
//说明:      测试电调电机
///////////////////////////////////////////////////////////////////////////////////
//void motorTest(void)
//{
//   motorInit();       //电机控制初始化 
//  ///////////////电调初始化设置行程，此时脉冲发出和电调电源一定要同时发生，设置最高行程///////////////////
//  MotorData[0] = 999;  //首先将PWM设置为最高，设置电调最高行程数字
//  MotorData[1] = 999;
//  MotorData[2] = 999;
//  MotorData[3] = 999;
//  MotorData[4] = 999;
//  MotorData[5] = 999; 
//  motorControl();   //计算各个电机控制量之差,将这个值用于定时器产生中断改变相应电机脉冲高电平时间
//  delay(3000);       //延迟至少3秒等待电调记住，需要根据实际的电调手册更改
//  MotorData[0] = 10;  //将PWM设置为10，设置电调最低行程数字，解锁的时候只需要等于或者低于10就可以解锁
//  MotorData[1] = 10;
//  MotorData[2] = 10;
//  MotorData[3] = 10;
//  MotorData[4] = 10;
//  MotorData[5] = 10; 
//  motorControl();  //计算各个电机控制量之差,将这个值用于定时器产生中断改变相应电机脉冲高电平时间
//  delay(3000);      //延迟至少3秒等待电调记住，需要根据实际的电调手册更改
//  
//  //////////////////////////解锁电调，发出低于设置的最小行程就可以这里小于/////////////////////////////
//  MotorData[0] = 8;  //将PWM设置为10，设置电调最低行程数字，解锁的时候只需要等于或者低于10就可以解锁
//  MotorData[1] = 8;
//  MotorData[2] = 8;
//  MotorData[3] = 8;
//  MotorData[4] = 8;
//  MotorData[5] = 8; 
//  motorControl();  //计算各个电机控制量之差,将这个值用于定时器产生中断改变相应电机脉冲高电平时间
//  delay(2000);      //延迟至少2秒等待电调记住，需要根据实际的电调手册更改
//  while(1)
//  {
//    MotorData[0] = 100;  //控制6个电调使电机按照低速度运行
//    MotorData[1] = 100;
//    MotorData[2] = 100;
//    MotorData[3] = 100;
//    MotorData[4] = 100;
//    MotorData[5] = 100; 
//    motorControl();   //计算各个电机控制量之差,将这个值用于定时器产生中断改变相应电机脉冲高电平时间
//    delay(3000);
//    MotorData[0] = 500;  //控制6个电调使电机按照一半速度运行
//    MotorData[1] = 500;
//    MotorData[2] = 500;
//    MotorData[3] = 500;
//    MotorData[4] = 500;
//    MotorData[5] = 500; 
//    motorControl();   //计算各个电机控制量之差,将这个值用于定时器产生中断改变相应电机脉冲高电平时间
//    delay(3000);   
//  }  
//}


