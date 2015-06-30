GPGGA initGPGGA()
{
  GPGGA result;
  result.time = 0.0;
  result.lat = 0.0;
  result.lon = 0.0;
  result.alt = 0.0;
  result.sat_num = 0;
  result.quality = '?';
  return result;
}

double str2double(char *data_buf,char num)//Data type converter：convert char type to float
{                                           //*data_buf:char data array ;num:float length
  double temp=0.0;
  unsigned char i,j;
 
  if(data_buf[0]=='-')//The condition of the negative
  {
    i=1;
    //The date in the array is converted to an integer and accumulative
    while(data_buf[i]!='.')
      temp=temp*10+(data_buf[i++]-0x30);
    for(j=0;j<num;j++)
      temp=temp*10+(data_buf[++i]-0x30);
    //The date will converted integer transform into a floating point number
    for(j=0;j<num;j++)
      temp=temp/10;
    //Converted to a negative number
    temp=0-temp;
  }
  else//Positive case
  {
    i=0;
    while(data_buf[i]!='.')
      temp=temp*10+(data_buf[i++]-0x30);
    for(j=0;j<num;j++)
      temp=temp*10+(data_buf[++i]-0x30);
    for(j=0;j<num;j++)
      temp=temp/10 ;
  }
  return temp;
}

unsigned GetGPSRaw (char *rawGPS, char ID[])
{
  byte i = 0;
  byte flag=0;
  unsigned ID_len = 7;
  char buff[ID_len];
  char temp;
 
  while(1)
  {
    while(Serial1.available())   
    { 
      if(!flag)
      { 
        buff[i] = Serial1.read();
          if(buff[i]==ID[i])
        {
          i++;
          if(i==ID_len)
          {
            i=0;
            flag=1;
          }
        }
        else
          i=0;
      }
      else
      { 
        temp = Serial1.read();
        if (temp != 13)
        { 
          rawGPS[i] = temp;
          i++;
        }
        else
        {
          rawGPS[i] = 0;
          return 1;
        }
      }
    }
  }
}

void indexing(char message[], unsigned index[])
{
  unsigned i = 0;
  unsigned j = 1; // word counter
//  SerialUSB.println(message);
  index[0] = 0;
  while (message[i] != '0')
  {
    if (message[i] == ',')
    {
      index[j] = i+1;
      j++;
    }
    i++;
  }
  index[j]=i;
}

// GPGGA sentence structure
/* $GPGGA,084746.00,4639.64861,N,00021.71397,E,1,04,2.74,97.6,M,47.0,M,,*66
          135815.00,4639.63904,N,00021.69408,E,1,08,1.10,141.0,M,47.0,M,,*58

/* $GPGGA,hhmmss.ss,ddmm.mmmmm,a,dddmm.mmmmm,a,x,xx,x.xx,xx.x,M,xx.x,M,x.x,xxxx
   ^      ^         ^          ^ ^           ^ ^ ^  ^    ^    ^ ^    ^ ^   ^   ^
  -1      0         1          2 3           4 5 6  7    8    9 0    1 2   3   4
 0: UTC of position
 1: latitude of position
 2: latitude direction (N or S)
 3: longitude of position
 4: longitude direction (E or W)
 5: GPS Quality indicator (0=no fix, 1=GPS fix, 2=Dif. GPS fix) 
 6: number of satellites in use
 7: horizontal dilution of precision 
 8: antenna altitude above mean-sea-level
 9: M - units of antenna altitude, meters 
10: Geoidal separation
11: M - units of geoidal separation, meters 
12: Age of Differential GPS data (seconds) 
13: checksum
*/

GPGGA parse_GPGGA(char message[])
{
  GPGGA result;
  unsigned int i;
  unsigned int j;
  unsigned int index[15];
  indexing(message, index);
  char time[9] = {'0','0','0','0','0','0','.','0','0'};
  int lon_d = 0; // degree part of longitude
  int lat_d = 0; // degree part of latitude
  char lon_m[8] = {'0','0','.','0','0','0','0','0'};
  char lat_m[8] = {'0','0','.','0','0','0','0','0'};
  char lon_dir = '?';
  char lat_dir = '?';
  char quality = '?';
  byte sat_num = 0;
  char alt_msl[8] = {'0','0','0','0','0','0','.','0'};
  char geo_sep[8] = {'0','0','0','0','0','0','.','0'};
  
  i=0; if (index[i+1]-1 > index[i]){ // UTC Time
      for (j=index[i];j<index[i+1]-1;j++) { time[j-index[i]] = message[j]; }} 
  i=5; if (index[i+1]-1 > index[i]){quality = message[index[i]];}
  i=6; if (index[i+1]-1 > index[i])
  {
    for (j=index[i];j<index[i+1]-1;j++) 
    {
      sat_num = sat_num*10 + (message[j]-0x30); 
    }
  }
  if (sat_num > 0)
  {
    i=1; if (index[i+1]-1 > index[i])
    { // Latitude
      lat_d = (message[index[i]]-0x30)*10 + (message[index[i]+1]-0x30);
      for (j=index[i]+2;j<index[i+1]-1;j++) { lat_m[j-index[i]-2] = message[j]; }
//      SerialUSB.println(lat_d);
//      SerialUSB.println(lat_m);
    }
    i=3; if (index[i+1]-1 > index[i]){ // Longitude
      lon_d = (message[index[i]]-0x30)*100 + (message[index[i]+1]-0x30)*10 + (message[index[i]+2]-0x30);
      for (j=index[i]+3;j<index[i+1]-1;j++) { lon_m[j-index[i]-3] = message[j]; }
//      SerialUSB.println(lon_d);
//      SerialUSB.println(lon_m);
    }
    i=2; if (index[i+1]-1 > index[i]){ // Latitude direction
      lat_dir = message[index[i]];}
    i=4; if (index[i+1]-1 > index[i]){ // Longitude direction
      lon_dir = message[index[i]];}
    i=8; if (index[i+1]-1 > index[i]){ // Antenna altitude above mean-sea-level
      for (j=index[i];j<index[i+1]-1;j++) { alt_msl[j-index[i]] = message[j]; }}
    i=10; if (index[i+1]-1 > index[i]){ // Geoidal separation
      for (j=index[i];j<index[i+1]-1;j++) { geo_sep[j-index[i]] = message[j]; }}
  }  
  result.time = str2double(time,2);
  result.lat = (lat_d + str2double(lat_m,5)/60);
  result.lon = (lon_d + str2double(lon_m,5)/60);
  if (lat_dir == 'S') { result.lat = - result.lat; }
  if (lon_dir == 'W') { result.lon = - result.lon; }
//  result.lat_dir = lat_dir;
//  result.lon_dir = lon_dir;
  result.alt = str2double(alt_msl,1)+str2double(geo_sep,1);
  result.quality = quality;
  result.sat_num = sat_num;

  return result;
}

void printGPGGA(GPGGA myGPGGA) //0: USB, 1: Serial1, 2: Serial2;
{
//printOnPort(myGPPA.time, 0);
  SerialUSB.print("      UTC:"); SerialUSB.println(myGPGGA.time,2);
  SerialUSB.print(" Latitude:"); SerialUSB.println(myGPGGA.lat,7); //SerialUSB.println(myGPGGA.lat_dir);
  SerialUSB.print("Longitude:"); SerialUSB.println(myGPGGA.lon,7); //SerialUSB.println(myGPGGA.lon_dir);
  SerialUSB.print(" Altitude:"); SerialUSB.println(myGPGGA.alt,1);
  SerialUSB.print("Sat. num.:"); SerialUSB.println(myGPGGA.sat_num);
  SerialUSB.print(" Q. index:"); SerialUSB.println(myGPGGA.quality);
}
