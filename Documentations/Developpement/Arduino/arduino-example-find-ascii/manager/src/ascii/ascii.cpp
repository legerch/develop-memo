#include "ascii.h"

/*****************************/
/* Class documentations      */
/*****************************/

/*!
 * @brief Class used to manage ascii characters.
 *
 * @author Charlie LEGER
 * @date 30-08-2022
 * 
 */

/*****************************/
/* Macro definitions         */
/*****************************/

/*****************************/
/* Enum documentations       */
/*****************************/

/*****************************/
/* Structure documentations  */
/*****************************/

/*****************************/
/* Functions implementation  */
/*****************************/

Ascii::Ascii()
{
    
}

void Ascii::set(int byte)
{
    m_byte = byte;
}

void Ascii::toSerial()
{
    Serial.write(m_byte);

    Serial.print(", dec: ");
    Serial.print(m_byte);

    Serial.print(", hex: ");
    Serial.print(m_byte, HEX);

    Serial.print(", oct: ");
    Serial.print(m_byte, OCT);

    Serial.print(", bin: ");
    Serial.println(m_byte, BIN);
}