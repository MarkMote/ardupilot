int inByte;

void setup() 
{
  pinMode(BOARD_LED_PIN, OUTPUT);
  Serial2.begin(115200);
}

void loop() {
    byte datain = 0;
    while (SerialUSB.available()) {
      inByte = SerialUSB.read();
      Serial2.print(inByte, BYTE);
      datain = 1;
    }
    if (datain) {
      Serial2.println(); 
      datain = 0;
      toggleLED();
    }
    
    while (Serial2.available()) {
      inByte = Serial2.read();
      SerialUSB.print(inByte, BYTE);
      toggleLED();
    }
}
