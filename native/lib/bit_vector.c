#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "bit_vector.h"

static const uint64_t WORD_SIZE    = 64;
static const uint64_t LG_WORD_SIZE = 6;

/* This is x % 64 */
static inline uint8_t mod_nbits(uint64_t x) { return x & (WORD_SIZE - 1); }

/* This is x / 64 */
static inline uint64_t div_nbits(uint64_t x) { return x >> LG_WORD_SIZE; }

/* This is ceil(x / 64.0) */
static inline uint64_t cdiv_nbits(uint64_t x) { return div_nbits(x + WORD_SIZE - 1); }

/* TODO */
void
bit_vector_free(bit_vector_t* bits) {
    if (bits == NULL) return;
    if (bits->data) free(bits->data);
    free(bits);
}

/* TODO */
bit_idx_t
bit_vector_size(const bit_vector_t* bits) {
    if (bits == NULL)
        return 0;

    return bits->width ? (bits->size + bits->width - 1) / bits->width : bits->size;
}

/* TODO */
size_t
bit_vector_sizeof(const bit_vector_t* bits) {
    return sizeof(bits) + ((bit_vector_size_bits(bits) + 7) >> 3);
}

/* TODO */
uint64_t
bit_vector_size_bits(const bit_vector_t* bits) {
    return bits == NULL ? 0 : 8 * sizeof(*bits) + bits->size;
}

/* Variable-width operations
 *****************************************************************************/

/* TODO */
bit_vector_t*
bit_vector_alloc(bit_idx_t size, bit_vector_t* bits) {
    if (bits == NULL)
        bits = malloc(sizeof(bit_vector_t));

    assert(size > 0);
    assert(bits != NULL);

    bits->size = size;
    bits->width = 0;

    bits->data = malloc(sizeof(uint64_t) * cdiv_nbits(size));
    assert(bits->data != NULL);

    for (uint64_t k = 0; k < cdiv_nbits(size); ++k)
        bits->data[k] = 0ull;

    return bits;
}

/* TODO */
char*
bit_vector_to_string(const bit_vector_t* bits) {
    if (bits == NULL)
        return strdup("NULL");

    char* str;

    if (bits->width > 0) {
        int n, nrecords;
        n        = -1;
        nrecords = (bits->size + bits->width - 1) / bits->width;

        str = malloc(bits->size + nrecords);
        str[bits->size + nrecords] = '\0';

        for (uint32_t k = 0; k < bits->size; ++k) {
            if (k > 0 && k % bits->width == 0)
                str[++n] = ',';

            uint64_t block, index;
            block = div_nbits(k);
            index = mod_nbits(k);

            str[++n] = (bits->data[block] >> index) & 1 ? '1' : '0';
        }
    } else {
        str = malloc(bits->size + 1);
        str[bits->size] = '\0';

        for (uint32_t k = 0; k < bits->size; ++k) {
            uint64_t block, index;
            block = div_nbits(k);
            index = mod_nbits(k);

            str[k] = (bits->data[block] >> index) & 1 ? '1' : '0';
        }
    }

    return str;
}

/* TODO */
void
bit_vector_resize(bit_vector_t* bits, bit_idx_t size) {
    assert(bits != NULL);
    bits->data = realloc(bits->data, sizeof(uint64_t) * cdiv_nbits(size));

    assert(bits->data != NULL);
    bits->size = size;
}

/* TODO */
void
bit_vector_set(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(i < bits->size);

    uint64_t block, index;
    block = div_nbits(i);
    index = mod_nbits(i);
    bits->data[block] |= (1ull << index);
}

/* TODO */
bool
bit_vector_test(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(i < bits->size);

    uint64_t block, index;
    block = div_nbits(i);
    index = mod_nbits(i);
    return (bits->data[block] >> index) & 1;
}

/* TODO */
void
bit_vector_clear(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(i < bits->size);

    uint64_t block, index;
    block = div_nbits(i);
    index = mod_nbits(i);
    bits->data[block] &= ~(1ull << index);
}

/* TODO */
uint64_t
bit_vector_read(const bit_vector_t* bits, bit_idx_t i, uint8_t width) {
    if (width == 0)
        return 0ull;

    assert(bits != NULL);
    assert(width <= 64);
    assert(width <= WORD_SIZE);

    /* NOTE: When using fixed-size records, the last record might not be a full
     * block so we don't want to crash if the read ends past the last bit. But
     * we'll at least be sure it starts inbounds. */
    assert(i < bits->size);

    if (i + width > bits->size)
        width = bits->size - i;

    uint64_t block, index, mask, value, size;
    block = div_nbits(i);
    index = mod_nbits(i);
    mask  = (width < 64) ? (1ull << width) - 1 : -1;
    value = (bits->data[block] >> index) & mask;

    /* Number of bits >= index in the 1st block */
    size = WORD_SIZE - index;

    if (size < width) {
        uint64_t more;
        more   = width - size;
        mask   = (1ull << more) - 1;
        value |= (bits->data[block + 1] & mask) << size;
    }

    return value;
}

/* TODO */
bit_idx_t
bit_vector_write(const bit_vector_t* bits, bit_idx_t i, uint8_t width, uint64_t value) {
    assert(bits != NULL);
    assert(i + width <= bits->size);
    assert(width <= WORD_SIZE);
    assert(value < (1ull << width));

    if (width == 0)
        return i;

    uint64_t block, index, size, mask, prev;
    block = div_nbits(i);
    index = mod_nbits(i);

    /* How many bits are we writing to the 1st block? */
    size = (WORD_SIZE < index + width) ? WORD_SIZE - index : width;

    /* Mask bits we are going to write in 1st block: 00111110 */
    prev = bits->data[block];
    mask = ((1ull << size) - 1) << index;
    bits->data[block] = (prev & ~mask) | (value << index);

    if (size < width) {
        uint64_t more = width - size;
        prev = bits->data[block + 1];
        mask = (1ull << more) - 1;
        bits->data[block + 1] = (prev & ~mask) | (value >> size);
    }

    return i + width;
}

/* Fixed-width record operations
 *****************************************************************************/

/* TODO */
bit_vector_t*
bit_vector_alloc_record(bit_idx_t count, uint16_t width, bit_vector_t* bits) {
    assert(count > 0);
    assert(width > 0);
    assert(width >= BIT_VECTOR_WIDTH_MIN);
    assert(width <= BIT_VECTOR_WIDTH_MAX);

    bits = bit_vector_alloc(count * width, bits);
    bits->width = width;
    return bits;
}

/* TODO */
char*
bit_vector_to_string_record(const bit_vector_t* bits) {
    if (bits == NULL)
        return strdup("NULL");

    assert(bits->width > 0);

    int n;
    n = 0;

    uint32_t count, width, size;
    count = (bits->size + bits->width - 1) / bits->width;

    /* Maximum number of decimal digits per record */
    width = ceil(log10(1ull << bits->width));

    /* Include commas and \0 terminator */
    size  = count * width + count;

    char *str;
    str = malloc(size);

    for (uint32_t k = 0; k < count; ++k) {
        if (k > 0)
            str[n++] = ',';

        n += snprintf(str+n, size-n, "%llu", bit_vector_read_record(bits, k));
    }

    str    = realloc(str, n + 1);
    str[n] = '\0';

    return str;
}

/* TODO */
void
bit_vector_resize_record(bit_vector_t* bits, bit_idx_t size) {
    assert(bits != NULL);
    assert(bits->width > 0);

    bit_vector_resize(bits, bits->width * size);
}

/* TODO */
uint64_t
bit_vector_read_record(const bit_vector_t* bits, bit_idx_t i) {
    assert(bits != NULL);
    assert(bits->width > 0);
    return bit_vector_read(bits, i * bits->width, bits->width);
}

/* TODO */
uint32_t 
bit_vector_write_record(const bit_vector_t* bits, bit_idx_t i, uint64_t value) {
    assert(bits != NULL);
    assert(bits->width > 0);

    bit_vector_write(bits, i * bits->width, bits->width, value);
    return i + 1;
}
