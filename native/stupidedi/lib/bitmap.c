#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "stupidedi/include/bitmap.h"


/* This is x % 64 */
static inline uint8_t
mod_word_size(stupidedi_bit_idx_t x)
{
    return x & (STUPIDEDI_BITMAP_WORD_SIZE - 1);
}

/* This is x / 64 */
static inline stupidedi_bit_idx_t
div_word_size(stupidedi_bit_idx_t x)
{
    return x >> STUPIDEDI_BITMAP_WORD_NBITS;
}

/* This is ceil(x / 64.0) */
static inline stupidedi_bit_idx_t
cdiv_word_size(stupidedi_bit_idx_t x)
{
    return div_word_size(x + STUPIDEDI_BITMAP_WORD_SIZE - 1);
}

/* TODO */
void
stupidedi_bitmap_free(stupidedi_bitmap_t* bits)
{
    if (bits == NULL)
        return;

    if (bits->data)
        free(bits->data);

    free(bits);
}

/* Number of bits the represented in this bitmap */
stupidedi_bit_idx_t
stupidedi_bitmap_size(const stupidedi_bitmap_t* bits)
{
    if (bits == NULL)
        return 0;

    return bits->width ? (bits->size + bits->width - 1) / bits->width : bits->size;
}

/* Number of bytes occupied in memory */
size_t
stupidedi_bitmap_sizeof(const stupidedi_bitmap_t* bits)
{
    return sizeof(bits) + ((stupidedi_bitmap_sizeof_bits(bits) + 7) >> 3);
}

/* Number of bits occupied in memory */
uint64_t
stupidedi_bitmap_sizeof_bits(const stupidedi_bitmap_t* bits)
{
    return bits == NULL ? 0 : 8 * sizeof(*bits) + bits->size;
}

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_copy(stupidedi_bitmap_t* orig)
{
    stupidedi_bitmap_t* copy;

    copy = malloc(sizeof(stupidedi_bitmap_t));
    assert(copy != NULL);

    copy->size  = orig->size;
    copy->width = orig->width;

    stupidedi_bit_idx_t word_count;
    word_count = cdiv_word_size(orig->size);
    copy->data = calloc(word_count, sizeof(stupidedi_bitmap_word_t));

    for (stupidedi_bit_idx_t k = 0; k < word_count; ++k)
        copy->data[k] = orig->data[k];

    return copy;
}

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_reverse(stupidedi_bitmap_t* orig)
{
    stupidedi_bitmap_t* copy;

    copy = malloc(sizeof(stupidedi_bitmap_t));
    assert(copy != NULL);

    copy->size  = orig->size;
    copy->width = orig->width;

    stupidedi_bit_idx_t word_count;
    word_count = cdiv_word_size(orig->size);
    copy->data = calloc(word_count, sizeof(stupidedi_bitmap_word_t));

    for (stupidedi_bit_idx_t k = 0; k < word_count; ++k)
        copy->data[k] = orig->data[word_count - k - 1];

    return copy;
}

/* Variable-width operations
 *****************************************************************************/

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_alloc(stupidedi_bit_idx_t size, stupidedi_bitmap_t* bits)
{
    if (bits == NULL)
        bits = malloc(sizeof(stupidedi_bitmap_t));

    assert(size > 0);
    assert(bits != NULL);

    bits->size  = size;
    bits->width = 0;

    bits->data = calloc(cdiv_word_size(size), sizeof(stupidedi_bitmap_word_t));
    assert(bits->data != NULL);

    return bits;
}

/* Change the size of the bitmap. New space is initialized to 0-bits. */
char*
stupidedi_bitmap_to_string(const stupidedi_bitmap_t* bits)
{
    if (bits == NULL)
        return strdup("NULL");

    char* str;

    if (bits->width > 0)
    {
        int64_t n;
        n = -1;

        stupidedi_bit_idx_t nrecords;
        nrecords = (bits->size + bits->width - 1) / bits->width;

        str = malloc(bits->size + nrecords);
        str[bits->size + nrecords] = '\0';

        for (stupidedi_bit_idx_t k = 0; k < bits->size; ++k)
        {
            if (k > 0 && k % bits->width == 0)
                str[++n] = ',';

            stupidedi_bit_idx_t blkno;
            blkno = div_word_size(k);

            uint8_t bitno;
            bitno = mod_word_size(k);

            str[++n] = (bits->data[blkno] >> bitno) & 1 ? '1' : '0';
        }
    }
    else
    {
        str = malloc(bits->size + 1);
        str[bits->size] = '\0';

        for (stupidedi_bit_idx_t k = 0; k < bits->size; ++k)
        {
            stupidedi_bit_idx_t blkno; uint8_t bitno;
            blkno = div_word_size(k);
            bitno = mod_word_size(k);

            str[k] = (bits->data[blkno] >> bitno) & 1 ? '1' : '0';
        }
    }

    return str;
}

/* Change the size of the bitmap. New space is initialized to 0-bits. */
void
stupidedi_bitmap_resize(stupidedi_bitmap_t* bits, stupidedi_bit_idx_t size)
{
    assert(bits != NULL);

    bits->data = realloc(bits->data, sizeof(stupidedi_bitmap_word_t) * cdiv_word_size(size));
    assert(bits->data != NULL);

    stupidedi_bit_idx_t k, nblocks;
    k       = cdiv_word_size(bits->size + 1);
    nblocks = cdiv_word_size(size);

    /* Zero-fill any additional memory */
    for (; k < nblocks; ++k)
        bits->data[k] = STUPIDEDI_BITMAP_WORD_C(0);

    bits->size = size;
}

/* Set (to 1) the bit at the given index. */
void
stupidedi_bitmap_set(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i)
{
    assert(bits != NULL);
    assert(i < bits->size);

    stupidedi_bit_idx_t blkno;
    blkno = div_word_size(i);

    uint8_t bitno;
    bitno = mod_word_size(i);

    bits->data[blkno] |= (STUPIDEDI_BITMAP_WORD_C(1) << bitno);
}

/* True if the bit at the given index is set. */
bool
stupidedi_bitmap_test(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i)
{
    assert(bits != NULL);
    assert(i < bits->size);

    stupidedi_bit_idx_t blkno;
    blkno = div_word_size(i);

    uint8_t bitno;
    bitno = mod_word_size(i);

    return (bits->data[blkno] >> bitno) & 1;
}

/* Clear (set to 0) the bit at the given index. */
void
stupidedi_bitmap_clear(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i)
{
    assert(bits != NULL);
    assert(i < bits->size);

    stupidedi_bit_idx_t blkno;
    blkno = div_word_size(i);

    uint8_t bitno;
    bitno = mod_word_size(i);
    bits->data[blkno] &= ~(STUPIDEDI_BITMAP_WORD_C(1) << bitno);
}

/* Read the given number of bits (<= 64) starting at the given index. */
uint64_t
stupidedi_bitmap_read(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i, uint8_t width)
{
    if (width == 0)
        return STUPIDEDI_BITMAP_WORD_C(0);

    assert(bits != NULL);
    assert(width <= 64);
    assert(width <= STUPIDEDI_BITMAP_WORD_SIZE);

    /* NOTE: When using fixed-size records, the last record might not be a full
     * block so we don't want to crash if the read ends past the last bit. But
     * we'll at least be sure it starts inbounds. */
    assert(i < bits->size);

    if (i + width > bits->size)
        width = bits->size - i;

    stupidedi_bit_idx_t blkno;
    blkno = div_word_size(i);

    uint8_t bitno, size;
    bitno = mod_word_size(i);
    size  = STUPIDEDI_BITMAP_WORD_SIZE - bitno; /* Number of bits >= bitno in the 1st block */

    stupidedi_bitmap_word_t mask, value;
    mask  = width < 64 ? (STUPIDEDI_BITMAP_WORD_C(1) << width) - 1 : -1;
    value = (bits->data[blkno] >> bitno) & mask;

    if (size < width)
    {
        uint8_t more;
        more   = width - size;
        mask   = (STUPIDEDI_BITMAP_WORD_C(1) << more) - 1;
        value |= (bits->data[blkno + 1] & mask) << size;
    }

    return value;
}

/* Write the given number of bits (<= 64) starting at the given index. */
stupidedi_bit_idx_t
stupidedi_bitmap_write(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i, uint8_t width, uint64_t value)
{
    assert(bits != NULL);
    assert(i + width <= bits->size);
    assert(width <= STUPIDEDI_BITMAP_WORD_SIZE);
    assert(value < (STUPIDEDI_BITMAP_WORD_C(1) << width));

    if (width == 0)
        return i;

    stupidedi_bit_idx_t blkno;
    blkno = div_word_size(i);

    uint8_t bitno;
    bitno = mod_word_size(i);

    /* How many bits are we writing to the 1st block? */
    uint8_t first;
    first = (STUPIDEDI_BITMAP_WORD_SIZE < bitno + width) ? STUPIDEDI_BITMAP_WORD_SIZE - bitno : width;

    /* Mask bits we are going to write in 1st block */
    stupidedi_bitmap_word_t mask, prev;
    prev = bits->data[blkno];
    mask = ((STUPIDEDI_BITMAP_WORD_C(1) << first) - 1) << bitno;
    bits->data[blkno] = (prev & ~mask) | (value << bitno);

    if (first < width)
    {
        uint8_t more;
        more = width - first;
        prev = bits->data[blkno + 1];
        mask = (STUPIDEDI_BITMAP_WORD_C(1) << more) - 1;
        bits->data[blkno + 1] = (prev & ~mask) | (value >> first);
    }

    return i + width;
}

/* Fixed-width record operations
 *****************************************************************************/

/* TODO */
stupidedi_bitmap_t*
stupidedi_bitmap_alloc_record(stupidedi_bit_idx_t count, uint8_t width, stupidedi_bitmap_t* bits)
{
    assert(count > 0);
    assert(width > 0);
    assert(width >= STUPIDEDI_BITMAP_WIDTH_MIN);
    assert(width <= STUPIDEDI_BITMAP_WIDTH_MAX);

    bits = stupidedi_bitmap_alloc(count * width, bits);
    bits->width = width;

    return bits;
}

/* Pretty print bitmap */
char*
stupidedi_bitmap_to_string_record(const stupidedi_bitmap_t* bits)
{
    if (bits == NULL)
        return strdup("NULL");

    assert(bits->width > 0);

    int64_t n;
    n = 0;

    uint32_t count, width, size;
    count = (bits->size + bits->width - 1) / bits->width;
    width = ceil(log10(STUPIDEDI_BITMAP_WORD_C(1) << bits->width)); /* Maximum number of decimal digits per record */
    size  = count * width + count;                                  /* Include commas and \0 terminator */

    char *str;
    str = malloc(size);

    for (uint32_t k = 0; k < count; ++k)
    {
        if (k > 0)
            str[n++] = ',';

        n += snprintf(str+n, size-n, "%llu", stupidedi_bitmap_read_record(bits, k));
    }

    str    = realloc(str, n + 1);
    str[n] = '\0';

    return str;
}

/* Resize the fixed-width bitmap to the given number of records. */
void
stupidedi_bitmap_resize_record(stupidedi_bitmap_t* bits, stupidedi_bit_idx_t size)
{
    assert(bits != NULL);
    assert(bits->width > 0);
    stupidedi_bitmap_resize(bits, bits->width * size);
}

/* TODO */
uint64_t
stupidedi_bitmap_read_record(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i)
{
    assert(bits != NULL);
    assert(bits->width > 0);
    return stupidedi_bitmap_read(bits, i * bits->width, bits->width);
}

/* Write the fixed-width record at the given index. */
stupidedi_bit_idx_t
stupidedi_bitmap_write_record(const stupidedi_bitmap_t* bits, stupidedi_bit_idx_t i, stupidedi_bitmap_word_t value)
{
    assert(bits != NULL);
    assert(bits->width > 0);
    stupidedi_bitmap_write(bits, i * bits->width, bits->width, value);
    return i + 1;
}
