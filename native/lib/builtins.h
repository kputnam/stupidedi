#ifndef STUPIDEDI_BUILTINS_H_
#define STUPIDEDI_BUILTINS_H_ 1

#include <stdint.h>

#if __GNUC__ >= 3
#define LIKELY(x)       (__builtin_expect(!!(x), 1))
#define UNLIKELY(x)     (__builtin_expect(!!(x), 0))
#else
#define LIKELY(x)       (x)
#define UNLIKELY(x)     (x)
#endif

/* Returns the number of 1-bits in the given value. */
inline uint8_t
popcount(uint64_t x) { return __builtin_popcountll(x); }

/* Returns the number of leading zeros in the given value. */
inline uint8_t
clz(uint64_t x) { return __builtin_clzll(x); }

/* Returns the number of trailing zeros in the given value. */
inline uint8_t
ctz(uint64_t x) { return __builtin_ctzll(x); }

/* Returns the minimum number of bits needed to represent the given value. */
inline uint8_t
nbits(uint64_t x) { return (x < 2) ? 0 : 64 - clz(x - 1); }

#endif
