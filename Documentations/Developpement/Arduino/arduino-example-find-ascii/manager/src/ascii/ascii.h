#ifndef ASCII_H
#define ASCII_H

#include <Arduino.h>

class Ascii
{
    public:
        Ascii();

        void set(int byte);
        void toSerial();

    private:
        int m_byte;
};

#endif // ASCII_H