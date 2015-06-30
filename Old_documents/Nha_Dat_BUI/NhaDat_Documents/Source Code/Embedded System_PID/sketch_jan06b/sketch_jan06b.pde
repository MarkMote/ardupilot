/*********************************
 * Quadricopter                  *
 * MAIN PROGRAM : Task scheduler *
 * ============================= *
 * BUI Nha-Dat @ HCMUT/ENSMA     *
 * Fixed by NGUYEN Anh Quang     *
 * Quadricopter project          *
 * Last modified : 2015-Fev-25   *
 *                 12:00 AM      *
 *********************************/

#include <MapleFreeRTOS.h>
#include "FlyMaple.h"
#include "ADXL345.h"
#include "BMP085.h"
#include "kalman.h"
#include "wirish.h"
#include "i2c.h"
#include "WiFiMessage.h"
#include "PIDcontroller.h"

#define ROLL  0
#define PITCH 1
#define YAW   2
#define KP 0
#define KI 1
#define KD 2

#define ASSISTED 0
#define AUTO     1

HardwareSerial GPSSerialPort = Serial1;
HardwareSerial WiFiSerialPort = Serial2;
/*
 * Real time clocks
 */
const portTickType RTC1 = 100 / portTICK_RATE_MS; // main_task
const portTickType RTC2 = 100 / portTICK_RATE_MS; // altitude
const portTickType RTC3_short = 50 / portTICK_RATE_MS;  // GPS
const portTickType RTC3_long = 1000 / portTICK_RATE_MS;  // GPS
const portTickType RTC4 = 100 / portTICK_RATE_MS; // communicator
portTickType xLastWakeTime_Task1; // main task
portTickType xLastWakeTime_Task2; // acquiring altitude task
portTickType xLastWakeTime_Task3; // acquiring GPS task
portTickType xLastWakeTime_Task4; // communicator

/*
 * Memory modules (MDDs)
 */
float MDD_altitude = 0.0;
GPGGA MDD_GPSposition = initGPGGA();
float MDD_orders[4] = {0.0, 0.0, 0.0, 2.0};
float MDD_gains[9] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
float MDD_eulerAngles[3] = {0.0, 0.0, 0.0};
byte MDD_mode = ASSISTED;
xSemaphoreHandle xSem_altitude = NULL;
xSemaphoreHandle xSem_GPSposition = NULL;
xSemaphoreHandle xSem_orders = NULL;
xSemaphoreHandle xSem_gains = NULL;
xSemaphoreHandle xSem_eulerAngles = NULL;
xSemaphoreHandle xSem_mode = NULL;
xSemaphoreHandle xSem_USB = NULL;

/*
 *Variables for Gene-Auto PID
 */
//IO structure for the PIDcontroller block
t_PIDcontroller_io io;
//State structure for the PIDcontroller block
t_PIDcontroller_state state;

/*
 * Task definitions
 */
 
 
//do_read method
void do_read(const float time, const float *eulerAngles,
             const float altitude, const float *orders,
             const float *inGains, GAREAL *t, GAREAL *e, GAREAL *gains)
{
  *t=time;
  
  e[0]=(orders[0]-altitude)*M_PI/90;
  e[1]=(orders[1]-eulerAngles[0])*M_PI/90;
  e[2]=(orders[2]-eulerAngles[1])*M_PI/90;
  e[3]=(orders[3]-eulerAngles[2])*M_PI/90;
  
   for (int i=0; i<12; i++)
     gains[i]=inGains[i];
}

//do_write method
void do_write(GAREAL *y, float *controlSignals)
{
  for (byte i=0; i<4; i++)
    controlSignals[i]=y[i];
} 
 
 
void vTaskCalculateQuaternionsAndControlMotors(void *pvParameters)
{
  if ( xSemaphoreTake( xSem_USB, portMAX_DELAY) == pdTRUE )
  {
    SerialUSB.print("Task 1 scheduled.");
    xSemaphoreGive(xSem_USB);
  }
  xLastWakeTime_Task1 = xTaskGetTickCount();
  while (1)
  { 
    float q[4] = {1.0, 0.0, 0.0, 0.0};
    float eulerAngles[3] = {0.0, 0.0, 0.0};
    float altitude = 0.0;
    float gains[9] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
    float orders[4] = {0.0, 0.0, 0.0, 2.0};
    float motorData[4] = {0.0, 0.0, 0.0, 0.0}; // 0-1000
    
    AHRSgetQ(q);
    Q2E(q, eulerAngles);

        
    if ( xSemaphoreTake( xSem_altitude, portMAX_DELAY) == pdTRUE ) // Reading MDD: MDD_gains
    {
      altitude = MDD_altitude;
      xSemaphoreGive(xSem_altitude);
    } 
    if ( xSemaphoreTake(xSem_orders, portMAX_DELAY) == pdTRUE ) // Reading MDD: MDD_orders
    {
      orders[0] = MDD_orders[0];
      orders[1] = MDD_orders[1];
      orders[2] = MDD_orders[2];
      orders[3] = MDD_orders[3];
      xSemaphoreGive(xSem_orders);
    }
    if ( xSemaphoreTake( xSem_gains, portMAX_DELAY) == pdTRUE ) // Reading MDD: MDD_gains
    {
      gains[0] = MDD_gains[0];  /* K_type_mode = gains[mode*3 + type] */
      gains[1] = MDD_gains[1];  /* K_I_roll = gains[ROLL*3 + KI] ...  */
      gains[2] = MDD_gains[2];
      gains[3] = MDD_gains[3];
      gains[4] = MDD_gains[4];
      gains[5] = MDD_gains[5];
      gains[6] = MDD_gains[6];
      gains[7] = MDD_gains[7];
      gains[8] = MDD_gains[8];
      xSemaphoreGive(xSem_gains);
    }
    
    /*PID Flight Controller Integration
     *
     *Input  : eulerAngles, altitude, orders, gains
     *Output : controlSignals
     *
     * read-compute-write cycle
     */
    int size_controlSignals=4;
    float controlSignals[size_controlSignals]; 
    float time=(float) millis()*1000; //get the current time in seconds
    do_read(time, eulerAngles, altitude, orders, gains, &(io.t), (io.e), (io.gains));
    do_write((io.y), controlSignals);
    
    SerialUSB.println("Test output");
    SerialUSB.println(controlSignals[1]);
    SerialUSB.println(controlSignals[3]);
    
   //End of Integration 
    
    calculateMotorData(controlSignals, motorData); // Calculating PWM signals
    
    controlMotors(motorData); // Send PWM singals to motors
    
   /* SerialUSB.println("Running"); */
     
    if ( xSemaphoreTake(xSem_eulerAngles, portMAX_DELAY ) == pdTRUE ) // Updating MDD: MDD_eulerAngles
    {
      MDD_eulerAngles[0] = eulerAngles[0];
      MDD_eulerAngles[1] = eulerAngles[1];
      MDD_eulerAngles[2] = eulerAngles[2];
      xSemaphoreGive(xSem_eulerAngles);
    }

    vTaskDelayUntil( &xLastWakeTime_Task1, RTC1 );
  }
}

void vTaskAcquireAltitude(void *pvParameters)
{
  float altitude = 0.0;

//  if ( xSemaphoreTake( xSem_USB, portMAX_DELAY) == pdTRUE ) 

    SerialUSB.print("Task 2 scheduled.");
//    xSemaphoreGive (xSem_USB);
//  }
  
  xLastWakeTime_Task2 = xTaskGetTickCount();
  while (1)
  {
    altitude = (float)((int)((float)(acquireAltitude()/10)))/10; // round the value up to 0.1 m
 
    if ( xSemaphoreTake( xSem_altitude, portMAX_DELAY) == pdTRUE )
    {
      MDD_altitude = altitude;
      xSemaphoreGive(xSem_altitude);
    }

    vTaskDelayUntil( &xLastWakeTime_Task2, RTC2 );
  }
}


void vTaskAcquireGPS(void *pvParameters)
{
  unsigned buff_size = 80; // actually GPGGA sentence is only 72 bytes length max
  char buff[buff_size];
  GPGGA GPSposition = initGPGGA();
  
//  synchronizing with the period of GPS signal
  Serial1.flush(); // skip the current period
  while (!Serial1.available()) {}; // wait for the first byte of the next period come
//  period started --- begin scheduling
  
  SerialUSB.print("Task 3 scheduled.");
 
  xLastWakeTime_Task3 = xTaskGetTickCount();
  while (1)
  {
    if (Serial1.available())
    {
      GetGPSRaw(buff,"$GPGGA,");
      GPSposition = parse_GPGGA(buff);
      if ( xSemaphoreTake( xSem_GPSposition, portMAX_DELAY ) == pdTRUE )
      {
        MDD_GPSposition = GPSposition;
        xSemaphoreGive(xSem_GPSposition);
      }
      delay(100); Serial1.flush(); // Wait 100 ms for the rest of GPS messages completely come before flushing.
      vTaskDelayUntil( &xLastWakeTime_Task3, RTC3_long );     
    }
    else
    {
//      Do nothing, wait for the next period.
      vTaskDelayUntil( &xLastWakeTime_Task3, RTC3_short );
    }

  }
}


void vTaskCommunicator(void *pvParameters)
{
  // Receiver variables
  byte EoM = 1;  // End of Message flag
  byte flag = 0; // dollar sign found flag
  byte dataFlag = 0; // 0: no data recieved.     b x 0000 = 0x00
                     // 1: orders received.      b x 0001 = 0x01
                     // 2: gains received.       b x 0010 = 0x02
                     // 4: mode received.        b x 0100 = 0x04
                     // 3: (1+2) orders & gains  b x 0011 = 0x03
                     // 5: (1+4) orders & mode   b x 0101 = 0x05
                     // 6: (2+4) gains & mode    b x 0110 = 0x06
                     // 7: (1+2+4) O & G & M     b x 0111 = 0x07
  char inByte;
  
  char rawOrders[36];    // 4 x 8 bytes = 32 bytes max
  char rawGainsYaw[27];  // 3 x 8 bytes = 24 max
  char rawGainsPitch[27];// 24
  char rawGainsRoll[27]; // 24
  byte mode;
  
  float orders[4] = {0.0, 0.0, 0.0, 2.0};
  float gains[9] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
  

  if ( xSemaphoreTake( xSem_USB, portMAX_DELAY) == pdTRUE ) 
  {
    SerialUSB.print("Task 4 scheduled.");
    xSemaphoreGive(xSem_USB);
  }
  xLastWakeTime_Task4 = xTaskGetTickCount();
  while (1)
  {
    // === Sender ================================================================================================== 
    Serial2.print("$");
    Serial2.print(micros(),HEX);
    Serial2.print(" ");
    if ( xSemaphoreTake(xSem_eulerAngles, portMAX_DELAY ) == pdTRUE ) // Updating MDD: MDD_eulerAngles
    {
      serial2FloatPrint(MDD_eulerAngles[0]); Serial2.print(" ");
      serial2FloatPrint(MDD_eulerAngles[1]); Serial2.print(" ");
      serial2FloatPrint(MDD_eulerAngles[2]); Serial2.print(" ");
      xSemaphoreGive(xSem_eulerAngles);
    }
    if ( xSemaphoreTake(xSem_altitude, portMAX_DELAY ) == pdTRUE ) // Updating MDD: MDD_eulerAngles
    {
      serial2FloatPrint(MDD_altitude); Serial2.print(" ");
      xSemaphoreGive(xSem_altitude);
    }
    if ( xSemaphoreTake(xSem_GPSposition, portMAX_DELAY ) == pdTRUE ) // Updating MDD: MDD_eulerAngles
    {
      serial2FloatPrint(MDD_GPSposition.time); Serial2.print(" ");
      serial2FloatPrint(MDD_GPSposition.lon); Serial2.print(" ");
      serial2FloatPrint(MDD_GPSposition.lat); Serial2.print(" ");      
      serial2FloatPrint(MDD_GPSposition.alt); Serial2.print(" ");
      Serial2.print(MDD_GPSposition.sat_num, HEX); Serial2.print(" ");
      Serial2.print(MDD_GPSposition.quality); Serial2.print(" ");
      xSemaphoreGive(xSem_GPSposition);
    }
//    Serial2.print(micros());
    Serial2.println();
    // === End of Sender ===========================================================================================
    // === Receiver ================================================================================================      
    while (WiFiSerialPort.available())
    {
    if ( xSemaphoreTake( xSem_USB, portMAX_DELAY) == pdTRUE ) 
    {
      dataFlag = 0; // reset flag
      char bytein = WiFiSerialPort.read();
      SerialUSB.println(bytein);
      if (bytein == STX) // 0x02 : <STX Start of Text> character
        EoM = 0; // flag
      while (!EoM)
      {
        if (WiFiSerialPort.available())
        {
          inByte = WiFiSerialPort.read();
          if (!flag)
          {
            if (inByte == 0x24) // 0x24 : dollar sign '$'
              flag = 1;
          }
          else
          {
            if (inByte == ORDER) // 0x4F : 'O' --- Order block
            {
              readBlock(rawOrders);
              dataFlag = dataFlag + 1;
            }
            else if (inByte == GAINS) // 0x47 : 'G' --- Gains block
            {
              while (!WiFiSerialPort.available()) {} // if not any byte is availabled on serial port, then wait
              inByte = WiFiSerialPort.read();
              if (inByte == (0x30 + ROLL)) { readBlock(rawGainsRoll); }
              else if (inByte == (0x30 + PITCH)) { readBlock(rawGainsPitch); }
              else if (inByte == (0x30 + YAW)) { readBlock(rawGainsYaw); }
              dataFlag = dataFlag + 2;
            }
            else if (inByte == MODE) // 0x4D : 'M' --- Mode block
            {
              while (!WiFiSerialPort.available()) {} // if not any byte is availabled on serial port, then wait
              mode = WiFiSerialPort.read() - 0x30;   // 0x30 - '0'
              dataFlag = dataFlag + 4;
            }
            else if (inByte == EOT) // 0x04 : <EoT End of Transmission> character
              EoM = 1;
  //          else {} // do nothing
          }        
        }
        toggleLED();
      }
      // Update memory modules
      if (dataFlag&1) { // Update MDD_Orders
        SerialUSB.println(rawOrders);
        if ( xSemaphoreTake( xSem_orders, portMAX_DELAY) == pdTRUE ) { // Write MDD: MDD_orders
          parseOrders(rawOrders, MDD_orders);
          xSemaphoreGive(xSem_orders); }}
      if (dataFlag&2) { // Update MDD_Gains
        SerialUSB.println("Gains:");
        SerialUSB.println(rawGainsRoll);
        SerialUSB.println(rawGainsPitch);
        SerialUSB.println(rawGainsYaw);
        if ( xSemaphoreTake( xSem_gains, portMAX_DELAY) == pdTRUE ) { // Write MDD: MDD_gains 
          parseGains(rawGainsRoll, &MDD_gains[ROLL*3]);
          parseGains(rawGainsPitch, &MDD_gains[PITCH*3]);
          parseGains(rawGainsYaw, &MDD_gains[YAW*3]);
          xSemaphoreGive(xSem_gains);}}
      if (dataFlag&4) { // Update MDD_Mode
        SerialUSB.print("Mode : ");
        SerialUSB.println(mode);
        if ( xSemaphoreTake( xSem_mode, portMAX_DELAY) == pdTRUE ) {
        MDD_mode = mode;
        xSemaphoreGive(xSem_mode); }
      }
    xSemaphoreGive(xSem_USB); /////
    } /////

    }
    // === End of Reciever =========================================================================================
    toggleLED();

    vTaskDelayUntil( &xLastWakeTime_Task4, RTC4 );
  }
}

    
    
void setup ()
{
  pinMode(BOARD_LED_PIN, OUTPUT);
  toggleLED();
  delay (1000);
  // Init code

  initAHRS(); //<--- NEVER FORGET THIS !!! --->

  SerialUSB.println("=== FreeRTOS parameters =============");
  SerialUSB.print("        portTICK_RATE_MS: ");
  SerialUSB.println(portTICK_RATE_MS);
  SerialUSB.print("configMINIMAL_STACK_SIZE: ");
  SerialUSB.println(configMINIMAL_STACK_SIZE);
  SerialUSB.print("        tskIDLE_PRIORITY: ");
  SerialUSB.println(tskIDLE_PRIORITY);
  SerialUSB.print("           portMAX_DELAY: ");
  SerialUSB.println(portMAX_DELAY);
  
  Serial1.begin(9600);   // GPS Serial port :: GPS baud rate --- stricted value!!!
  Serial2.begin(115200); // Wi-Fi Serial port
  
  toggleLED();
  delay(3000);
  SerialUSB.println("=====================================");
  
  // End of init code
  
  /* Initialise the system*/
  PIDcontroller_init(&state);
  
  //Creating mutexes
  xSem_altitude = xSemaphoreCreateMutex();
  xSem_GPSposition = xSemaphoreCreateMutex();
  xSem_orders = xSemaphoreCreateMutex();
  xSem_gains = xSemaphoreCreateMutex();
  xSem_eulerAngles = xSemaphoreCreateMutex();
  xSem_mode = xSemaphoreCreateMutex();
  xSem_USB = xSemaphoreCreateMutex();
  
  // Creating tasks
    xTaskCreate(vTaskCalculateQuaternionsAndControlMotors, (signed char *) "main_task",
    configMINIMAL_STACK_SIZE+256, NULL, tskIDLE_PRIORITY+1, NULL);
      
   xTaskCreate(vTaskAcquireAltitude, (signed char *) "acquireAltitude",
    configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY+2, NULL);
  
    xTaskCreate(vTaskAcquireGPS, (signed char *) "acquireGPS",
     configMINIMAL_STACK_SIZE+128, NULL, tskIDLE_PRIORITY, NULL);
      
    xTaskCreate(vTaskCommunicator,(signed char *) "communicator",
    configMINIMAL_STACK_SIZE+256, NULL, tskIDLE_PRIORITY+3, NULL);
    
       
 //Start scheduling
  vTaskStartScheduler();
 // End of code
  
  
}
void loop() 
{ }//This loop will never be reached.
