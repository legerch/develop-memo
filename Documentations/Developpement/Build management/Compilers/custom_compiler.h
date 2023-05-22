/*----------------------------------------------------------------------------*/
/**
 * \file        custom_compiler.h
 * \brief       Compilers defined MACROs
 * \details
 * Helper documentation: 
 * https://blog.kowalczyk.info/article/j/guide-to-predefined-macros-in-c-compilers-gcc-clang-msvc-etc..html
 *
 * \author      Charlie Leger
 * \date        16-12-2016
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
/* Public macro definitions                                                   */
/******************************************************************************/

/* Clang compiler */
#if defined(__clang__)
#error "Specific CLANG compiler macros not supported yet!"

/* GCC compiler */
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

/* MSVC compiler */
#elif defined(_MSC_VER)
#error "Specific MSVC compiler macros not supported yet!"

#endif

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
