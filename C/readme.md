**Table of contents :**

- [1. Limits](#1-limits)
- [2. Tips](#2-tips)
  - [2.1. Printf](#21-printf)
  - [2.2. Error management](#22-error-management)
    - [2.2.1. Errno](#221-errno)
    - [2.2.2. Custom enum error](#222-custom-enum-error)
  - [2.3. Buffer](#23-buffer)
  - [2.4. Dynamic allocation](#24-dynamic-allocation)
    - [2.4.1. Malloc](#241-malloc)
    - [2.4.2. Calloc](#242-calloc)
  - [2.5. String](#25-string)
    - [2.5.1. Allocations](#251-allocations)
    - [2.5.2. Conversions](#252-conversions)
- [3. Regex](#3-regex)
- [4. Ressources](#4-ressources)

# 1. Limits

**Memo :** 1 byte = 8 bits

| Type | 32-bit size (in bytes) | 64-bit size (in bytes) | Minimum value | Maximum value |
|:-:|:-:|:-:|:-:|:-:|
|`char` | 1 | 1 | -128 | 128 |
|`unsigned char` | 1 | 1 | 0 | 255 |
|`short int` | 2 | 2 | -32 768 | 32 767 |
|`unsigned short int` | 2 | 2 | 0 | 65 535 |
|`int` | 4 | 4 | -2 147 483 648 | 2 147 483 647 |
|`unsigned int` | 4 | 4 | 0 | 4 294 967 295 |
|`long int` | 4 | 8 | -9 223 372 036 854 775 808 | 9 223 372 036 854 775 807 |
|`unsigned long int` | 4 | 8 | 0 | 18 446 744 073 709 551 615 |

> Those informations are **theorical** and **platform dependant** :
> - Use header `limits.h` for application ([official-c++][cpp-limits], [official-c][c-limits], [tutorial-c][c-limits-tutorial])
> - Use header `stdint.h` if exact byte size is needed ([official-c++][cpp-stdint], [official-c][c-stdint])

# 2. Tips

## 2.1. Printf

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
> More details here : [integer conversion][printf-integer]

- Format **GLib** types :
```C
gsize sizeBuffer = 54324567;
printf("My value: %" G_GSIZE_FORMAT "\n", sizeBuffer);
```
> Note that the `%` is not part of the macro.  
> For macro documentation, please check : [GLib-BasicTypes][glib-basictypes]

## 2.2. Error management

### 2.2.1. Errno

See [man errno][man-errno] for details on this error code.  
You can get details of its values through `errno` utility:
```shell
errno --list
```
> Used to list all existing errno values and their descriptions, shorter version is available with `-l`.  
> More options are available through `--help` 

### 2.2.2. Custom enum error

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
 * \brief Use to convert network manager error to string  
 *
 * \param[in] enuError
 * Error to convert
 *
 * \return
 * Returns string representation of error
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

## 2.3. Buffer

- Print all buffer values at hexadecimal format :
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief Print variable value byte by byte in hexadecimal format
 *             
 * \param[in] value
 * Pointer value, must be not NULL.
 * \param[in] sizeOfValue
 * Number of bytes of value.
 * \param[in] fdOutput
 * File descriptor opened of stream output.
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

## 2.4. Dynamic allocation

To allocate memory, `malloc()` and `calloc()` are available.  
Both method needed `sizeof()` of the type to reserved, it is better to used `sizeof(var)` instead of `sizeof(type)` to do so because if type of variables is changed, all called to `sizeof()` for this variable must be changed. If we directly used `sizeof(var)`, no extra checking is needed.

### 2.4.1. Malloc

```C
/* Bad : using type */
MyStruct *pVar = malloc(1 * sizeof(MyStruct));

/* Good */
MyStruct *pVar = malloc(1 * sizeof(*pVar));
```

### 2.4.2. Calloc

```C
/* Bad : using type */
MyStruct *pVar = calloc(1, sizeof(MyStruct));

/* Good */
MyStruct *pVar = calloc(1, sizeof(*pVar));
```

## 2.5. String

### 2.5.1. Allocations

Functions [`asprintf`][linux-asprintf] and [`vasprintf`][linux-vasprintf] are GNU extensions, not in C or POSIX.  
We can use those functions or define own implementations :

- **asprintf()** :
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to allocate a string into a buffer with additional arguments
 * \details    
 * This function is analog of \c sprintf(), except that it allocate a string large enough to hold the output including the terminating null byte, 
 * and return a pointer to it via the first argument. \n
 * This pointer should be passed to \c free() to release the allocated storage when it is no longer needed. 
 * 
 * You can also use \c asprintf() function, which is available in GNU Extensions, we can found here : https://linux.die.net/man/3/asprintf
 *             
 * \param[in] formatStr
 * C string that contains a format string that follows the same specifications as format in printf. \n
 * This value must be not NULL.
 * \param[in] ... (additional arguments)
 * Depending on the format string, the function may expect a sequence of additional arguments, each containing a value to be used to replace a format specifier in the format string. \n
 * There should be at least as many of these arguments as the number of values specified in the format specifiers. Additional arguments are ignored by the function.
 *
 * \param[out] char char **pStr
 * Pointer to string buffer destination. \n
 * This value is set to NULL if function failed, otherwise the buffer is allocated, filled with \c formatStr value and always null-terminated.
 * 
 * \warning
 * The return pointer must be \c free() to release the allocated storage when it is no longer needed.
 * 
 * \return
 * Returns -1 in case of error, else 0 
 */
/*---------------------------------------------------------------------------*/
int HTOOLS_asprintf(char **pStr, const char *formatStr, ...)
{
	int sResult = 0;
    va_list argList;

    va_start(argList, formatStr);
    sResult = HTOOLS_vasprintf(pStr, formatStr, argList);
    va_end(argList);

    return sResult;
}
```

- **vasprintf()** :
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to allocate a string into a buffer with list of arguments
 * \details    
 * This function is analog of \c vsprintf(), except that it allocate a string large enough to hold the output including the terminating null byte, 
 * and return a pointer to it via the first argument. \n
 * This pointer should be passed to \c free() to release the allocated storage when it is no longer needed. 
 * 
 * You can also use \c vasprintf() function, which is available in GNU Extensions, we can found here : https://linux.die.net/man/3/vasprintf
 *             
 * \param[in] formatStr
 * C string that contains a format string that follows the same specifications as format in printf. \n
 * This value must be not NULL.
 * \param[in] argList
 * List of argument to use with \c formatStr \n
 * See https://koor.fr/C/cstdarg/cstdarg.wp for more details.
 *
 * \param[out] char char **pStr
 * Pointer to string buffer destination. \n
 * This value is set to NULL if function failed, otherwise the buffer is allocated, filled with \c formatStr value and always null-terminated.
 * 
 * \warning
 * The return pointer must be \c free() to release the allocated storage when it is no longer needed.
 * 
 * \return
 * Returns -1 in case of error, else 0 
 */
/*---------------------------------------------------------------------------*/
int HTOOLS_vasprintf(char **pStr, const char *formatStr, va_list argList)
{
    int sStrLen = 0;
    int sStrLenWrite = 0;
    char *str = NULL;
    va_list argListCopy;

    /* Count how many char we need to store string */
    va_copy(argListCopy, argList);
    sStrLen = vsnprintf(NULL, 0, formatStr, argListCopy);
    va_end(argListCopy);
    if(sStrLen < 0){
        goto error_return;
    }

    /* Allocate string buffer */
    str = calloc(sStrLen +1, sizeof(char));
    if(!str){
        goto error_return;
    }

    /* Fill buffer with formatted string */
    sStrLenWrite = vsnprintf(str, sStrLen +1, formatStr, argList);
    if(sStrLenWrite < 0 || sStrLenWrite >= (sStrLen +1)) {
        goto free_mem;
    }

    /* Success return */
    *pStr = str;
    return sStrLenWrite;

    /* Error return */
free_mem:
    free(str);
    *pStr = NULL;
error_return:
    return -1;
}
```

### 2.5.2. Conversions

Methods used to convert any string to appropriate types safely :

- **stringToBoolean :**
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to convert string value to boolean.
 * \details
 * This method set boolean to \c true only if \c str contains "true" (no case sensitive)
 * or if \c str is "1". All others values are considered as \c false.
 * 
 * \param[in] str
 * String buffer to convert, must be <b>NOT NULL</b>.
 * 
 * \param[out] pBool
 * Pointer to boolean value to set. If method failed, this value is set to \c false.
 *
 * \return 
 * Returns HTOOLS_ERR_NO_ERROR if succeed, otherwise see HTOOLS_enuErrors for more
 * details.
 */
/*---------------------------------------------------------------------------*/
int HTOOLS_stringToBoolean(const char *str, bool *pBool)
{
    HTOOLS_enuErrors htoolsErr;
    int tmpInt = 0;

    /* Set value to false by default */
    *pBool = false;

    /* Check if string value */
    if(strncasecmp("true", str, 4) == 0){
        *pBool = true;
        return HTOOLS_ERR_NO_ERROR;
    }

    if(strncasecmp("false", str, 5) == 0){
        return HTOOLS_ERR_NO_ERROR;
    }

    /* Is int value, use method to convert integer */
    htoolsErr = HTOOLS_stringToInteger(str, &tmpInt, 10);
    if(HTOOLS_ERR_NO_ERROR != htoolsErr){
        return htoolsErr;
    }

    /* Check that int value is 1 for true, all others value is false */
    if(1 == tmpInt){
        *pBool = true;
    };

    return HTOOLS_ERR_NO_ERROR;
}
```

- **stringToInteger :**
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to convert string value to integer.
 * 
 * \param[in] str
 * 	String buffer to convert, must be <b>NOT NULL</b>.
 * \param[in] base
 * 	Base of int to read, must be in range [2,36].
 * 
 * \param[out] pInt
 * Pointer to integer value to set. If method failed, this value is set to 0. \n
 * Must be in range [INT_MIN, INT_MAX], otherwise HTOOLS_ERR_STR2INT_UNDERFLOW or 
 * HTOOLS_ERR_STR2INT_OVERFLOW are returned. \n
 * Must not be started by any character, null-character or space, otherwise HTOOLS_ERR_STR2INT_INVALID
 * is returned.
 *
 * \return 
 * Returns HTOOLS_ERR_NO_ERROR if succeed, otherwise see HTOOLS_enuErrors for more
 * details.
 */
/*---------------------------------------------------------------------------*/
int HTOOLS_stringToInteger(const char *str, int *pInt, int base)
{
    char *strEnd;
    *pInt = 0;

    /* Check if first character is valid */
    if(str[0] == '\0' || isspace(str[0])){
        return HTOOLS_ERR_STR2INT_INVALID;
    }

    /* Convert string to long */
    long longValue = strtol(str, &strEnd, base);

    /* Check limits values of an integer and errno because (INT_MAX == LONG_MAX) is possible */
    if( (longValue > INT_MAX) || (errno == ERANGE && longValue == LONG_MAX) ){
        return HTOOLS_ERR_STR2INT_OVERFLOW;
    }
    if( (longValue < INT_MIN) || (errno == ERANGE && longValue == LONG_MIN) ){
        return HTOOLS_ERR_STR2INT_UNDERFLOW;
    }

    /* Check if value convertion succeed */
    if(str == strEnd){
        return HTOOLS_ERR_STR2INT_INVALID;
    }

    /* Convertion succeed */
    *pInt = longValue;
    return HTOOLS_ERR_NO_ERROR;
}
```

- **stringToUnsignedInteger :**
```C
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to convert string value to integer.
 * 
 * \param[in] str
 * 	String buffer to convert, must be <b>NOT NULL</b>.
 * \param[in] base
 * 	Base of int to read, must be in range [2,36].
 * 
 * \param[out] pUnsignedInt
 * Pointer to unsigned integer value to set. If method failed, this value is set to 0. \n
 * Must be in range [0, UINT_MAX], otherwise HTOOLS_ERR_STR2INT_OVERFLOW is returned. \n
 * Must not be started by any character (included '-'), null-character or space, otherwise HTOOLS_ERR_STR2INT_INVALID
 * is returned. 
 *
 * \return 
 * Returns HTOOLS_ERR_NO_ERROR if succeed, otherwise see HTOOLS_enuErrors for more
 * details.
 */
/*---------------------------------------------------------------------------*/
int HTOOLS_stringToUnsignedInteger(const char *str, unsigned int *pUnsignedInt, int base)
{
    char *strEnd;
    *pUnsignedInt = 0;

    /* Check if first character is valid */
    if(str[0] == '-' || str[0] == '\0' || isspace(str[0])){
        return HTOOLS_ERR_STR2INT_INVALID;
    }

    /* Convert string to unsigned long */
    unsigned long uLongValue = strtoul(str, &strEnd, base);

    /* Check limits values of an unisgned integer and errno because (UINT_MAX == ULONG_MAX) is possible */
    if( (uLongValue > UINT_MAX) || (errno == ERANGE && uLongValue == ULONG_MAX) ){
        return HTOOLS_ERR_STR2INT_OVERFLOW;
    }

    /* Check if value convertion succeed */
    if(str == strEnd){
        return HTOOLS_ERR_STR2INT_INVALID;
    }

    /* Convertion succeed */
    *pUnsignedInt = uLongValue;
    return HTOOLS_ERR_NO_ERROR;
}
```

# 3. Regex

Regex in C are supported, see officials documentation for more details :
- [Regex compilation][regex-compilation]
- [Regex cleanup][regex-cleanup]
- [Regex syntax][regex-syntax]

See below written methods used to manage regex in C :
- **stringMatchesPatternRegex** :
```c
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to check if a string matches a regex pattern.
 * \details
 * Use this method to check if a string matches a regex pattern, if you have multiple strings to check,
 * it's better to use this method (that allow to compile regex only once). \n
 * If you only have one string to test, consider using HTOOLS_stringMatchesPatternStr() which is easier
 * to use.
 * 
 * \param[in] str
 * String source to test, must be <b>NOT NULL</b>.
 * \param[in] compiledRegex
 * Regex pattern to use, regex must have been already compiled (with regcomp(), don't forget to free it after with regfree()). \n
 * You can find POSIX regex documentation at : https://www.gnu.org/software/libc/manual/html_node/Regular-Expressions.html. \n
 * For syntax of POSIX regex, please see : https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions
 * 
 * \param[out] isMatching
 * This value is set to \c true if string matches the pattern, otherwise value is set to false. \n
 * In case of error during regex execution, \c isMatching is set to \c false and method will return \c HTOOLS_ERR_REGEX. 
 *
 * \return 
 * Returns HTOOLS_ERR_NO_ERROR if succeed, otherwise see HTOOLS_enuErrors for more
 * details.
 * 
 * \sa HTOOLS_stringMatchesPatternStr()
 */
/*---------------------------------------------------------------------------*/
HTOOLS_enuErrors HTOOLS_stringMatchesPatternRegex(const char *str, const regex_t *compiledRegex, bool *isMatching)
{
    int sResult;
    HTOOLS_enuErrors toolsErr = HTOOLS_ERR_NO_ERROR;

    sResult = regexec(compiledRegex, str, 0, NULL, 0);
    if(sResult == 0){
        *isMatching = true;
    }else if(sResult == REG_NOMATCH){
        *isMatching = false;
    }else{
        // Set return values
        *isMatching = false;
        toolsErr = HTOOLS_ERR_REGEX;

        // Log regex error (just in case)
        char bufferStr[LENGTH_STR_REGEX_ERROR];
        regerror(sResult, compiledRegex, bufferStr, LENGTH_STR_REGEX_ERROR);
        m_callbackError("[htools] Failed to compare string to a regex pattern : %s\n", bufferStr);
    }

    return toolsErr;
}
```

- **stringMatchesPatternStr** :
```c
/*---------------------------------------------------------------------------*/
/**
 * \brief Use to check if a string matches a regex pattern.
 * \details
 * Use this method to check if a string matches a regex pattern, if you have multiple strings to check
 * with the same pattern, please use HTOOLS_stringMatchesPatternRegex() instead.
 * 
 * \param[in] str
 * String source to test, must be <b>NOT NULL</b>.
 * \param[in] pattern
 * String pattern to use. \n
 * For syntax of POSIX regex, please see : https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions
 * 
 * \param[out] isMatching
 * This value is set to \c true if string matches the pattern, otherwise value is set to false. \n
 * In case of error during regex execution, \c isMatching is set to \c false and method will return \c HTOOLS_ERR_REGEX. 
 *
 * \return 
 * Returns HTOOLS_ERR_NO_ERROR if succeed, otherwise see HTOOLS_enuErrors for more
 * details.
 * 
 * \sa HTOOLS_stringMatchesPatternStr()
 */
/*---------------------------------------------------------------------------*/
HTOOLS_enuErrors HTOOLS_stringMatchesPatternStr(const char *str, const char *pattern, bool *isMatching)
{
    regex_t regex;
    int sResult;

    HTOOLS_enuErrors toolsErr = HTOOLS_ERR_NO_ERROR;

    /* Compile regex */
    sResult = regcomp(&regex, pattern, 0);
    if(sResult != 0){
        char bufferStr[LENGTH_STR_REGEX_ERROR];
        regerror(sResult, &regex, bufferStr, LENGTH_STR_REGEX_ERROR);
        m_callbackError("[htools] Unable to compile regex pattern '%s' [error: %s (%d)]\n", pattern, bufferStr, sResult);

        *isMatching = false;
        return HTOOLS_ERR_REGEX;
    }

    /* Execute regex (by using wrapper around "regexec") */
    toolsErr = HTOOLS_stringMatchesPatternRegex(str, &regex, isMatching);

    /* Free memory allocated for regex */
    regfree(&regex);

    return toolsErr;
}
```

# 4. Ressources

- Official :
  - [cpp-limits]
  - [c-limits]
  - [c-limits-tutorial]
  - [cpp-stdint]
  - [c-stdint]
  - [linux-asprintf]
  - [linux-vasprintf]
  - [glib-basictypes]
  - [printf-integer]
  - [regex-compilation]
  - [regex-cleanup]
  - [regex-syntax]
- Threads
  - [Left pad printf with spaces](https://stackoverflow.com/questions/293438/left-pad-printf-with-spaces)
  - [How to print a guint64 value when using glib ?](https://stackoverflow.com/questions/15272976/how-to-print-a-guint64-value-when-using-glib)
  - [“C” sizeof with a type or variable](https://stackoverflow.com/questions/373252/c-sizeof-with-a-type-or-variable)
  - ["sizeof(value) vs sizeof(type) ?"](https://stackoverflow.com/questions/12811696/sizeofvalue-vs-sizeoftype)

<!-- Links of useful ressources -->
[cpp-limits]: https://www.cplusplus.com/reference/climits/
[c-limits]: https://devdocs.io/c/types/limits
[c-limits-tutorial]: https://www.tutorialspoint.com/c_standard_library/limits_h.htm
[cpp-stdint]: https://www.cplusplus.com/reference/cstdint/
[c-stdint]: https://devdocs.io/c/types/integer

[man-errno]: https://man7.org/linux/man-pages/man3/errno.3.html
[linux-asprintf]: https://linux.die.net/man/3/vasprintf
[linux-vasprintf]: https://linux.die.net/man/3/asprintf  

[glib-basictypes]: https://developer.gnome.org/glib/stable/glib-Basic-Types.html

[printf-integer]: https://www.gnu.org/software/libc/manual/html_node/Integer-Conversions.html

[regex-compilation]: https://www.gnu.org/software/libc/manual/html_node/POSIX-Regexp-Compilation.html
[regex-cleanup]: https://www.gnu.org/software/libc/manual/html_node/Regexp-Cleanup.html
[regex-syntax]: https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions
