#ifndef STUPIDEDI_BITMAP_H_
#define STUPIDEDI_BITMAP_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

#define STUPIDEDI_BITMAP_WIDTH_MIN 1
#define STUPIDEDI_BITMAP_WIDTH_MAX 64

typedef uint32_t stupidedi_bit_idx_t;
#define STUPIDEDI_BIT_IDX_MIN 0
#define STUPIDEDI_BIT_IDX_MAX UINT32_MAX
#define STUPIDEDI_BIT_IDX_C UINT32_C

typedef uint64_t stupidedi_bitmap_word_t;
#define STUPIDEDI_BITMAP_WORD_C UINT64_C
#define STUPIDEDI_BITMAP_WORD_SIZE 64
#define STUPIDEDI_BITMAP_WORD_NBITS 6

/* A bitmap/vector/array/sequence that supports fixed and variable width read/write */
typedef struct stupidedi_bitmap_t
{
    /* Sequence of bits */
    stupidedi_bitmap_word_t* data;

    /* Total number of bits */
    stupidedi_bit_idx_t size;

    /* Fixed size of records; if not fixed, size = 0 */
    uint8_t width;
} stupidedi_bitmap_t;

void
stupidedi_bitmap_free(stupidedi_bitmap_t*);

/* Number of bits the represented in this bitmap */
stupidedi_bit_idx_t
stupidedi_bitmap_size(const stupidedi_bitmap_t*);

/* Number of bytes occupied in memory */
size_t
stupidedi_bitmap_sizeof(const stupidedi_bitmap_t*);

/* Number of bits occupied in memory */
uint64_t
stupidedi_bitmap_sizeof_bits(const stupidedi_bitmap_t*);

/* Pretty print bitmap */
char*
stupidedi_bitmap_to_string(const stupidedi_bitmap_t*);

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_copy(stupidedi_bitmap_t*);

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_reverse(stupidedi_bitmap_t*);

/* These operations are for operating on variable-width records
 *****************************************************************************/

stupidedi_bitmap_t*
stupidedi_bitmap_alloc(stupidedi_bit_idx_t, stupidedi_bitmap_t* target);

/* Change the size of the bitmap. New space is initialized to 0-bits. */
void
stupidedi_bitmap_resize(stupidedi_bitmap_t*, stupidedi_bit_idx_t);

/* Set (to 1) the bit at the given index. */
void
stupidedi_bitmap_set(const stupidedi_bitmap_t*, stupidedi_bit_idx_t);

/* True if the bit at the given index is set. */
bool
stupidedi_bitmap_test(const stupidedi_bitmap_t*, stupidedi_bit_idx_t);

/* Clear (set to 0) the bit at the given index. */
void
stupidedi_bitmap_clear(const stupidedi_bitmap_t*, stupidedi_bit_idx_t);

/* Read the given number of bits (<= 64) starting at the given index. */
uint64_t
stupidedi_bitmap_read(const stupidedi_bitmap_t*, stupidedi_bit_idx_t, uint8_t width);

/* Write the given number of bits (<= 64) starting at the given index. */
stupidedi_bit_idx_t
stupidedi_bitmap_write(const stupidedi_bitmap_t*, stupidedi_bit_idx_t, uint8_t width, stupidedi_bitmap_word_t value);

/* TODO
 *****************************************************************************/

stupidedi_bitmap_t*
stupidedi_bitmap_lshift(stupidedi_bitmap_t*, stupidedi_bit_idx_t);

stupidedi_bitmap_t*
stupidedi_bitmap_rshift(stupidedi_bitmap_t*, stupidedi_bit_idx_t);

stupidedi_bitmap_t*
stupidedi_bitmap_not(stupidedi_bitmap_t*);

stupidedi_bitmap_t*
stupidedi_bitmap_and(stupidedi_bitmap_t*, stupidedi_bitmap_t*);

stupidedi_bitmap_t*
stupidedi_bitmap_or(stupidedi_bitmap_t*, stupidedi_bitmap_t*);

stupidedi_bitmap_t*
stupidedi_bitmap_xor(stupidedi_bitmap_t*, stupidedi_bitmap_t*);

/* These operations are for operating on fixed-width records
 *****************************************************************************/

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_alloc_record(stupidedi_bit_idx_t length, uint8_t width, stupidedi_bitmap_t*);

/* Pretty print bitmap */
char*
stupidedi_bitmap_to_string_record(const stupidedi_bitmap_t*);

/* Resize the fixed-width bitmap to the given number of records. */
void
stupidedi_bitmap_resize_record(stupidedi_bitmap_t*, stupidedi_bit_idx_t length);

/* Read the fixed-width record at the given index. */
uint64_t
stupidedi_bitmap_read_record(const stupidedi_bitmap_t*, stupidedi_bit_idx_t);

/* Write the fixed-width record at the given index. */
stupidedi_bit_idx_t
stupidedi_bitmap_write_record(const stupidedi_bitmap_t*, stupidedi_bit_idx_t, stupidedi_bitmap_word_t value);

#endif
