#ifndef STUPIDEDI_WAVELET_H_
#define STUPIDEDI_WAVELET_H_

#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/huffman.h"

typedef struct stupidedi_wavelet_t          stupidedi_wavelet_t;
typedef struct stupidedi_wavelet_builder_t  stupidedi_wavelet_builder_t;

/*****************************************************************************/

stupidedi_wavelet_t*
stupidedi_wavelet_alloc(void);

stupidedi_wavelet_t*
stupidedi_wavelet_free(stupidedi_wavelet_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_new(stupidedi_packed_t*, uint8_t height);

stupidedi_wavelet_t*
stupidedi_wavelet_init(stupidedi_wavelet_t*, stupidedi_packed_t*, uint8_t height);

stupidedi_wavelet_t*
stupidedi_wavelet_deinit(stupidedi_wavelet_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_copy(stupidedi_wavelet_t*);

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

/* Return position of previous occurrence of symbol c from position i. */
size_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* w, uint64_t, size_t);

/* Return position of next occurrence of symbol c from position i. */
size_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* w, uint64_t, size_t);

/*****************************************************************************/
/*****************************************************************************/
/*****************************************************************************/

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_alloc(void);

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_new(size_t length, uint8_t width);

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_init(stupidedi_wavelet_builder_t*, size_t length, uint8_t width);

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_deinit(stupidedi_wavelet_builder_t*);

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_free(stupidedi_wavelet_builder_t*);

/*****************************************************************************/

size_t
stupidedi_wavelet_builder_sizeof(const stupidedi_wavelet_builder_t*);

size_t
stupidedi_wavelet_builder_length(const stupidedi_wavelet_builder_t*);

/*****************************************************************************/

size_t
stupidedi_wavelet_builder_written(const stupidedi_wavelet_builder_t*);

size_t
stupidedi_wavelet_builder_write(stupidedi_wavelet_builder_t*, uint64_t value);

stupidedi_wavelet_t*
stupidedi_wavelet_builder_to_wavelet(stupidedi_wavelet_builder_t*, stupidedi_wavelet_t*);

#endif
