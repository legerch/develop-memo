**Table of contents :**

- [1. Tips](#1-tips)
  - [1.1. Printf](#11-printf)
  - [1.2. Enum errors](#12-enum-errors)
  - [1.3. Buffer](#13-buffer)
  - [1.4. String](#14-string)
- [2. Useful links](#2-useful-links)


# 1. Tips

## 1.1. Printf

- Indent output :
```C
fprintf(stream, "%*My output with decimal value : %d", 3, "", 42);
/*
 * Will print (note indentation of 3 spaces) :
 *    My output with decimal value : 42
 */ 
```

- Format specific datas :
```C
// Format at hexadecimal format : 42 -> 0x2A
fprintf(stream, "Hexadecimal value : 0x%02x", 42);
// Format for type size_t
fprintf(stream, "size_t value : zd", 42);
```
> More details here : https://www.gnu.org/software/libc/manual/html_node/Integer-Conversions.html

## 1.2. Enum errors

In this case, we want negative errors value. This way, for function using this enums as returned value, if value is positive, operation is successful, otherwise, it failed.

- Define enumeration
```C
typedef enum{
  NETM_ERR_NO_ERROR = 0,
  NETM_ERR_FD_OPEN = -1,
  NETM_ERR_FD_PROPERTY = -2,
  NETM_ERR_SOCKET_CFG = -3,
  NETM_ERR_SOCKET_BIND = -4,
  NETM_ERR_SOCKET_LISTEN = -5,
  NETM_ERR_INVALID_VALUE = -6,
  NETM_ERR_MEMORY = -7,
  NETM_ERR_EPOLL_MANAGEMENT = -8,
  NETM_ERR_MSG_WAIT = -9,
  NETM_ERR_MSG_READ = -10,
  NETM_ERR_MSG_WRITE = -11,
  NETM_ERR_CLI_MAX = -12,
  NETM_ERR_CLI_CONNECT_FAILED = -13,
  NETM_ERR_CLI_CUR_SELECTED = -14,
  NETM_ERR_NB_ERRORS = -15
}NETM_enuErrors;
```

- Define array to store string equivalent (prefer static memory). Enum values are use like index array :
```C
static const char *arrayEnumNetErrorToString[] = {
    "No error",			                            /* NETM_ERR_NO_ERROR */
    "File descriptor opening error",                /* NETM_ERR_FD_OPEN */
    "File descriptor setting property error",       /* NETM_ERR_FD_PROPERTY */
    "Socket configuration error",                   /* NETM_ERR_SOCKET_CFG */
    "Socket bind error",                            /* NETM_ERR_SOCKET_BIND */
    "Socket listening error",                       /* NETM_ERR_SOCKET_LISTEN */
    "Invalid value error",                          /* NETM_ERR_INVALID_VALUE */
    "Memory error",                                 /* NETM_ERR_MEMORY */
    "Epoll management error",                       /* NETM_ERR_EPOLL_MANAGEMENT */
    "Error while waiting for message",              /* NETM_ERR_MSG_WAIT */
    "Error while reading message",                  /* NETM_ERR_MSG_READ */
    "Error while writing message",                  /* NETM_ERR_MSG_WRITE */
    "Maximum number of client is already reached",  /* NETM_ERR_CLI_MAX */
    "Failed to connect to client",                  /* NETM_ERR_CLI_CONNECT_FAILED */
    "Error with current client",                    /* NETM_ERR_CLI_CUR_SELECTED */
    "Unknown error",	                            /* NETM_ERR_NB_ERRORS */
};
```

- Create function to get string equivalent
```C
/*----------------------------------------------------------------------------*/
/**
 * \brief       Use to convert network manager error to string  
 *
 * \param[in]   NETM_enuErrors enuError : Error to convert
 *
 * \return      const char * : String representation of error
 */
/*----------------------------------------------------------------------------*/
const char *NETM_enuErrors_getString(NETM_enuErrors enuError)
{
    int valueError = -enuError;
    if(valueError >= (-NETM_ERR_NB_ERRORS) || valueError < 0){
        return arrayEnumNetErrorToString[(-NETM_ERR_NB_ERRORS)];
    }

    return arrayEnumNetErrorToString[valueError];
}
```

## 1.3. Buffer

- Print all buffer values at hexadecimal format :
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief      Print variable value byte by byte in hexadecimal format
 * \details    NA
 *             
 * \param[in] void *value
 * 	Pointer value, must be not NULL.
 * \param[in] size_t sizeOfValue
 * 	Number of bytes of value.
 * \param[in] FILE *fdOutput
 * 	File descriptor opened of stream output.
 *
 * \param[out] NA
 * \return     NA
 *
 * \warning    NA
 * \note       NA
 */
/*---------------------------------------------------------------------------*/
void HTOOLS_vPrintByteByByteValue(void *value, size_t sizeOfValue, FILE *fdOutput){
    uint8_t *pByte = value;

    fprintf(fdOutput, "Value (size:%zu) : ", sizeOfValue);

    while(sizeOfValue--) {
        fprintf(fdOutput, "%02x ", *pByte++);
    }

    fprintf(fdOutput, "\n");
    fflush(fdOutput);
}
```

## 1.4. String

Functions [`asprintf`](https://linux.die.net/man/3/vasprintf) and [`vasprintf`](https://linux.die.net/man/3/asprintf) are GNU extensions, not in C or POSIX.  
We can use those functions or define own implementations :

- **asprintf()** :
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief      Use to allocate a string into a buffer with additional arguments
 * \details    
 * This function is analog of \c sprintf(), except that it allocate a string large enough to hold the output including the terminating null byte, 
 * and return a pointer to it via the first argument. \n
 * This pointer should be passed to \c free() to release the allocated storage when it is no longer needed. 
 * 
 * You can also use \c asprintf() function, which is available in GNU Extensions, we can found here : https://linux.die.net/man/3/asprintf
 *             
 * \param[in] const ci_char_t *formatStr
 * 	C string that contains a format string that follows the same specifications as format in printf. \n
 * 	This value must be not NULL.
 * \param[in] ... (additional arguments)
 * 	Depending on the format string, the function may expect a sequence of additional arguments, each containing a value to be used to replace a format specifier in the format string. \n
 *	There should be at least as many of these arguments as the number of values specified in the format specifiers. Additional arguments are ignored by the function.
 *
 * \param[out] ci_char_t ci_char_t **pStr : Pointer to string buffer destination. \n
 * This value is set to NULL if function failed, otherwise the buffer is allocated, filled with \c formatStr value and always null-terminated.
 * 
 * \return     ci_int32_t : -1 in case of error, else 0 
 *
 * \warning    The return pointer must be \c free() to release the allocated storage when it is no longer needed.
 */
/*---------------------------------------------------------------------------*/
ci_int32_t HTOOLS_asprintf(ci_char_t **pStr, const ci_char_t *formatStr, ...)
{
    ci_int32_t s32Result = 0;
    va_list argList;

    va_start(argList, formatStr);
    s32Result = HTOOLS_vasprintf(pStr, formatStr, argList);
    va_end(argList);

    return s32Result;
}
```

- **vasprintf()** :
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief      Use to allocate a string into a buffer with list of arguments
 * \details    
 * This function is analog of \c vsprintf(), except that it allocate a string large enough to hold the output including the terminating null byte, 
 * and return a pointer to it via the first argument. \n
 * This pointer should be passed to \c free() to release the allocated storage when it is no longer needed. 
 * 
 * You can also use \c vasprintf() function, which is available in GNU Extensions, we can found here : https://linux.die.net/man/3/vasprintf
 *             
 * \param[in] const ci_char_t *formatStr
 * 	C string that contains a format string that follows the same specifications as format in printf. \n
 * 	This value must be not NULL.
 * \param[in] va_list argList : List of argument to use with \c formatStr \n
 * See https://koor.fr/C/cstdarg/cstdarg.wp for more details.
 *
 * \param[out] ci_char_t ci_char_t **pStr : Pointer to string buffer destination. \n
 * This value is set to NULL if function failed, otherwise the buffer is allocated, filled with \c formatStr value and always null-terminated.
 * 
 * \return     ci_int32_t : -1 in case of error, else 0 
 *
 * \warning    The return pointer must be \c free() to release the allocated storage when it is no longer needed.
 */
/*---------------------------------------------------------------------------*/
ci_int32_t HTOOLS_vasprintf(ci_char_t **pStr, const ci_char_t *formatStr, va_list argList)
{
    ci_int32_t s32StrLen = 0;
    ci_int32_t s32StrLenWrite = 0;
    ci_char_t *str = NULL;
    va_list argListCopy;
    
    /* Count how many char we need to store string */
    va_copy(argListCopy, argList);
    s32StrLen = vsnprintf(NULL, 0, formatStr, argListCopy);
    va_end(argListCopy);
    if(s32StrLen < 0){
        goto error_return;
    }

    /* Allocate string buffer */
    str = calloc(s32StrLen +1, sizeof(ci_char_t));
    if(!str){
        goto error_return;
    }

    /* Fill buffer with formatted string */
    s32StrLenWrite = vsnprintf(str, s32StrLen +1, formatStr, argList);
    if(s32StrLenWrite < 0 || s32StrLenWrite >= (s32StrLen +1)) {
        goto free_mem;
    }

    /* Success return */
    *pStr = str;
    return s32StrLenWrite;

    /* Error return */
free_mem:
    free(str);
    *pStr = NULL;
error_return:
    return -1;
}
```

# 2. Useful links
- https://stackoverflow.com/questions/293438/left-pad-printf-with-spaces