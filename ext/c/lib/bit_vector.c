#include <assert.h>
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
bit_vector_free(bit_vector_t* bits) {
    if (bits == NULL) return;
    if (bits->data) free(bits->data);
    free(bits);
}

void
bit_vector_print(const bit_vector_t* bits) {
    if (bits == NULL) {
        printf("NULL");
        return;
    }

    if (bits->width > 0) {
        for (uint32_t k = 0; k < bits->nbits; k ++) {
            if (k > 0 && k % bits->width == 0)
                printf(",");

            uint64_t block, index;
            block = div_nbits(k);
            index = mod_nbits(k);

            printf("%u", (bits->data[block] >> index) & 1 ? 1 : 0);
        }
    } else {
        for (uint32_t k = 0; k < bits->nbits; k ++) {
            uint64_t block, index;
            block = div_nbits(k);
            index = mod_nbits(k);

            printf("%u", (bits->data[block] >> index) & 1 ? 1 : 0);
        }
    }
}

bit_idx_t
bit_vector_size(const bit_vector_t* bits) {
    if (bits == NULL)
        return 0;

    return bits->width ? (bits->nbits + bits->width - 1) / bits->width : bits->nbits;
}

size_t
bit_vector_sizeof(const bit_vector_t* bits) {
    return sizeof(bits) + ((bit_vector_size_bits(bits) + 7) >> 3);
}

uint64_t
bit_vector_size_bits(const bit_vector_t* bits) {
    return bits == NULL ? 0 : 8 * sizeof(*bits) + bits->nbits;
}

/* Variable-width operations
 *****************************************************************************/

bit_vector_t*
bit_vector_alloc(bit_idx_t nbits, bit_vector_t* bits) {
    if (bits == NULL)
        bits = malloc(sizeof(bit_vector_t));

    assert(nbits > 0);
    assert(bits != NULL);

    bits->nbits = nbits;
    bits->width = 0;

    bits->data = malloc(sizeof(uint64_t) * cdiv_nbits(nbits));
    assert(bits->data != NULL);

    for (uint64_t k = 0; k < cdiv_nbits(nbits); k ++)
        bits->data[k] = 0ULL;

    return bits;
}

void
bit_vector_resize(bit_vector_t* bits, bit_idx_t nbits) {
    assert(bits != NULL);
    bits->data = realloc(bits->data, sizeof(uint64_t) * cdiv_nbits(nbits));
    assert(bits->data != NULL);
    bits->nbits = nbits;
}

void
bit_vector_set(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(i < bits->nbits);

    uint64_t block, index;
    block = div_nbits(i);
    index = mod_nbits(i);
    bits->data[block] |= (1ULL << index);
}

bool
bit_vector_test(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(i < bits->nbits);

    uint64_t block, index;
    block = div_nbits(i);
    index = mod_nbits(i);
    return (bits->data[block] >> index) & 1;
}

void
bit_vector_clear(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(i < bits->nbits);

    uint64_t block, index;
    block = div_nbits(i);
    index = mod_nbits(i);
    bits->data[block] &= ~(1ULL << index);
}

uint64_t
bit_vector_read(const bit_vector_t* bits, bit_idx_t i, uint8_t width) {
    if (width == 0)
        return 0ULL;

    assert(bits != NULL);
    assert(width <= 64);
    assert(width <= NBITS);

    /* NOTE: When using fixed-size records, the last record might not be a full
     * block so we don't want to crash if the read ends past the last bit. But
     * we'll at least be sure it starts inbounds. */
    assert(i < bits->nbits);

    if (i + width > bits->nbits)
        width = bits->nbits - i;

    uint64_t block, index, mask, value, nbits;
    block = div_nbits(i);
    index = mod_nbits(i);
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
bit_vector_write(const bit_vector_t* bits, bit_idx_t i, uint8_t width, uint64_t val) {
    assert(bits != NULL);
    assert(i + width <= bits->nbits);
    assert(width <= NBITS);
    assert(val < (1ULL << width));

    if (width == 0)
        return i;

    uint64_t block, index, nbits, mask, prev;
    block = div_nbits(i);
    index = mod_nbits(i);

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

    return i + width;
}

/* Fixed-width record operations
 *****************************************************************************/

bit_vector_t*
bit_vector_alloc_record(bit_idx_t length, uint16_t width, bit_vector_t* bits) {
    assert(length > 0);
    assert(width > 0);

    bits = bit_vector_alloc(length * width, bits);
    bits->width = width;
    return bits;
}

void
bit_vector_resize_record(bit_vector_t* bits, bit_idx_t nbits) {
    assert(bits != NULL);
    assert(bits->width > 0);

    bit_vector_resize(bits, bits->width * nbits);
}

uint64_t
bit_vector_read_record(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(bits->width > 0);
    return bit_vector_read(bits, i * bits->width, bits->width);
}

uint32_t 
bit_vector_write_record(const bit_vector_t* bits, bit_idx_t i, uint64_t val) {
    assert(bits != NULL);
    assert(bits->width > 0);

    bit_vector_write(bits, i * bits->width, bits->width, val);
    return i + 1;
}
