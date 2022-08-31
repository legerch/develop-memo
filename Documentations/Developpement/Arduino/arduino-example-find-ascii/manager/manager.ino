#include "src/ascii/ascii.h"

/** \file manager.ino */

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

/**
 * \brief Used when sketch is started, this method
 * will be called only once.
 * \details
 * We only initialize serial communication.
 */
void setup()
{
    /* Initialize serial */
    Serial.begin(SERIAL_BAUDRATE);
}

/**
 * \brief Loops loops consecutively
 * \details
 * We check for serial data, if any input, received character
 * is send in serial with all available format (HEX, BIN, etc...).  
 * If no data, no action is performed.
 */
void loop()
{
    /* Wait to receive data and transmit ASCII serial infos */
    if(Serial.available() > 0){
        m_currentAscii.set(Serial.read());
        m_currentAscii.toSerial();
    }
}
