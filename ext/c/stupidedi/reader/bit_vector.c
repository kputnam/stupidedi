#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include "bit_vector.h"
//#include "ruby.h"

#include <stdlib.h>
#define ALLOC(type) ((type*)malloc(sizeof(type)))
#define ALLOC_N(type,n) ((type*)malloc(sizeof(type) * (size_t)(n)))
#define REALLOC_N(ptr,type,n) ((ptr)=(type*)realloc(ptr, sizeof(type) * (size_t)(n)))
#define FREE(ptr) free(ptr)

#define NBITS     64
#define LG_NBITS  6

/* This is x % 64 */
static inline uint8_t mod_nbits(uint64_t x) { return x & (NBITS - 1); }

/* This is x / 64 */
static inline uint64_t div_nbits(uint64_t x) { return x >> LG_NBITS; }

/* This is ceil(x / 64.0) */
static inline uint64_t cdiv_nbits(uint64_t x) { return div_nbits(x + NBITS - 1); }

/* Variable-length operations
 *****************************************************************************/

bit_vector_t*
bit_vector_alloc(const uint32_t size) {
    bit_vector_t *bits = ALLOC(bit_vector_t);
    bits->data = ALLOC_N(uint64_t, cdiv_nbits(size));

    for (uint64_t k = 0; k < cdiv_nbits(size); k ++)
        bits->data[k] = 0ULL;

    return bits;
}

void
bit_vector_resize(bit_vector_t* bits, uint32_t size) {
    REALLOC_N(bits->data, uint64_t, cdiv_nbits(size));
    bits->size = size;
}

void
bit_vector_free(bit_vector_t *bits) {
    FREE(bits->data);
    FREE(bits);
};

void
bit_vector_set(bit_vector_t* bits, bit_idx_t idx) {
    assert(idx < bits->size);

    uint64_t block, index;
    block = div_nbits(idx); /* Which 64-bit block */
    index = mod_nbits(idx); /* Which of the 64 bits */
    bits->data[block] |= (1ULL << index);
}

bool
bit_vector_test(bit_vector_t* bits, bit_idx_t idx) {
    assert(idx < bits->size);

    uint64_t block, index;
    block = div_nbits(idx); /* Which 64-bit block */
    index = mod_nbits(idx); /* Which of the 64 bits */
    return (bits->data[block] >> index) & 0x1;
}

void
bit_vector_clear(bit_vector_t* bits, bit_idx_t idx) {
    assert(idx < bits->size);

    uint64_t block, index;
    block = div_nbits(idx); /* Which 64-bit block */
    index = mod_nbits(idx); /* Which of the 64 bits */
    bits->data[block] &= ~(1ULL << index);
}

uint64_t
bit_vector_read(bit_vector_t* bits, bit_idx_t idx, uint8_t width) {
    assert(idx + width <= bits->size);
    assert(width <= 64);
    assert(width > 0);
    assert(width <= NBITS);

    uint64_t block, index, mask, value, nbits;
    block = div_nbits(idx); /* Which 64-bit block */
    index = mod_nbits(idx); /* Which of the 64 bits */
    mask  = (1ULL << width) - 1;
    value = (bits->data[block] >> index) & mask;

    /* Number of bits >= index in the 1st block */
    nbits = NBITS - index;

    if (nbits < width) {
        uint64_t more;
        more   = width - nbits;
        mask   = (1ULL << more) - 1;
        value |= (bits->data[block + 1] & mask) << nbits;
    }

    return value;
}

bit_idx_t
bit_vector_write(bit_vector_t* bits, bit_idx_t idx, uint8_t width, uint64_t val) {
    assert(idx + width <= bits->size);
    assert(width > 0);
    assert(width <= NBITS);
    assert(val < (1ULL << width));

    uint64_t block, index, nbits, mask, prev;
    block = div_nbits(idx); /* Which 64-bit block */
    index = mod_nbits(idx); /* Which of the 64 bits */

    /* How many bits are we writing to the 1st block? */
    nbits = (NBITS < index + width) ? NBITS - index : width;

    /* Mask bits we are going to write in 1st block: 00111110 */
    prev = bits->data[block];
    mask = ((1ULL << nbits) - 1) << index;
    bits->data[block] = (prev & ~mask) | (val << index);

    if (nbits < width) {
        uint64_t more = width - nbits;
        prev = bits->data[block + 1];
        mask = (1ULL << more) - 1;
        bits->data[block + 1] = (prev & ~mask) | (val >> nbits);
    }

    return idx + width;
}

bit_vector_t*
bit_vector_alloc_record(const uint32_t size, const uint16_t record_nbits) {
    bit_vector_t* bits = bit_vector_alloc(size * record_nbits);
    bits->record_nbits = record_nbits;
    return bits;
}

/* Record-based operations
 *****************************************************************************/

void
bit_vector_resize_record(bit_vector_t* bits, uint32_t size) {
    bit_vector_resize(bits, bits->record_nbits * size);
}

uint64_t bit_vector_read_record(bit_vector_t* bits, bit_idx_t idx) {
    assert(bits->record_nbits > 0);
    return bit_vector_read(bits, idx * bits->record_nbits, bits->record_nbits);
}

uint32_t bit_vector_write_record(bit_vector_t* bits, bit_idx_t idx, uint64_t val) {
    assert(bits->record_nbits > 0);
    bit_vector_write(bits, idx * bits->record_nbits, bits->record_nbits, val);
    return idx + 1;
}
