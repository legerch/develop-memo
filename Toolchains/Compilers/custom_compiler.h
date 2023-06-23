/*----------------------------------------------------------------------------*/
/**
 * \file        custom_compilers.h
 * \brief       Compilers defined MACROs
 * \details
 * Helper documentation: 
 * https://blog.kowalczyk.info/article/j/guide-to-predefined-macros-in-c-compilers-gcc-clang-msvc-etc..html
 *
 * \author      Charlie Leger
 * \date        06-04-2021
/******************************************************************************/

/******************************************************************************/
/* Protection against multiple inclusions                                     */
/******************************************************************************/
#ifndef _CUSTOM_COMPILERS_H_
#define _CUSTOM_COMPILERS_H_

/******************************************************************************/
/* Compiler option used to distinguish inclusion done by owner and user       */
/******************************************************************************/

/******************************************************************************/
/* Inclusions of local common headers                                         */
/******************************************************************************/

/******************************************************************************/
/* Standard headers                                                           */
/******************************************************************************/

/******************************************************************************/
/* Own header files                                                           */
/******************************************************************************/

/******************************************************************************/
/* Other module header files                                                  */
/******************************************************************************/

/******************************************************************************/
/* Public macro definitions - CLANG                                           */
/******************************************************************************/

#if defined(__clang__)
#error "Specific CLANG compiler macros not supported yet!"

#define COMPILER_DIAGNOSTIC_PUSH    _Pragma("clang diagnostic push")
#define COMPILER_DIAGNOSTIC_POP     _Pragma("clang diagnostic pop")

/******************************************************************************/
/* Public macro definitions - GCC                                             */
/******************************************************************************/
#elif defined(__GNUC__) || defined(__GNUG__)

/**
 * Compute GCC version at compilation time
 * 
 * To test the target GCC version against the current GCC version one may use:
 * #define GCC_5_3_1 50301
 * #if GCC_VERSION == GCC_5_3_1
 * #else
 * #error "Wrong GCC version, please check your environment configuration"
 * #endif
 */
#define GCC_VERSION     ( __GNUC__       * 10000    \
                        + __GNUC_MINOR__ * 100      \
                        + __GNUC_PATCHLEVEL__       )

/* Defines compiler attributes */
#define COMPILER_FCT_UNUSED         __attribute__((unused))
#define COMPILER_FCT_MAYBE_UNUSED   COMPILER_FCT_UNUSED
#define COMPILER_FCT_DEPRECATED     __attribute__((deprecated))

#define COMPILER_VAR_UNUSED         __attribute__((unused))
#define COMPILER_VAR_MAYBE_UNUSED   COMPILER_VAR_UNUSED
#define COMPILER_VAR_DEPRECATED     __attribute__((deprecated))

#define COMPILER_LABEL_UNUSED       __attribute__((unused))         /**< https://gcc.gnu.org/onlinedocs/gcc/Label-Attributes.html */

#define COMPILER_FALLTHROUGH        __attribute__((fallthrough))

/**
 * C23 standard bring new functions to easily manage overflow.
 * New header \c <stdkdint.h> has been created, those methods
 * are meant to do arithmetic with overflow check by using 
 * everything the compiler can get from instruction flags that 
 * already exist on most CPU. \n
 * For more details, please see:
 * - C23 details: https://gustedt.gitlabpages.inria.fr/c23-library/
 * - Mathematical methods:
 *  - https://www.scaler.com/topics/c/overflow-and-underflow-in-c/
 *  - https://stackoverflow.com/questions/6970802/test-whether-sum-of-two-integers-might-overflow
 * 
 * Since C23 standard is still in progress, we cannot use those
 * methods now, but GCC provides built-in functions to do this since
 * a long time (GCC 5).
*/
#if __has_include(<stdckdint.h>)
#include <stdckdint.h>

#else
#define ckd_add(result, a, b) __builtin_add_overflow((a), (b), (result))    /**< https://gcc.gnu.org/onlinedocs/gcc/Integer-Overflow-Builtins.html */
#define ckd_sub(result, a, b) __builtin_sub_overflow((a), (b), (result))
#define ckd_mul(result, a, b) __builtin_mul_overflow((a), (b), (result))

#endif

/**
 * Pragma directive use to manage diagnostic, allow to:
 * - Ignore warnings not needed (can be useful when including external files, 
 * like single header libraries for example)
 * - Treat warning as error
 * Can be used as:
 * \code{.c}
 * COMPILER_DIAGNOSTIC_PUSH                     // Save current diagnostic state
 * 
 * COMPILER_DIAGNOSTIC_IGNORE("-Wlogical-op")   // Disable "-Wlogical-op" warning
 * #include "header.h"                          // Include file for which warning must be ignored
 * 
 * COMPILER_DIAGNOSTIC_POP                      // Restore previous diagnostic state (latest saved with "push")
 * \endcode
 * 
 * For more details, please see:
 * - Thread: https://stackoverflow.com/questions/3378560/how-to-disable-gcc-warnings-for-a-few-lines-of-code
 * - Compiler documentation:
 *  - GCC: https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Pragmas.html
 *  - CLANG: https://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas
 *  - MSVC: https://learn.microsoft.com/en-us/cpp/preprocessor/warning?redirectedfrom=MSDN&view=msvc-170
 */
#define _COMPILER_PRAGMA(x)                 _Pragma(#x)
#define COMPILER_PRAGMA(x)                  _COMPILER_PRAGMA(x)

#define COMPILER_DIAGNOSTIC_PUSH            _COMPILER_PRAGMA(GCC diagnostic push)
#define COMPILER_DIAGNOSTIC_POP             _COMPILER_PRAGMA(GCC diagnostic pop)

#define COMPILER_DIAGNOSTIC_ERROR(wopt)     COMPILER_PRAGMA(GCC diagnostic error wopt)
#define COMPILER_DIAGNOSTIC_IGNORE(wopt)    COMPILER_PRAGMA(GCC diagnostic ignored wopt)

// Very specific warnings which are usually not managed by external libraries
#define COMPILER_DIAGNOSTIC_IGNORE_CUSTOM   COMPILER_DIAGNOSTIC_IGNORE("-Wlogical-op") \
                                            COMPILER_DIAGNOSTIC_IGNORE("-Wduplicated-cond") \
                                            COMPILER_DIAGNOSTIC_IGNORE("-Wduplicated-branches")

/******************************************************************************/
/* Public macro definitions - MSVC                                            */
/******************************************************************************/
#elif defined(_MSC_VER)
#error "Specific MSVC compiler macros not supported yet!"

#define COMPILER_DIAGNOSTIC_PUSH            __pragma(warning(push))
#define COMPILER_DIAGNOSTIC_POP             __pragma(warning(pop))

#endif

/******************************************************************************/
/* Public macro definitions                                                   */
/******************************************************************************/                                       

/******************************************************************************/
/* Public type declarations                                                   */
/******************************************************************************/

/******************************************************************************/
/* Public type declarations                                                   */
/******************************************************************************/

/******************************************************************************/
/* Public function declarations                                               */
/******************************************************************************/

#endif /* ! #ifndef _CUSTOM_COMPILERS_H_ */


/******************************************************************************/
/* EOF                                                                        */
/******************************************************************************/
