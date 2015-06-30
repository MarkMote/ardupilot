// é™€èžºä»ª ITG3205 
#define GYRO 0x68 // å®šä¹‰ä¼ æ„Ÿå™¨åœ°å�€,å°†AD0è¿žæŽ¥åˆ°GNDå�£ï¼Œä¼ æ„Ÿå™¨åœ°å�€ä¸ºäºŒè¿›åˆ¶æ•°11101000 (è¯·å�‚è€ƒä½ æŽ¥å�£æ�¿çš„åŽŸç�†å›¾)
#define G_SMPLRT_DIV 0x15  //é‡‡æ ·çŽ‡å¯„å­˜å™¨åœ°å�€
#define G_DLPF_FS 0x16     //æ£€æµ‹ç�µæ•�åº¦å�Šå…¶ä½Žé€šæ»¤æ³¢å™¨è®¾ç½®
#define G_INT_CFG 0x17     //ä¸­æ–­é…�ç½®å¯„å­˜å™¨
#define G_PWR_MGM 0x3E     //ç”µæº�ç®¡ç�†å¯„å­˜å™¨

#define G_TO_READ 8 // x,y,z æ¯�ä¸ªè½´2ä¸ªå­—èŠ‚ï¼Œå�¦å¤–å†�åŠ ä¸Š2ä¸ªå­—èŠ‚çš„æ¸©åº¦

// é™€èžºä»ªè¯¯å·®ä¿®æ­£çš„å��ç§»é‡�,åœ¨é™€èžºä»ªåˆ�å§‹åŒ–çš„æ—¶å€™å°†é›¶å€¼è¯»å�–å›žæ�¥ä¿�å­˜è¿›åŽ» 
int16 g_offx = 0;
int16 g_offy = 0;
int16 g_offz = 0;

////////////////////////////////////////////////////////////////////////////////////
//å‡½æ•°åŽŸåž‹:  void initGyro(void)             	     
//å�‚æ•°è¯´æ˜Ž:  æ—                                         
//è¿”å›žå€¼:    æ—                                                                
//è¯´æ˜Ž:      åˆ�å§‹åŒ–ITG3205é™€èžºä»ª
///////////////////////////////////////////////////////////////////////////////////
void initGyro(void)
{
   ///////////////////////////////////////////////
   // ITG 3200
   // ç”µæº�ç®¡ç�†è®¾å®šï¼š
   // æ—¶é’Ÿé€‰æ‹© =å†…éƒ¨æŒ¯è�¡å™¨
   // æ— å¤�ä½�, æ— ç�¡çœ æ¨¡å¼�
   // æ— å¾…æœºæ¨¡å¼�
   // é‡‡æ ·çŽ‡ = 125Hz
   // å�‚æ•°ä¸º+ / - 2000åº¦/ç§’
   // ä½Žé€šæ»¤æ³¢å™¨=5HZ
   // æ²¡æœ‰ä¸­æ–­
   ///////////////////////////////////////////////////
   
  ////////////////////FreeIMU çš„å®šä¹‰//////////////////////////////
//  writeTo(GYRO, G_SMPLRT_DIV, 0x00);//åˆ†é¢‘ç³»æ•°ä¸º0ï¼Œä¸�åˆ†é¢‘ï¼Œé‡‡æ ·çŽ‡ä¸º8KHZ
//  writeTo(GYRO, G_DLPF_FS, 0x18);//é‡‡æ ·é¢‘çŽ‡8KHZï¼Œå¸¦å®½256HZ
//  writeTo(GYRO, G_PWR_MGM, 0x01);  //PLL with X Gyro reference
  
  writeTo(GYRO, G_PWR_MGM, 0x00);  //Internal oscillator
  writeTo(GYRO, G_SMPLRT_DIV, 0x07); // Fsample = 1kHz / (7 + 1) = 125Hz, or 8ms per sample.ITG3205 datasheet page 24    
  writeTo(GYRO, G_DLPF_FS, 0x1E);   //é™€èžºä»ªæµ‹é‡�é‡�ç¨‹ +/- 2000 dgrs/sec, 1KHz é‡‡æ ·çŽ‡,Low Pass Filter Bandwidth 5HZ
  
  writeTo(GYRO, G_INT_CFG, 0x00);   //å…³é—­æ‰€æœ‰ä¸­æ–­  
}
////////////////////////////////////////////////////////////////////////////////////
//å‡½æ•°åŽŸåž‹:  zeroCalibrateGyroscope(unsigned int totSamples, unsigned int sampleDelayMS)           	     
//å�‚æ•°è¯´æ˜Ž:  totSamples : é‡‡é›†é™€èžºä»ªæ•°æ�®æ¬¡æ•°
//           sampleDelayMS: é‡‡é›†é—´éš”æ—¶é—´
//è¿”å›žå€¼:    æ—                                                                
//è¯´æ˜Ž:      è¯»å�–ITG3205é™€èžºä»ªé�™æ­¢çŠ¶æ€�ä¸‹çš„é›¶å€¼å°†è¿™ä¸ªå€¼è®°å½•å�Ž
///////////////////////////////////////////////////////////////////////////////////
void zeroCalibrateGyroscope(uint16 totSamples, uint16 sampleDelayMS) 
{
   //////////////////////////////////////
   // é™€èžºä»ªITG- 3205çš„I2C
   // å¯„å­˜å™¨ï¼š
   // temp MSB = 1B, temp LSB = 1C
   // x axis MSB = 1D, x axis LSB = 1E
   // y axis MSB = 1F, y axis LSB = 20
   // z axis MSB = 21, z axis LSB = 22
   /////////////////////////////////////
  uint8 regAddress = 0x1D; // x axis MSB
  int16 xyz[3]; 
  float tmpOffsets[] = {0,0,0};
  uint8 buff[6];

  for (uint16 i = 0;i < totSamples;i++)
  {
    delay(sampleDelayMS);
    readFrom(GYRO, regAddress, 6, buff); //è¯»å�–é™€èžºä»ªITG3200 XYZè½´çš„æ•°æ�®
    xyz[0]= (((int16)buff[0] << 8) | buff[1]);
    xyz[1] = (((int16)buff[2] << 8) | buff[3]);
    xyz[2] = (((int16)buff[4] << 8) | buff[5]);
    tmpOffsets[0] += xyz[0];
    tmpOffsets[1] += xyz[1];
    tmpOffsets[2] += xyz[2];  
  }
  g_offx = -tmpOffsets[0] / totSamples;
  g_offy = -tmpOffsets[1] / totSamples;
  g_offz = -tmpOffsets[2] / totSamples;
}

////////////////////////////////////////////////////////////////////////////////////
//å‡½æ•°åŽŸåž‹:  void getGyroscopeRaw(int16 * result)  	     
//å�‚æ•°è¯´æ˜Ž:  * result : é™€èžºä»ªæ•°æ�®æŒ‡é’ˆ                                      
//è¿”å›žå€¼:    æ—                                                                
//è¯´æ˜Ž:      è¯»å�–ITG3205é™€èžºä»ªåŽŸå§‹æ•°æ�® åŠ ä¸Šé›¶ç‚¹ä¿®æ­£å€¼
///////////////////////////////////////////////////////////////////////////////////
void getGyroscopeRaw(int16 * result)
{
   //////////////////////////////////////
   // é™€èžºä»ªITG- 3200çš„I2C
   // å¯„å­˜å™¨ï¼š
   // temp MSB = 1B, temp LSB = 1C
   // x axis MSB = 1D, x axis LSB = 1E
   // y axis MSB = 1F, y axis LSB = 20
   // z axis MSB = 21, z axis LSB = 22
   /////////////////////////////////////

  uint8 regAddress = 0x1B;
//  int16 temp, x, y, z;
  uint8 buff[G_TO_READ];

  readFrom(GYRO, regAddress, G_TO_READ, buff); //è¯»å�–é™€èžºä»ªITG3200çš„æ•°æ�®

  result[0] = (((int16)buff[2] << 8) | buff[3]) + g_offx;
  result[1] = (((int16)buff[4] << 8) | buff[5]) + g_offy;
  result[2] = (((int16)buff[6] << 8) | buff[7]) + g_offz;
  result[3] = ((int16)buff[0] << 8) | buff[1]; // æ¸©åº¦
}

////////////////////////////////////////////////////////////////////////////////////
//å‡½æ•°åŽŸåž‹:  void getGyroscopeData(int16 * result)           	     
//å�‚æ•°è¯´æ˜Ž:  * result : é™€èžºä»ªæ•°æ�®æŒ‡é’ˆ                                      
//è¿”å›žå€¼:    æ—                                                                
//è¯´æ˜Ž:      è¯»å�–ITG3205é™€èžºä»ªè§’é€Ÿåº¦ï¼Œ å�•ä½�  åº¦æ¯�ç§’ Âº/s 
///////////////////////////////////////////////////////////////////////////////////
void getGyroscopeData(float * result)
{
  int16 buff[4];
  getGyroscopeRaw(&buff[0]);  //è¯»å�–åŽŸå§‹æ•°æ�®
  result[0] = buff[0] / 14.375; // ITG3205 14.375  LSB/(Âº/s) 
  result[1] = buff[1] / 14.375;
  result[2] = buff[2] / 14.375;
}
void GyroscopeTest(void)  //ITG3205åŠ é€Ÿåº¦è¯»å�–æµ‹è¯•ä¾‹å­�
{
    float gyro[3];
     initGyro();           //åˆ�å§‹åŒ–é™€èžºä»ª
    delay(1000);
    zeroCalibrateGyroscope(128,5);  //é›¶å€¼æ ¡æ­£ï¼Œè®°å½•é™€èžºä»ªé�™æ­¢çŠ¶æ€�è¾“å‡ºçš„å€¼å°†è¿™ä¸ªå€¼ä¿�å­˜åˆ°å��ç§»é‡�ï¼Œé‡‡é›†128æ¬¡ï¼Œé‡‡æ ·å‘¨æœŸ5ms
    while(1)
    {
      getGyroscopeData(gyro);    //è¯»å�–é™€èžºä»ª      
//      SerialUSB.print("Xg=");
      SerialUSB.print(micros());
      SerialUSB.print(",");
      SerialUSB.print(gyro[0]*1000);
      SerialUSB.print(",");
//      SerialUSB.print("Yg=");  
      SerialUSB.print(gyro[1]*1000);
      SerialUSB.print(",");
//      SerialUSB.print("Zg=");  
      SerialUSB.print(gyro[2]*1000);
      SerialUSB.println("");
      delay(100);
      toggleLED();
    }
}



