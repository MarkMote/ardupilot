/*******************************************
This is a test program used to develop a firmware 
Created by NGUYEN Anh Quang
*******************************************/

#include <stdlib.h>
#include <string.h>

#include <AP_Common.h>
#include <AP_Math.h>
#include <AP_Param.h>
#include <AP_Progmem.h>
#include <AP_HAL.h>

#include <AP_HAL_FLYMAPLE.h>


const AP_HAL::HAL& hal = AP_HAL_BOARD_DRIVER;

/* void test_snprintf_P() {
    char test[40];
    memset(test,0,40);
    hal.util->snprintf_P(test, 40, PSTR("hello %d from prog %f %S\r\n"),
            10, 1.2345, PSTR("progmem"));
    hal.console->write((const uint8_t*)test, strlen(test));

}

void test_snprintf() {
    char test[40];
    memset(test,0,40);
    hal.util->snprintf(test, 40, "hello %d world %f %s\r\n",
            20, 2.3456, "sarg");
    hal.console->write((const uint8_t*)test, strlen(test));
} */

void setup(void)
{
/*     hal.console->println("Utility String Library Test");
    hal.console->println("Test snprintf:");
    
    test_snprintf(); 
    
    hal.console->println("Test snprintf_P:");

    test_snprintf_P();

    hal.console->println("done"); */
    SerialUSB.println("This should be on screen");
    hal.console->println("May be this");
}

void loop(void) 
{
    SerialUSB.println("This should be on screen");
    hal.console->println("May be this");
    gcs_send_text_P(SEVERITY_LOW,PSTR("This is the last one"));
    cliSerial->println_P(PSTR("Maybe this will work"));
 }

AP_HAL_MAIN();