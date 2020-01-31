#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "bit_vector.h"

static const uint64_t NBITS    = 64;
static const uint64_t LG_NBITS = 6;

/* This is x % 64 */
static inline uint8_t mod_nbits(uint64_t x) { return x & (NBITS - 1); }

/* This is x / 64 */
static inline uint64_t div_nbits(uint64_t x) { return x >> LG_NBITS; }

/* This is ceil(x / 64.0) */
static inline uint64_t cdiv_nbits(uint64_t x) { return div_nbits(x + NBITS - 1); }

void
bit_vector_free(bit_vector_t *bits) {
    FREE(bits->data);
    FREE(bits);
};

void
bit_vector_print(const bit_vector_t *bits) {
    if (bits == NULL) {
        printf("NULL");
        return;
    }

    if (bits->record_nbits > 0) {
        for (int k = 0; k < bits->size; k ++) {
            if (k > 0 && k % bits->record_nbits == 0)
                printf(",");

            uint64_t block, index;
            block = div_nbits(k);
            index = mod_nbits(k);

            printf("%u", (bits->data[block] >> index) & 1 ? 1 : 0);
        }
    } else {
        for (int k = 0; k < bits->size; k ++) {
            uint64_t block, index;
            block = div_nbits(k);
            index = mod_nbits(k);

            printf("%u", (bits->data[block] >> index) & 1 ? 1 : 0);
        }
    }
}

/* Variable-width operations
 *****************************************************************************/

bit_vector_t*
bit_vector_alloc(uint32_t size) {
    bit_vector_t *bits = ALLOC(bit_vector_t);
    bits->size         = size;
    bits->record_nbits = 0;

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
bit_vector_set(const bit_vector_t* bits, bit_idx_t idx) {
    assert(idx < bits->size);

    uint64_t block, index;
    block = div_nbits(idx);
    index = mod_nbits(idx);
    bits->data[block] |= (1ULL << index);
}

bool
bit_vector_test(const bit_vector_t* bits, bit_idx_t idx) {
    assert(idx < bits->size);

    uint64_t block, index;
    block = div_nbits(idx);
    index = mod_nbits(idx);
    return (bits->data[block] >> index) & 1;
}

void
bit_vector_clear(const bit_vector_t* bits, bit_idx_t idx) {
    assert(idx < bits->size);

    uint64_t block, index;
    block = div_nbits(idx);
    index = mod_nbits(idx);
    bits->data[block] &= ~(1ULL << index);
}

uint64_t
bit_vector_read(const bit_vector_t* bits, bit_idx_t idx, uint8_t width) {
    assert(idx + width <= bits->size);
    assert(width <= 64);
    assert(width <= NBITS);

    if (width == 0)
        return 0ULL;

    uint64_t block, index, mask, value, nbits;
    block = div_nbits(idx);
    index = mod_nbits(idx);
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
bit_vector_write(const bit_vector_t* bits, bit_idx_t idx, uint8_t width, uint64_t val) {
    assert(idx + width <= bits->size);
    assert(width <= NBITS);
    assert(val < (1ULL << width));

    if (width == 0)
        return idx;

    uint64_t block, index, nbits, mask, prev;
    block = div_nbits(idx);
    index = mod_nbits(idx);

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

/* Fixed-width record operations
 *****************************************************************************/

bit_vector_t*
bit_vector_alloc_record(uint16_t record_nbits, uint32_t size) {
    bit_vector_t* bits = bit_vector_alloc(size * record_nbits);
    bits->record_nbits = record_nbits;
    return bits;
}

void
bit_vector_resize_record(bit_vector_t* bits, uint32_t size) {
    bit_vector_resize(bits, bits->record_nbits * size);
}

uint64_t bit_vector_read_record(const bit_vector_t* bits, bit_idx_t idx) {
    assert(bits->record_nbits > 0);
    return bit_vector_read(bits, idx * bits->record_nbits, bits->record_nbits);
}

uint32_t bit_vector_write_record(const bit_vector_t* bits, bit_idx_t idx, uint64_t val) {
    assert(bits->record_nbits > 0);
    bit_vector_write(bits, idx * bits->record_nbits, bits->record_nbits, val);
    return idx + 1;
}
