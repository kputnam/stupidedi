#ifndef STUPIDEDI_WAVELET_H_
#define STUPIDEDI_WAVELET_H_

#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitmap.h"

typedef uint_least64_t stupidedi_wavelet_symbol_t;
#define STUPIDEDI_WAVELET_SYMBOL_MIN 0
#define STUPIDEDI_WAVELET_SYMBOL_MAX UINT_LEAST64_MAX

typedef uint_least32_t stupidedi_wavelet_idx_t;
#define STUPIDEDI_WAVELET_IDX_MIN 0
#define STUPIDEDI_WAVELET_IDX_MAX UINT_LEAST32_MAX

typedef struct stupidedi_wavelet_t
{
    stupidedi_wavelet_symbol_t alpha, omega;
    stupidedi_rrr_t* rrr;
    struct stupidedi_wavelet_t *l, *r;
} stupidedi_wavelet_t;

/* */
stupidedi_wavelet_t*
stupidedi_wavelet_alloc(stupidedi_bitmap_t*, stupidedi_wavelet_t*);

/* */
void
stupidedi_wavelet_free(stupidedi_wavelet_t*);

/* */
size_t
stupidedi_wavelet_sizeof(const stupidedi_wavelet_t*);

/* */
uint64_t
stupidedi_wavelet_sizeof_bits(const stupidedi_wavelet_t*);

/* */
stupidedi_wavelet_idx_t
stupidedi_wavelet_size(const stupidedi_wavelet_t*);

/* access(S, i) = S[i] */
stupidedi_wavelet_symbol_t
stupidedi_wavelet_access(stupidedi_wavelet_t*, stupidedi_wavelet_idx_t i);

/* rank(S, i, a) = |{j ∈ [0, i) : S[j] = a}| */
stupidedi_wavelet_idx_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t*, stupidedi_wavelet_symbol_t a, stupidedi_wavelet_idx_t i);

/* select1(S, r, a) = min{j ∈ [0, n) | rank(j, a) = r} */
stupidedi_wavelet_idx_t
stupidedi_wavelet_select(const stupidedi_wavelet_t*, stupidedi_wavelet_symbol_t a, stupidedi_wavelet_idx_t r);

#endif
