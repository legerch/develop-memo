#include "src/ascii/ascii.h"

/*****************************/
/* Macro definitions         */
/*****************************/
#define SERIAL_BAUDRATE 115200

/*****************************/
/* Global variables          */
/*****************************/
Ascii m_currentAscii;

/*****************************/
/* Arduino routines          */
/*****************************/
void setup()
{
    /* Initialize serial */
    Serial.begin(SERIAL_BAUDRATE);
}

void loop()
{
    /* Wait to receive data and transmit ASCII serial infos */
    if(Serial.available() > 0){
        m_currentAscii.set(Serial.read());
        m_currentAscii.toSerial();
    }
}
