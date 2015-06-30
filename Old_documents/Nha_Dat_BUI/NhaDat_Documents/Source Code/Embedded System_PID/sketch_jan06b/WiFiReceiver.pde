/*********************************
 * Ground Station message        *
 * processor                     *
 * ============================= *
 * BUI Nha-Dat @ HCMUT/ENSMA     *
 * Quadricopter project          *
 * Last modified : 2014-Jan-10   *
 *                 15:00         *
 *********************************/
 // Required library: hexString

void readBlock(char *buff) // read into buffer until meet the <ETB> character
{
  byte EoB = 0;
  byte i = 0;
  char inByte;
  while (!EoB)
  {
    if (WiFiSerialPort.available())
    {
      inByte = WiFiSerialPort.read();
      if (inByte != ETB) // 0x17 : <ETB End of Transmitting Block> character
      {
        buff[i++] = inByte;
        buff[i] = 0;
      }
      else
        EoB = 1;
    }
  }
}

// message structure: $O[byte 0-7][byte 8-15][byte 16-23][byte 24-31]<EBT>
//                       orders[0] orders[1]  orders[2]   orders[3]
void parseOrders(char* inString, float* orders)
{
  orders[0] = decodeHex(&inString[0]);
  orders[1] = decodeHex(&inString[8]);
  orders[2] = decodeHex(&inString[16]);
  orders[3] = decodeHex(&inString[24]);
}

// message structure: $G0[byte 0-7][byte 8-15][byte 16-23]<EBT>
//                        gains[0]  gains[1]   gains[2]
void parseGains(char* inString, float* gains)
{
  gains[0] = decodeHex(&inString[0]);
  gains[1] = decodeHex(&inString[8]);
  gains[2] = decodeHex(&inString[16]);
}
