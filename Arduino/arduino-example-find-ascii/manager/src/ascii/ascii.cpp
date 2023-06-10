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

/**
 * \brief Use to initialize an Ascii objec
 * \details
 * Constructor only initialize byte to \c 0.
 */
Ascii::Ascii()
{
    m_byte = 0;
}

/**
 * \brief Use to set byte
 */
void Ascii::set(int byte)
{
    m_byte = byte;
}

/**
 * \brief Use to write to serial Ascii object at multiple formats
 * \details
 * This method will write on serial byte value at multiple formats:
 * - Raw
 * - Decimal
 * - Hexadecimal
 * - Octal
 * - Binary
 */
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

/*******************************/
/* End function implementation */
/*******************************/