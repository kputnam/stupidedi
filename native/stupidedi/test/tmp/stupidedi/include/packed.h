#ifndef STUPIDEDI_PACKED_H_
#define STUPIDEDI_PACKED_H_

#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/bitstr.h"

#define STUPIDEDI_PACKED_WIDTH_MIN 1
#define STUPIDEDI_PACKED_WIDTH_MAX 64

/* An array of fixed-width elements. This shaves some bits off the memory usage
 * compared to uint64_t[], uint32_t[], uint16_t[], and uint8_t[] when the items
 * being stored require less than 64, 32, 16, or 8 bits. Some expense is paid
 * in access time, as elements are not word-aligned in memory.
 *
 * Resizing and copying, including converting to and from other data types, are
 * performed in O(n) time. Sorting happens in O(n log n) time. All other
 * operations are O(1) constant time.
 *
 * Space complexity:  O(n)
 * Variable overhead: none
 * Constant overhead: 33 bytes */
typedef struct stupidedi_packed_t stupidedi_packed_t;

/*****************************************************************************/

stupidedi_packed_t*
stupidedi_packed_alloc(void);

stupidedi_packed_t*
stupidedi_packed_free(stupidedi_packed_t*);

stupidedi_packed_t*
stupidedi_packed_new(size_t length, size_t width);

stupidedi_packed_t*
stupidedi_packed_init(stupidedi_packed_t*, size_t length, size_t width);

stupidedi_packed_t*
stupidedi_packed_deinit(stupidedi_packed_t*);

stupidedi_packed_t*
stupidedi_packed_copy(const stupidedi_packed_t*, stupidedi_packed_t*);

/* Adds or removes capacity from the right end (0 is leftmost index) */
stupidedi_packed_t*
stupidedi_packed_resize(stupidedi_packed_t*, size_t);

/*****************************************************************************/

size_t
stupidedi_packed_sizeof(const stupidedi_packed_t*);

size_t
stupidedi_packed_length(const stupidedi_packed_t*);

uint8_t
stupidedi_packed_width(const stupidedi_packed_t*);

char*
stupidedi_packed_to_string(const stupidedi_packed_t*);

stupidedi_bitstr_t*
stupidedi_packed_as_bitstr(const stupidedi_packed_t*);

stupidedi_packed_t*
stupidedi_bitstr_as_packed(stupidedi_bitstr_t*, size_t width, stupidedi_packed_t*);

/*****************************************************************************/

/* Read an element */
uint64_t
stupidedi_packed_read(const stupidedi_packed_t*, size_t);

/* Overwrite an element */
size_t
stupidedi_packed_write(const stupidedi_packed_t*, size_t, uint64_t value);

/* Returns an array of length elements, with values [0,length). */
size_t*
stupidedi_packed_argsort(const stupidedi_packed_t*);

/* Returns an array of `length` elements, with values [0,length), denoting the
 * ranks of the `length` elements starting from `start`. */
size_t*
stupidedi_packed_argsort_range(const stupidedi_packed_t*, size_t start, size_t length);

#endif
