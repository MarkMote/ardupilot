/*********************************
 * hex-float library             *
 * ============================= *
 * BUI Nha-Dat @ HCMUT/ENSMA     *
 * Quadricopter project          *
 * Last modified : 2014-Jan-10   *
 *********************************/

byte hexChar2byte(const char inChar) {
  if ((inChar >= 0x30) && (inChar <= 0x39))
    return (byte)(inChar - '0');
  else if ((inChar >= 0x41) && (inChar <= 0x46))
    return (byte)(inChar - 'A' + 10);
  else if ((inChar >= 0x61) && (inChar <= 0x66))
    return (byte)(inChar - 'a' + 10);
  else return 0;
}

byte hex2byte(const char inChar1, const char inChar2) {
  return hexChar2byte(inChar1)*16 + hexChar2byte(inChar2);}

float decodeHex(const char *inString) {
  //  result:  [byte1]  [byte2]  [byte3]  [byte4]
  //       b x 00000000-00000000-00000000-00000000
  //           ^        ^        ^        ^
  //           b[0]     b[1]     b[2]     b[3]
  float result;
  byte *b = (byte*)&result; //address of first byte of the result
  b[0] = hex2byte(inString[0], inString[1]);
  b[1] = hex2byte(inString[2], inString[3]);
  b[2] = hex2byte(inString[4], inString[5]);
  b[3] = hex2byte(inString[6], inString[7]);
  return result;
}
