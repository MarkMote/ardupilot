// MODE_ULTRA_LOW_POWER    0 //oversampling=0, internalsamples=1, maxconvtimepressure=4.5ms, avgcurrent=3uA, RMSnoise_hPA=0.06, RMSnoise_m=0.5
// MODE_STANDARD           1 //oversampling=1, internalsamples=2, maxconvtimepressure=7.5ms, avgcurrent=5uA, RMSnoise_hPA=0.05, RMSnoise_m=0.4
// MODE_HIGHRES            2 //oversampling=2, internalsamples=4, maxconvtimepressure=13.5ms, avgcurrent=7uA, RMSnoise_hPA=0.04, RMSnoise_m=0.3
// MODE_ULTRA_HIGHRES      3 //oversampling=3, internalsamples=8, maxconvtimepressure=25.5ms, avgcurrent=12uA, RMSnoise_hPA=0.03, RMSnoise_m=0.25

const uint8 OSS = MODE_ULTRA_HIGHRES;  // Oversampling Setting

// Calibration values
int16 ac1;
int16 ac2; 
int16 ac3; 
uint16 ac4;
uint16 ac5;
uint16 ac6;
int16 b1; 
int16 b2;
int16 mb;
int16 mc;
int16 md;

int32 b5; 

int16 altCmOffset = 0;

void initBMP085()
{
  ac1 = bmp085ReadInt(BMP085_CAL_AC1);
  ac2 = bmp085ReadInt(BMP085_CAL_AC2);
  ac3 = bmp085ReadInt(BMP085_CAL_AC3);
  ac4 = bmp085ReadInt(BMP085_CAL_AC4);
  ac5 = bmp085ReadInt(BMP085_CAL_AC5);
  ac6 = bmp085ReadInt(BMP085_CAL_AC6);
  b1 = bmp085ReadInt(BMP085_CAL_B1);
  b2 = bmp085ReadInt(BMP085_CAL_B2);
  mb = bmp085ReadInt(BMP085_CAL_MB);
  mc = bmp085ReadInt(BMP085_CAL_MC);
  md = bmp085ReadInt(BMP085_CAL_MD);
}

void calibOffsetBMP085(uint16 samples)
{
  SerialUSB.print("-- Sample number for offset calibration: ");
  SerialUSB.println(samples);
  altCmOffset = 0;
  if (samples > 0)
  {
    int32 buff = 0;
    for (uint16 i=0; i<samples; i++) { buff -= acquireAltitude(); delay(5); }
    altCmOffset = buff/samples;
  }
  SerialUSB.print("-- Altitude offset: ");
  SerialUSB.print(altCmOffset);
  SerialUSB.println(" cm");
}

int16 bmp085ReadInt(uint8 address)
{
  uint8 buff[2];
  readFrom(BMP085_ADDRESS, address, 2, buff);
  return ((((int16)buff[0]) << 8) | buff[1]);
}

uint16 bmp085ReadUT()
{
  uint16 ut;
  writeTo(BMP085_ADDRESS, BMP085_CONTROL, READ_TEMPERATURE);
  delay(5); // Wait at least 4.5ms
  ut = bmp085ReadInt(BMP085_CONTROL_OUTPUT);
  return ut;
}

// Read the uncompensated pressure value
uint32 bmp085ReadUP()
{
  uint8 buff[3];
  uint32 up = 0;
  writeTo(BMP085_ADDRESS, BMP085_CONTROL, (READ_PRESSURE + (OSS<<6))); //
  delay(2 + (3<<OSS));   // Wait for conversion, delay time dependent on OSS
  readFrom(BMP085_ADDRESS, BMP085_CONTROL_OUTPUT, 3, buff);
  up = (((uint32) buff[0] << 16) | ((uint32) buff[1] << 8) | (uint32) buff[2]) >> (8-OSS);
  return up;
}

// Calculate temperature given ut.
// Value returned will be in units of 0.1 deg C
int16 bmp085GetTemperature(uint16 ut)
{
  int32 x1, x2;
  
  x1 = (((int32)ut - (int32)ac6)*(int32)ac5) >> 15;
  x2 = ((int32)mc << 11)/(x1 + md);
  b5 = x1 + x2;

  return ((b5 + 8)>>4);  
}

// Calculate pressure given up
// calibration values must be known
// b5 is also required so bmp085GetTemperature(...) must be called first.
// Value returned will be pressure in units of Pa.
int32 bmp085GetPressure(uint32 up)
{
  int32 x1, x2, x3, b3, b6, p;
  uint32 b4, b7;
  
  b6 = b5 - 4000;
  // Calculate B3
  x1 = (b2 * (b6 * b6)>>12)>>11;
  x2 = (ac2 * b6)>>11;
  x3 = x1 + x2;
  b3 = (((((int32)ac1)*4 + x3)<<OSS) + 2)>>2;
  
  // Calculate B4
  x1 = (ac3 * b6)>>13;
  x2 = (b1 * ((b6 * b6)>>12))>>16;
  x3 = ((x1 + x2) + 2)>>2;
  b4 = (ac4 * (uint32)(x3 + 32768))>>15;
  
  b7 = ((uint32)up - b3) * (50000>>OSS);
  if (b7 < 0x80000000)
    p = (b7<<1)/b4;
  else
    p = (b7/b4)<<1;
    
  x1 = (p>>8) * (p>>8);
  x1 = (x1 * 3038)>>16;
  x2 = (-7357 * p)>>16;
  p += (x1 + x2 + 3791)>>4;
  
  return p;
}

int32 acquireAltitude(void)
{
  int32 pressure = 0;
  int32 centimeters = 0;
  bmp085GetTemperature(bmp085ReadUT()); // call for calibrating b5
  pressure = bmp085GetPressure(bmp085ReadUP());
  centimeters =  (int32)(4433000 * (1 - pow(((float)pressure / (float)MSLP), 0.190295))) + altCmOffset;  
  return centimeters;
}

int32 pressure2altitude(int32 pressure)
{
  float altitude;
  altitude =  (int32)(4433000 * (1 - pow(((float)pressure / (float)MSLP), 0.190295))) + altCmOffset;  
  return altitude;
}
