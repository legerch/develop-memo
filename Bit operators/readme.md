# Bit operators

**As a reminder :**
- 1 byte = 8 bits

## Utils

- How to display byte content of variable :
```C
void printByteByByteValue(void *value, size_t sizeOfValue){
    uint8_t *pByte = value;

    printf("Value (size:%ld) : ", sizeOfValue);
    while (sizeOfValue--) {
        printf("%02x ", *pByte++);
    }
    printf("\n");
}
```

- How to know if platform if _Big Endian_ or _Little Endian_ :
```C
/* With function */
int isLittleEndian(){
    int n = 1;
    return ( (*(char *)&n) == 1);
}

/* With macro using GCC compiler */
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    #define IS_LITTLE_ENDIAN
#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
    #define IS_BIG_ENDIAN
#elif __BYTE_ORDER__ == __ORDER_PDP_ENDIAN__
    #define IS_PDP_ENDIAN
#endif

/* With macro (use multi-character constant) */
#define LITTLE_ENDIAN 0x41424344UL 
#define BIG_ENDIAN    0x44434241UL
#define PDP_ENDIAN    0x42414443UL
#define ENDIAN_ORDER  ('ABCD') 

#if ENDIAN_ORDER==LITTLE_ENDIAN
    #define IS_LITTLE_ENDIAN
#elif ENDIAN_ORDER==BIG_ENDIAN
    #define IS_BIG_ENDIAN
#elif ENDIAN_ORDER==PDP_ENDIAN
    #define IS_PDP_ENDIAN
#endif
```

## Conversion

- Convert `uint16` to `uint8[2]`:
```C
/* From uint16 to uint8[2] */
uint16_t u16Value = 789; /* 789 (10) = 0x0315 (16) = 0000 0011 0001 0101 (2) */
uint8_t u8Value[2];

u8Value[0]=(uint8_t)(u16Value & 0xff); /* u8Value[0] = (uint8_t) (0000 0011 0001 0101 & 0000 0000 1111 1111) 
                                                     = (uint8_t) (0000 0000 0001 0101)
                                                     = (0001 0101) */

u8Value[1]=(uint8_t)((u16Value >> 8) & 0xff); /* u8Value[1] = (uint8_t) ( (0000 0011 0001 0101 >> 8) & 0000 0000 1111 1111) 
                                                     = (uint8_t) (0000 0000 0000 0011 & 0000 0000 1111 1111)
                                                     = (uint8_t) (0000 0000 0000 0011)
                                                     = (0000 0011) */

/* From uint8[2] to uint16 */
uint16_t u16ValueRebuild = (u8Value[1] << 8) | u8Value[0]; /* = (0000 0011 << 8) | (0001 0101)
                                                              = (0000 0011 0000 0000) | (0001 0101)
                                                              = (0000 0011 0001 0101) */
```

- Convert `uint16[2]` to `uint8[3]` : In case if values are 12-bits (but store on 16-bits) and convert 2 12-bits values to 3 8bits values :
```C
#define SIZE_BUFFER 3
#define NB_ELEMENTS 2

uint16_t u16Values[NB_ELEMENTS] = {
    789; /* 789 (10) = 0x0315 (16) = 0000 0011 0001 0101 (2) */
    511; /* 511 (10) = 0x01FF (16) = 0000 0001 1111 1111 (2) */
};

uint8_t buf[SIZE_BUFFER] = {0};
uint8_t val1, val_2_1, val_2_2, val2, val3;

/* 1st value */
val1 = (uint8_t)(u16Values[1] & 0x00FF); /* val1 = (uint8_t)(0000 0001 1111 1111 & 0000 0000 1111 1111)
                                                 = (uint8_t)(0000 0000 1111 1111)
                                                 = (1111 1111) */

/* 2nd value */
val_2_1 = (uint8_t)( (u16Values[1] >> 8) & 0x00FF ); /* val_2_1 = (uint8_t)( (0000 0001 1111 1111 >> 8) & 0000 0000 1111 1111 )
                                                                = (uint8_t)( (0000 0000 0000 0001) & 0000 0000 1111 1111 )
                                                                = (uint8_t)(0000 0000 0000 0001)
                                                                = (0000 0001) */

val_2_2 = (uint8_t)( (u16Values[0] << 4) & 0x00F0 ); /* val_2_2 = (uint8_t)( (0000 0011 0001 0101 << 4) & 0000 0000 1111 0000 )
                                                                = (uint8_t)( (0011 0001 0101 0000) & 0000 0000 1111 0000 )
                                                                = (uint8_t)(0000 0000 0101 0000)
                                                                = (0101 0000) */

val2 = val_2_1 | val_2_2; /* val2 = (0000 0001) | (0101 0000)
                                  = (0101 0001) */

/* 3rd value */
val3 = (uint8_t)( (u16Values[0] >> 4) & 0x00FF ); /* val3 = (uint8_t)( (0000 0011 0001 0101 >> 4) & 0000 0000 1111 1111)
                                                          = (uint8_t)( (0000 0000 0011 0001) & 0000 0000 1111 1111)
                                                          = (uint8_t)(0000 0000 0011 0001)
                                                          = (0011 0001) */

buf[0] = val3; /* (1111 1111) */
buf[1] = val2; /* (0101 0000) */
buf[2] = val1; /* (0011 0001) */
```

## Bit-field

See this courses for more details about **bit-fields** :
- http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/2-C-adv-data/bit-field.html (or [here](course_mathcs_bit-field.html) if unavailable)
- https://www.tutorialspoint.com/cprogramming/c_bit_fields.htm

## Bit-array

The **C-programming** language doesn't provide support for array of bits, but all the necessary operations are provided.
See this course for more details : http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/1-C-intro/bit-array.html (or [here](course_mathcs_bit-array.html) if unavailable)

Below, modified macro to be compatible with any type for bit-array container. In the course, we use an array of int32, with this, we could use an array of int8 if we want.

1. Macro definitions
```C
#define setBit(A,bitIndex,nbBits)     ( A[(bitIndex/nbBits)] |= (1 << ( (nbBits -1)-(bitIndex%nbBits)) ) )
#define clearBit(A,bitIndex,nbBits)   ( A[(bitIndex/nbBits)] &= ~(1 << ( (nbBits -1)-(bitIndex%nbBits)) ) )
#define testBit(A,bitIndex,nbBits)    ( A[(bitIndex/nbBits)] & (1 << ( (nbBits -1)-(bitIndex%nbBits)) ) )
```

2. How to use
```C
#define BIT_ARRAY_NB_BITS       80 /* We choose to use 80 bits. BIT_ARRAY_NB_BITS must be divisible by BIT_ARRAY_TYPE_NB_BITS */
#define BIT_ARRAY_TYPE_NB_BITS  8 /* We choose to use uint8_t to store bit-array */
    
#define BIT_ARRAY_SIZE          ( (BIT_ARRAY_NB_BITS)/(BIT_ARRAY_TYPE_NB_BITS) ) /* As result, we need 10 uin8_t to store 80 bits */

uint8_t bitArray[BIT_ARRAY_SIZE] = {0};

/* Set 3 bits */
printf("Set bit for position : 20, 45 and 70\n");
setBit(bitArray, 20, BIT_ARRAY_TYPE_NB_BITS);
setBit(bitArray, 45, BIT_ARRAY_TYPE_NB_BITS);
setBit(bitArray, 70, BIT_ARRAY_TYPE_NB_BITS);

/* Check if setBit() works */
for (int i=0; i<BIT_ARRAY_NB_BITS; i++){
    if ( testBit(bitArray, i, BIT_ARRAY_TYPE_NB_BITS) ){
        printf("Bit %d was set !\n", i);
    }
}

/* Clear 1 bit */
printf("\nClear bit for position : 45 \n");
clearBit(bitArray, 45, BIT_ARRAY_TYPE_NB_BITS);

/* Check if clearBit() works */
for (int i=0; i<BIT_ARRAY_NB_BITS; i++){
    if ( testBit(bitArray, i, BIT_ARRAY_TYPE_NB_BITS) ){
        printf("Bit %d was set !\n", i);
    }
}
```

# Useful links
- https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html
- http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/2-C-adv-data/bit-field.html
- http://www.mathcs.emory.edu/~cheung/Courses/255/Syllabus/1-C-intro/bit-array.html
- https://www.tutorialspoint.com/cprogramming/c_bit_fields.htm
