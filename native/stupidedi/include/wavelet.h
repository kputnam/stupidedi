#ifndef STUPIDEDI_WAVELET_H_
#define STUPIDEDI_WAVELET_H_

#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"

typedef struct stupidedi_wavelet_t
{
  stupidedi_rrr_t* rrr;
  struct stupidedi_wavelet_t *l, *r;
} stupidedi_wavelet_t;

stupidedi_wavelet_t*
stupidedi_wavelet_alloc(stupidedi_packed_t*, uint8_t height);

stupidedi_wavelet_t*
stupidedi_wavelet_dealloc(stupidedi_wavelet_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_init(stupidedi_wavelet_t*, stupidedi_packed_t*, uint8_t height);

stupidedi_wavelet_t*
stupidedi_wavelet_deinit(stupidedi_wavelet_t*);

/*****************************************************************************/

size_t
stupidedi_wavelet_sizeof(const stupidedi_wavelet_t*);

size_t
stupidedi_wavelet_length(const stupidedi_wavelet_t*);

char*
stupidedi_wavelet_to_string(const stupidedi_wavelet_t*);

stupidedi_packed_t*
stupidedi_wavelet_to_packed(const stupidedi_wavelet_t*);

/*****************************************************************************/

uint64_t
stupidedi_wavelet_access(const stupidedi_wavelet_t*, size_t);

size_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t*, uint64_t, size_t);

size_t
stupidedi_wavelet_select(const stupidedi_wavelet_t*, uint64_t, size_t);

size_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* w, uint64_t, size_t);

size_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* w, uint64_t, size_t);

#endif
