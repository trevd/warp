/**
 * C preprocessor driver
 * Copyright 2014 Facebook, Inc.
 * License: $(LINK2 http://boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors: Andrei Alexandrescu
 */

// Forwards to warp by emulating the predefined options defined by gcc
// 4.7 or gcc 4.8. Use -version=gcc47 or -version=gcc48 when building.
//
// The predefined preprocessor flags have been
// obtained by running:
//
// g++ -dM -E - </dev/null|sed -e "s/#define /\"-D'/" -e "s/ /=/" -e "s/\$/' \"/"
//
// with the appropriate version of gcc.

import std.algorithm, std.datetime, std.path, std.process, std.stdio,
  std.string;
  
immutable defines = [
`-D__DBL_MIN_EXP__=(-1021)`,
`-D__UINT_LEAST16_MAX__=65535`,
`-D__ATOMIC_ACQUIRE=2`,
`-D__FLT_MIN__=1.17549435082228750797e-38F`,
`-D__UINT_LEAST8_TYPE__=unsigned char`,
`-D__INTMAX_C(c)=c ## L`,
`-D__CHAR_BIT__=8`,
`-D__UINT8_MAX__=255`,
`-D__WINT_MAX__=4294967295U`,
`-D__ORDER_LITTLE_ENDIAN__=1234`,
`-D__SIZE_MAX__=18446744073709551615UL`,
`-D__WCHAR_MAX__=2147483647`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1=1`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2=1`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4=1`,
`-D__DBL_DENORM_MIN__=((double)4.94065645841246544177e-324L)`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8=1`,
`-D__GCC_ATOMIC_CHAR_LOCK_FREE=2`,
`-D__FLT_EVAL_METHOD__=0`,
`-D__unix__=1`,
`-D__GCC_ATOMIC_CHAR32_T_LOCK_FREE=2`,
`-D__x86_64=1`,
`-D__UINT_FAST64_MAX__=18446744073709551615UL`,
`-D__SIG_ATOMIC_TYPE__=int`,
`-D__DBL_MIN_10_EXP__=(-307)`,
`-D__FINITE_MATH_ONLY__=0`,
`-D__GNUC_PATCHLEVEL__=1`,
`-D__UINT_FAST8_MAX__=255`,
`-D__DEC64_MAX_EXP__=385`,
`-D__INT8_C(c)=c`,
`-D__UINT_LEAST64_MAX__=18446744073709551615UL`,
`-D__SHRT_MAX__=32767`,
`-D__LDBL_MAX__=1.18973149535723176502e+4932L`,
`-D__UINT_LEAST8_MAX__=255`,
`-D__GCC_ATOMIC_BOOL_LOCK_FREE=2`,
`-D__UINTMAX_TYPE__=long unsigned int`,
`-D__linux=1`,
`-D__DEC32_EPSILON__=1E-6DF`,
`-D__unix=1`,
`-D__UINT32_MAX__=4294967295U`,
`-D__LDBL_MAX_EXP__=16384`,
`-D__WINT_MIN__=0U`,
`-D__linux__=1`,
`-D__SCHAR_MAX__=127`,
`-D__WCHAR_MIN__=(-__WCHAR_MAX__ - 1)`,
`-D__INT64_C(c)=c ## L`,
`-D__DBL_DIG__=15`,
`-D__GCC_ATOMIC_POINTER_LOCK_FREE=2`,
`-D__SIZEOF_INT__=4`,
`-D__SIZEOF_POINTER__=8`,
`-D__USER_LABEL_PREFIX__=`,
`-D__STDC_HOSTED__=1`,
`-D__LDBL_HAS_INFINITY__=1`,
`-D__FLT_EPSILON__=1.19209289550781250000e-7F`,
`-D__LDBL_MIN__=3.36210314311209350626e-4932L`,
`-D__STDC_UTF_16__=1`,
`-D__DEC32_MAX__=9.999999E96DF`,
`-D__INT32_MAX__=2147483647`,
`-D__SIZEOF_LONG__=8`,
`-D__UINT16_C(c)=c`,
`-D__DECIMAL_DIG__=21`,
`-D__gnu_linux__=1`,
`-D__LDBL_HAS_QUIET_NAN__=1`,
`-D__GNUC__=4`,
`-D__MMX__=1`,
`-D__FLT_HAS_DENORM__=1`,
`-D__SIZEOF_LONG_DOUBLE__=16`,
`-D__BIGGEST_ALIGNMENT__=16`,
`-D__DBL_MAX__=((double)1.79769313486231570815e+308L)`,
`-D__INT_FAST32_MAX__=9223372036854775807L`,
`-D__DBL_HAS_INFINITY__=1`,
`-D__DEC32_MIN_EXP__=(-94)`,
`-D__INT_FAST16_TYPE__=long int`,
`-D__LDBL_HAS_DENORM__=1`,
`-D__DEC128_MAX__=9.999999999999999999999999999999999E6144DL`,
`-D__INT_LEAST32_MAX__=2147483647`,
`-D__DEC32_MIN__=1E-95DF`,
`-D__DBL_MAX_EXP__=1024`,
`-D__DEC128_EPSILON__=1E-33DL`,
`-D__SSE2_MATH__=1`,
`-D__ATOMIC_HLE_RELEASE=131072`,
`-D__PTRDIFF_MAX__=9223372036854775807L`,
`-D__amd64=1`,
`-D__ATOMIC_HLE_ACQUIRE=65536`,
`-D__LONG_LONG_MAX__=9223372036854775807LL`,
`-D__SIZEOF_SIZE_T__=8`,
`-D__SIZEOF_WINT_T__=4`,
`-D__GXX_ABI_VERSION=1002`,
`-D__FLT_MIN_EXP__=(-125)`,
`-D__INT_FAST64_TYPE__=long int`,
`-D__DBL_MIN__=((double)2.22507385850720138309e-308L)`,
`-D__LP64__=1`,
`-D__DECIMAL_BID_FORMAT__=1`,
`-D__DEC128_MIN__=1E-6143DL`,
`-D__REGISTER_PREFIX__=`,
`-D__UINT16_MAX__=65535`,
`-D__DBL_HAS_DENORM__=1`,
`-D__UINT8_TYPE__=unsigned char`,
`-D__NO_INLINE__=1`,
`-D__FLT_MANT_DIG__=24`,
`-D__VERSION__="4.8.2"`,
`-D__UINT64_C(c)=c ## UL`,
`-D__GCC_ATOMIC_INT_LOCK_FREE=2`,
`-D__FLOAT_WORD_ORDER__=__ORDER_LITTLE_ENDIAN__`,
`-D__INT32_C(c)=c`,
`-D__DEC64_EPSILON__=1E-15DD`,
`-D__ORDER_PDP_ENDIAN__=3412`,
`-D__DEC128_MIN_EXP__=(-6142)`,
`-D__INT_FAST32_TYPE__=long int`,
`-D__UINT_LEAST16_TYPE__=short unsigned int`,
`-Dunix=1`,
`-D__INT16_MAX__=32767`,
`-D__SIZE_TYPE__=long unsigned int`,
`-D__UINT64_MAX__=18446744073709551615UL`,
`-D__INT8_TYPE__=signed char`,
`-D__ELF__=1`,
`-D__FLT_RADIX__=2`,
`-D__INT_LEAST16_TYPE__=short int`,
`-D__LDBL_EPSILON__=1.08420217248550443401e-19L`,
`-D__UINTMAX_C(c)=c ## UL`,
`-D__SSE_MATH__=1`,
`-D__k8=1`,
`-D__SIG_ATOMIC_MAX__=2147483647`,
`-D__GCC_ATOMIC_WCHAR_T_LOCK_FREE=2`,
`-D__SIZEOF_PTRDIFF_T__=8`,
`-D__x86_64__=1`,
`-D__DEC32_SUBNORMAL_MIN__=0.000001E-95DF`,
`-D__INT_FAST16_MAX__=9223372036854775807L`,
`-D__UINT_FAST32_MAX__=18446744073709551615UL`,
`-D__UINT_LEAST64_TYPE__=long unsigned int`,
`-D__FLT_HAS_QUIET_NAN__=1`,
`-D__FLT_MAX_10_EXP__=38`,
`-D__LONG_MAX__=9223372036854775807L`,
`-D__DEC128_SUBNORMAL_MIN__=0.000000000000000000000000000000001E-6143DL`,
`-D__FLT_HAS_INFINITY__=1`,
`-D__UINT_FAST16_TYPE__=long unsigned int`,
`-D__DEC64_MAX__=9.999999999999999E384DD`,
`-D__CHAR16_TYPE__=short unsigned int`,
`-D__PRAGMA_REDEFINE_EXTNAME=1`,
`-D__INT_LEAST16_MAX__=32767`,
`-D__DEC64_MANT_DIG__=16`,
`-D__INT64_MAX__=9223372036854775807L`,
`-D__UINT_LEAST32_MAX__=4294967295U`,
`-D__GCC_ATOMIC_LONG_LOCK_FREE=2`,
`-D__INT_LEAST64_TYPE__=long int`,
`-D__INT16_TYPE__=short int`,
`-D__INT_LEAST8_TYPE__=signed char`,
`-D__STDC_VERSION__=201112L`,
`-D__DEC32_MAX_EXP__=97`,
`-D__INT_FAST8_MAX__=127`,
`-D__INTPTR_MAX__=9223372036854775807L`,
`-Dlinux=1`,
`-D__SSE2__=1`,
`-D__LDBL_MANT_DIG__=64`,
`-D__DBL_HAS_QUIET_NAN__=1`,
`-D__SIG_ATOMIC_MIN__=(-__SIG_ATOMIC_MAX__ - 1)`,
`-D__code_model_small__=1`,
`-D__k8__=1`,
`-D__INTPTR_TYPE__=long int`,
`-D__UINT16_TYPE__=short unsigned int`,
`-D__WCHAR_TYPE__=int`,
`-D__SIZEOF_FLOAT__=4`,
`-D__UINTPTR_MAX__=18446744073709551615UL`,
`-D__DEC64_MIN_EXP__=(-382)`,
`-D__INT_FAST64_MAX__=9223372036854775807L`,
`-D__GCC_ATOMIC_TEST_AND_SET_TRUEVAL=1`,
`-D__FLT_DIG__=6`,
`-D__UINT_FAST64_TYPE__=long unsigned int`,
`-D__INT_MAX__=2147483647`,
`-D__amd64__=1`,
`-D__INT64_TYPE__=long int`,
`-D__FLT_MAX_EXP__=128`,
`-D__ORDER_BIG_ENDIAN__=4321`,
`-D__DBL_MANT_DIG__=53`,
`-D__INT_LEAST64_MAX__=9223372036854775807L`,
`-D__GCC_ATOMIC_CHAR16_T_LOCK_FREE=2`,
`-D__DEC64_MIN__=1E-383DD`,
`-D__WINT_TYPE__=unsigned int`,
`-D__UINT_LEAST32_TYPE__=unsigned int`,
`-D__SIZEOF_SHORT__=2`,
`-D__SSE__=1`,
`-D__LDBL_MIN_EXP__=(-16381)`,
`-D__INT_LEAST8_MAX__=127`,
`-D__SIZEOF_INT128__=16`,
`-D__LDBL_MAX_10_EXP__=4932`,
`-D__ATOMIC_RELAXED=0`,
`-D__DBL_EPSILON__=((double)2.22044604925031308085e-16L)`,
`-D_LP64=1`,
`-D__UINT8_C(c)=c`,
`-D__INT_LEAST32_TYPE__=int`,
`-D__SIZEOF_WCHAR_T__=4`,
`-D__UINT64_TYPE__=long unsigned int`,
`-D__INT_FAST8_TYPE__=signed char`,
`-D__GNUC_STDC_INLINE__=1`,
`-D__DBL_DECIMAL_DIG__=17`,
`-D__STDC_UTF_32__=1`,
`-D__FXSR__=1`,
`-D__DEC_EVAL_METHOD__=2`,
`-D__UINT32_C(c)=c ## U`,
`-D__INTMAX_MAX__=9223372036854775807L`,
`-D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__`,
`-D__FLT_DENORM_MIN__=1.40129846432481707092e-45F`,
`-D__INT8_MAX__=127`,
`-D__UINT_FAST32_TYPE__=long unsigned int`,
`-D__CHAR32_TYPE__=unsigned int`,
`-D__FLT_MAX__=3.40282346638528859812e+38F`,
`-D__INT32_TYPE__=int`,
`-D__SIZEOF_DOUBLE__=8`,
`-D__FLT_MIN_10_EXP__=(-37)`,
`-D__INTMAX_TYPE__=long int`,
`-D__DEC128_MAX_EXP__=6145`,
`-D__ATOMIC_CONSUME=1`,
`-D__GNUC_MINOR__=8`,
`-D__UINTMAX_MAX__=18446744073709551615UL`,
`-D__DEC32_MANT_DIG__=7`,
`-D__DBL_MAX_10_EXP__=308`,
`-D__LDBL_DENORM_MIN__=3.64519953188247460253e-4951L`,
`-D__INT16_C(c)=c`,
`-D__STDC__=1`,
`-D__PTRDIFF_TYPE__=long int`,
`-D__ATOMIC_SEQ_CST=5`,
`-D__UINT32_TYPE__=unsigned int`,
`-D__UINTPTR_TYPE__=long unsigned int`,
`-D__DEC64_SUBNORMAL_MIN__=0.000000000000001E-383DD`,
`-D__DEC128_MANT_DIG__=34`,
`-D__LDBL_MIN_10_EXP__=(-4931)`,
`-D__SIZEOF_LONG_LONG__=8`,
`-D__GCC_ATOMIC_LLONG_LOCK_FREE=2`,
`-D__LDBL_DIG__=18`,
`-D__FLT_DECIMAL_DIG__=9`,
`-D__UINT_FAST16_MAX__=18446744073709551615UL`,
`-D__GCC_ATOMIC_SHORT_LOCK_FREE=2`,
`-D__UINT_FAST8_TYPE__=unsigned char`,
`-D__ATOMIC_ACQ_REL=4`,
`-D__ATOMIC_RELEASE=3`,
];
immutable xxdefines = [
`-D__DBL_MIN_EXP__=(-1021)`,
`-D__UINT_LEAST16_MAX__=65535`,
`-D__ATOMIC_ACQUIRE=2`,
`-D__FLT_MIN__=1.17549435082228750797e-38F`,
`-D__UINT_LEAST8_TYPE__=unsigned char`,
`-D__INTMAX_C(c)=c ## L`,
`-D__CHAR_BIT__=8`,
`-D__UINT8_MAX__=255`,
`-D__WINT_MAX__=4294967295U`,
`-D__ORDER_LITTLE_ENDIAN__=1234`,
`-D__SIZE_MAX__=18446744073709551615UL`,
`-D__WCHAR_MAX__=2147483647`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1=1`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2=1`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4=1`,
`-D__DBL_DENORM_MIN__=double(4.94065645841246544177e-324L)`,
`-D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8=1`,
`-D__GCC_ATOMIC_CHAR_LOCK_FREE=2`,
`-D__FLT_EVAL_METHOD__=0`,
`-D__unix__=1`,
`-D__GCC_ATOMIC_CHAR32_T_LOCK_FREE=2`,
`-D__x86_64=1`,
`-D__UINT_FAST64_MAX__=18446744073709551615UL`,
`-D__SIG_ATOMIC_TYPE__=int`,
`-D__DBL_MIN_10_EXP__=(-307)`,
`-D__FINITE_MATH_ONLY__=0`,
`-D__GNUC_PATCHLEVEL__=1`,
`-D__UINT_FAST8_MAX__=255`,
`-D__DEC64_MAX_EXP__=385`,
`-D__INT8_C(c)=c`,
`-D__UINT_LEAST64_MAX__=18446744073709551615UL`,
`-D__SHRT_MAX__=32767`,
`-D__LDBL_MAX__=1.18973149535723176502e+4932L`,
`-D__UINT_LEAST8_MAX__=255`,
`-D__GCC_ATOMIC_BOOL_LOCK_FREE=2`,
`-D__UINTMAX_TYPE__=long unsigned int`,
`-D__linux=1`,
`-D__DEC32_EPSILON__=1E-6DF`,
`-D__unix=1`,
`-D__UINT32_MAX__=4294967295U`,
`-D__GXX_EXPERIMENTAL_CXX0X__=1`,
`-D__LDBL_MAX_EXP__=16384`,
`-D__WINT_MIN__=0U`,
`-D__linux__=1`,
`-D__SCHAR_MAX__=127`,
`-D__WCHAR_MIN__=(-__WCHAR_MAX__ - 1)`,
`-D__INT64_C(c)=c ## L`,
`-D__DBL_DIG__=15`,
`-D__GCC_ATOMIC_POINTER_LOCK_FREE=2`,
`-D__SIZEOF_INT__=4`,
`-D__SIZEOF_POINTER__=8`,
`-D__GCC_ATOMIC_CHAR16_T_LOCK_FREE=2`,
`-D__USER_LABEL_PREFIX__=`,
`-D__STDC_HOSTED__=1`,
`-D__LDBL_HAS_INFINITY__=1`,
`-D__FLT_EPSILON__=1.19209289550781250000e-7F`,
`-D__GXX_WEAK__=1`,
`-D__LDBL_MIN__=3.36210314311209350626e-4932L`,
`-D__DEC32_MAX__=9.999999E96DF`,
`-D__INT32_MAX__=2147483647`,
`-D__SIZEOF_LONG__=8`,
`-D__UINT16_C(c)=c`,
`-D__DECIMAL_DIG__=21`,
`-D__gnu_linux__=1`,
`-D__LDBL_HAS_QUIET_NAN__=1`,
`-D__GNUC__=4`,
`-D__GXX_RTTI=1`,
`-D__MMX__=1`,
`-D__FLT_HAS_DENORM__=1`,
`-D__SIZEOF_LONG_DOUBLE__=16`,
`-D__BIGGEST_ALIGNMENT__=16`,
`-D__DBL_MAX__=double(1.79769313486231570815e+308L)`,
`-D__INT_FAST32_MAX__=9223372036854775807L`,
`-D__DBL_HAS_INFINITY__=1`,
`-D__INT64_MAX__=9223372036854775807L`,
`-D__DEC32_MIN_EXP__=(-94)`,
`-D__INT_FAST16_TYPE__=long int`,
`-D__LDBL_HAS_DENORM__=1`,
`-D__cplusplus=201103L`,
`-D__DEC128_MAX__=9.999999999999999999999999999999999E6144DL`,
`-D__INT_LEAST32_MAX__=2147483647`,
`-D__DEC32_MIN__=1E-95DF`,
`-D__DBL_MAX_EXP__=1024`,
`-D__DEC128_EPSILON__=1E-33DL`,
`-D__SSE2_MATH__=1`,
`-D__ATOMIC_HLE_RELEASE=131072`,
`-D__PTRDIFF_MAX__=9223372036854775807L`,
`-D__amd64=1`,
`-D__ATOMIC_HLE_ACQUIRE=65536`,
`-D__GNUG__=4`,
`-D__LONG_LONG_MAX__=9223372036854775807LL`,
`-D__SIZEOF_SIZE_T__=8`,
`-D__SIZEOF_WINT_T__=4`,
`-D__GXX_ABI_VERSION=1002`,
`-D__FLT_MIN_EXP__=(-125)`,
`-D__INT_FAST64_TYPE__=long int`,
`-D__DBL_MIN__=double(2.22507385850720138309e-308L)`,
`-D__LP64__=1`,
`-D__DECIMAL_BID_FORMAT__=1`,
`-D__DEC128_MIN__=1E-6143DL`,
`-D__REGISTER_PREFIX__=`,
`-D__UINT16_MAX__=65535`,
`-D__DBL_HAS_DENORM__=1`,
`-D__UINT8_TYPE__=unsigned char`,
`-D__NO_INLINE__=1`,
`-D__FLT_MANT_DIG__=24`,
`-D__VERSION__="4.8.2"`,
`-D__UINT64_C(c)=c ## UL`,
`-D__GCC_ATOMIC_INT_LOCK_FREE=2`,
`-D__FLOAT_WORD_ORDER__=__ORDER_LITTLE_ENDIAN__`,
`-D__INT32_C(c)=c`,
`-D__DEC64_EPSILON__=1E-15DD`,
`-D__ORDER_PDP_ENDIAN__=3412`,
`-D__DEC128_MIN_EXP__=(-6142)`,
`-D__INT_FAST32_TYPE__=long int`,
`-D__UINT_LEAST16_TYPE__=short unsigned int`,
`-Dunix=1`,
`-D__INT16_MAX__=32767`,
`-D__SIZE_TYPE__=long unsigned int`,
`-D__UINT64_MAX__=18446744073709551615UL`,
`-D__INT8_TYPE__=signed char`,
`-D__ELF__=1`,
`-D__FLT_RADIX__=2`,
`-D__INT_LEAST16_TYPE__=short int`,
`-D__LDBL_EPSILON__=1.08420217248550443401e-19L`,
`-D__UINTMAX_C(c)=c ## UL`,
`-D__k8=1`,
`-D__SIG_ATOMIC_MAX__=2147483647`,
`-D__GCC_ATOMIC_WCHAR_T_LOCK_FREE=2`,
`-D__SIZEOF_PTRDIFF_T__=8`,
`-D__x86_64__=1`,
`-D__DEC32_SUBNORMAL_MIN__=0.000001E-95DF`,
`-D__INT_FAST16_MAX__=9223372036854775807L`,
`-D__UINT_FAST32_MAX__=18446744073709551615UL`,
`-D__UINT_LEAST64_TYPE__=long unsigned int`,
`-D__FLT_HAS_QUIET_NAN__=1`,
`-D__FLT_MAX_10_EXP__=38`,
`-D__LONG_MAX__=9223372036854775807L`,
`-D__DEC128_SUBNORMAL_MIN__=0.000000000000000000000000000000001E-6143DL`,
`-D__FLT_HAS_INFINITY__=1`,
`-D__UINT_FAST16_TYPE__=long unsigned int`,
`-D__DEC64_MAX__=9.999999999999999E384DD`,
`-D__CHAR16_TYPE__=short unsigned int`,
`-D__PRAGMA_REDEFINE_EXTNAME=1`,
`-D__INT_LEAST16_MAX__=32767`,
`-D__DEC64_MANT_DIG__=16`,
`-D__UINT_LEAST32_MAX__=4294967295U`,
`-D__GCC_ATOMIC_LONG_LOCK_FREE=2`,
`-D__INT_LEAST64_TYPE__=long int`,
`-D__INT16_TYPE__=short int`,
`-D__INT_LEAST8_TYPE__=signed char`,
`-D__DEC32_MAX_EXP__=97`,
`-D__INT_FAST8_MAX__=127`,
`-D__INTPTR_MAX__=9223372036854775807L`,
`-Dlinux=1`,
`-D__SSE2__=1`,
`-D__EXCEPTIONS=1`,
`-D__LDBL_MANT_DIG__=64`,
`-D__DBL_HAS_QUIET_NAN__=1`,
`-D__SIG_ATOMIC_MIN__=(-__SIG_ATOMIC_MAX__ - 1)`,
`-D__code_model_small__=1`,
`-D__k8__=1`,
`-D__INTPTR_TYPE__=long int`,
`-D__UINT16_TYPE__=short unsigned int`,
`-D__WCHAR_TYPE__=int`,
`-D__SIZEOF_FLOAT__=4`,
`-D__UINTPTR_MAX__=18446744073709551615UL`,
`-D__DEC64_MIN_EXP__=(-382)`,
`-D__INT_FAST64_MAX__=9223372036854775807L`,
`-D__GCC_ATOMIC_TEST_AND_SET_TRUEVAL=1`,
`-D__FLT_DIG__=6`,
`-D__UINT_FAST64_TYPE__=long unsigned int`,
`-D__INT_MAX__=2147483647`,
`-D__amd64__=1`,
`-D__INT64_TYPE__=long int`,
`-D__FLT_MAX_EXP__=128`,
`-D__ORDER_BIG_ENDIAN__=4321`,
`-D__DBL_MANT_DIG__=53`,
`-D__INT_LEAST64_MAX__=9223372036854775807L`,
`-D__DEC64_MIN__=1E-383DD`,
`-D__WINT_TYPE__=unsigned int`,
`-D__UINT_LEAST32_TYPE__=unsigned int`,
`-D__SIZEOF_SHORT__=2`,
`-D__SSE__=1`,
`-D__LDBL_MIN_EXP__=(-16381)`,
`-D__INT_LEAST8_MAX__=127`,
`-D__SIZEOF_INT128__=16`,
`-D__LDBL_MAX_10_EXP__=4932`,
`-D__ATOMIC_RELAXED=0`,
`-D__DBL_EPSILON__=double(2.22044604925031308085e-16L)`,
`-D_LP64=1`,
`-D__UINT8_C(c)=c`,
`-D__INT_LEAST32_TYPE__=int`,
`-D__SIZEOF_WCHAR_T__=4`,
`-D__UINT64_TYPE__=long unsigned int`,
`-D__INT_FAST8_TYPE__=signed char`,
`-D__GNUC_STDC_INLINE__=1`,
`-D__DBL_DECIMAL_DIG__=17`,
`-D__FXSR__=1`,
`-D__DEC_EVAL_METHOD__=2`,
`-D__UINT32_C(c)=c ## U`,
`-D__INTMAX_MAX__=9223372036854775807L`,
`-D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__`,
`-D__FLT_DENORM_MIN__=1.40129846432481707092e-45F`,
`-D__INT8_MAX__=127`,
`-D__UINT_FAST32_TYPE__=long unsigned int`,
`-D__CHAR32_TYPE__=unsigned int`,
`-D__FLT_MAX__=3.40282346638528859812e+38F`,
`-D__INT32_TYPE__=int`,
`-D__SIZEOF_DOUBLE__=8`,
`-D__INTMAX_TYPE__=long int`,
`-D__DEC128_MAX_EXP__=6145`,
`-D__ATOMIC_CONSUME=1`,
`-D__GNUC_MINOR__=8`,
`-D__UINTMAX_MAX__=18446744073709551615UL`,
`-D__DEC32_MANT_DIG__=7`,
`-D__DBL_MAX_10_EXP__=308`,
`-D__LDBL_DENORM_MIN__=3.64519953188247460253e-4951L`,
`-D__INT16_C(c)=c`,
`-D__STDC__=1`,
`-D__PTRDIFF_TYPE__=long int`,
`-D__ATOMIC_SEQ_CST=5`,
`-D__UINT32_TYPE__=unsigned int`,
`-D__UINTPTR_TYPE__=long unsigned int`,
`-D__DEC64_SUBNORMAL_MIN__=0.000000000000001E-383DD`,
`-D__DEC128_MANT_DIG__=34`,
`-D__LDBL_MIN_10_EXP__=(-4931)`,
`-D__SSE_MATH__=1`,
`-D__SIZEOF_LONG_LONG__=8`,
`-D__GCC_ATOMIC_LLONG_LOCK_FREE=2`,
`-D__LDBL_DIG__=18`,
`-D__FLT_DECIMAL_DIG__=9`,
`-D__UINT_FAST16_MAX__=18446744073709551615UL`,
`-D__FLT_MIN_10_EXP__=(-37)`,
`-D__GCC_ATOMIC_SHORT_LOCK_FREE=2`,
`-D__UINT_FAST8_TYPE__=unsigned char`,
`-D_GNU_SOURCE=1`,
`-D__ATOMIC_ACQ_REL=4`,
`-D__ATOMIC_RELEASE=3`,
];

  immutable extras = [
  "-D_GNU_SOURCE=1",
  "-D__USE_GNU=1",
  ];

version (clang) {
  immutable extras = [
    "-D__has_attribute(x)=0",
    "-D__has_builtin(x)=0",
    "-D__has_extension(x)=0",
    "-D__has_feature(x)=0",
    "-D__has_include(x)=0",
    "-D__has_include_next(x)=0",
    "-D__has_warning(x)=0",
  ];
}

// Defines for all builds
immutable defaultOptions = [
  "-D__I86__=6",
  "-D__FUNC__=__func__",
  "-D__FUNCTION__=__func__",
  "-D__PRETTY_FUNCTION__=__func__",
];

// Path to warp binary. If relative, it's assumed to start in the same
// dir as warpdrive. If absolute, then, well, it's absolute.
immutable warp = "warp";

int main(string[] args) {
  debug (warpdrive) stderr.writefln("Exec@%s: %s", Clock.currTime(), warp);
  debug (warpdrive) stderr.writeln(args);

  string[] options;

  // The warp binary is assumed to be in the same directory as
  // warpdrive UNLESS it is actually an absolute path.
  options ~= warp.startsWith('/') ? warp : buildPath(args[0].dirName, warp);
  options ~= defaultOptions;
  options ~= extras;

  string toCompile;
  bool dashOhPassed = false;

  for (size_t i = 1; i < args.length; ++i) {
    auto arg = args[i];
    if (arg.startsWith("-")) {
      if (arg == "--param" || arg == "-iprefix") {
        // There are options set with --param name=value, see e.g.
        // http://gcc.gnu.org/onlinedocs/gcc-3.4.5/gcc/Optimize-Options.html
        // Just skip those. Also skip -iprefix /some/path/. Note that
        // the versions without space after the flag name are taken
        // care of in the test coming after this.
        ++i;
        continue;
      }
      if (arg == "-o") {
        dashOhPassed = true;
        options ~= "-o";
        options ~= args[++i];
        continue;
      }
      // __SANITIZE_ADDRESS__ for ASAN
      if (arg == "-fsanitize=address") {
        options ~= "-D__SANITIZE_ADDRESS__=1";
        continue;
      }
      // __OPTIMIZE__
      if (arg.startsWith("-O") && arg != "-O0") {
        options ~= "-D__OPTIMIZE__=1";
        options ~= "-D__USE_EXTERN_INLINES=1";
        continue;
      }
      if (!arg.startsWith("-isystem", "-I", "-d", "-MF", "-MQ", "-D",
              "-MD", "-MMD")) {
        continue;
      }
      // Sometimes there may be a space between -I and the path, or
      // between "-D" and the macro defined. Merge them.
      if (arg == "-I" || arg == "-D") {
        assert(i + 1 < args.length);
        options ~= arg;
        options ~= args[++i];
        continue;
      }
    } else {
      // This must be the file to compile
      assert(!toCompile, toCompile);
      toCompile = arg;
      continue;
    }
    if (arg == "-MF" || arg == "-MD" || arg == "-MMD") {
      // This is a weird one: optional parameter after -MMD
      if (i + 1 < args.length && args[i + 1].startsWith('-')) {
        // Optional argument
        continue;
      }
      options ~= "--dep=" ~ args[++i];
      continue;
    }
    if (arg == "-MQ") {
      // just skip the object file
      ++i;
      continue;
    }
    if (arg == "-isystem") {
      arg = "--isystem=" ~ args[++i];
    }
    options ~= arg;
  }

  // If no -o default to output to stdout
  if (!dashOhPassed) {
    options ~= "--stdout";
  }

  if (toCompile.endsWith(".c")) {
    options ~= defines;
  } else {
    options ~= xxdefines;
  }

  // Add the file to compile at the very end for easy spotting by humans
  options ~= toCompile;

  debug (warpdrive) {
    string cmd;
    foreach (opt; options) {
      cmd ~= " " ~ escapeShellCommand(opt);
    }
    stderr.writeln(cmd);
  }

  return execvp(options[0], options);
}
