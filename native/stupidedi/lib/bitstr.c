#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "stupidedi/include/bitstr.h"

#define WORD_NBITS 6 /* log2(64) */
#define WORD_SIZE (1 << WORD_NBITS)

typedef struct stupidedi_bitstr_t
{
    uint64_t* data;
    size_t length;
} stupidedi_bitstr_t;

static inline uint8_t mod_word_size(size_t x);
static inline size_t div_word_size(size_t x);
static inline size_t cdiv_word_size(size_t x);

/*****************************************************************************/

stupidedi_bitstr_t*
stupidedi_bitstr_alloc(void)
{
    return malloc(sizeof(stupidedi_bitstr_t));
}

stupidedi_bitstr_t*
stupidedi_bitstr_dealloc(stupidedi_bitstr_t* b)
{
    if (b != NULL)
        free(stupidedi_bitstr_deinit(b));

    return NULL;
}

stupidedi_bitstr_t*
stupidedi_bitstr_new(size_t length)
{
    return stupidedi_bitstr_init(stupidedi_bitstr_alloc(), length);
}

stupidedi_bitstr_t*
stupidedi_bitstr_init(stupidedi_bitstr_t* b, size_t length)
{
    assert(length > 0);
    assert(b != NULL);

    b->length = length;
    b->data   = calloc(cdiv_word_size(length), sizeof(uint64_t));
    assert(b->data != NULL);

    return b;
}

stupidedi_bitstr_t*
stupidedi_bitstr_deinit(stupidedi_bitstr_t* b)
{
    if (b != NULL && b->data)
        free(b->data);

    return b;
}

stupidedi_bitstr_t*
stupidedi_bitstr_copy(const stupidedi_bitstr_t* src, stupidedi_bitstr_t* dst)
{
    if (src == dst)
        return dst;

    if (dst != NULL)
        stupidedi_bitstr_deinit(dst);
    else
    {
        dst = stupidedi_bitstr_alloc();
        assert(dst != NULL);
    }

    size_t nwords;
    nwords = cdiv_word_size(src->length);

    dst->length = src->length;
    dst->data   = calloc(nwords, sizeof(uint64_t));

    for (size_t k = 0; k < nwords; ++k)
        dst->data[k] = src->data[k];

    return dst;
}

stupidedi_bitstr_t*
stupidedi_bitstr_resize(stupidedi_bitstr_t* b, size_t length)
{
    assert(b != NULL);
    assert(b->data != NULL);

    if (b->length == length)
        return b;

    size_t nwords;
    nwords = cdiv_word_size(length);

    b->length = length;
    b->data   = realloc(b->data, nwords * sizeof(uint64_t));
    assert(b->data != NULL);

    size_t k;
    k = cdiv_word_size(b->length + 1);

    /* Zero-fill any additional memory */
    for (; k < nwords; ++k)
        b->data[k] = UINT64_C(0);

    return b;
}

/*****************************************************************************/

size_t
stupidedi_bitstr_sizeof(const stupidedi_bitstr_t* b)
{
    return (b == NULL) ? 0 : sizeof(*b) + ((8*b->length + 7) >> 3);
}

size_t
stupidedi_bitstr_length(const stupidedi_bitstr_t* b)
{
    assert(b != NULL);
    return b->length;
}

char*
stupidedi_bitstr_to_string(const stupidedi_bitstr_t* b)
{
    if (b == NULL)
        return strdup("NULL");

    char* str;
    str = malloc(b->length + 1);
    str[b->length] = '\0';

    for (size_t k = 0; k < b->length; ++k)
    {
        size_t word_idx; uint8_t bit_idx;
        word_idx = div_word_size(k);
        bit_idx  = mod_word_size(k);

        str[k] = (b->data[word_idx] >> bit_idx) & 1 ? '1' : '0';
    }

    return str;
}

stupidedi_bitstr_t*
stupidedi_bitstr_reverse(stupidedi_bitstr_t* src)
{
    stupidedi_bitstr_t* dst;
    dst = malloc(sizeof(stupidedi_bitstr_t));
    assert(dst != NULL);

    size_t word_count;
    word_count  = cdiv_word_size(src->length);
    dst->data   = calloc(word_count, sizeof(uint64_t));
    dst->length = src->length;

    for (size_t k = 0; k < word_count; ++k)
    {
        uint64_t block = src->data[word_count - k - 1];

        /* https://graphics.stanford.edu/~seander/bithacks.html#ReverseParallel */
        block = ((block >>  1) & 0x5555555555555555ULL) | ((block & 0x5555555555555555ULL) <<  1);
        block = ((block >>  2) & 0x3333333333333333ULL) | ((block & 0x3333333333333333ULL) <<  2);
        block = ((block >>  4) & 0x0F0F0F0F0F0F0F0FULL) | ((block & 0x0F0F0F0F0F0F0F0FULL) <<  4);
        block = ((block >>  8) & 0x00FF00FF00FF00FFULL) | ((block & 0x00FF00FF00FF00FFULL) <<  8);
        block = ((block >> 16) & 0x0000FFFF0000FFFFULL) | ((block & 0x0000FFFF0000FFFFULL) << 16);
        block =  (block >> 32)                          |  (block                          << 32);
        dst->data[k] = block;
    }

    /* If the last block is partially filled and looks like 011011------, then
     * after reversing the block it looks like -----110110. */
    uint8_t pad;
    pad = WORD_SIZE - mod_word_size(dst->length);
    dst->data[word_count-1] = dst->data[word_count-1] << pad;

    return dst;
}

/*****************************************************************************/

void
stupidedi_bitstr_set(const stupidedi_bitstr_t* b, size_t i)
{
    assert(b != NULL);
    assert(i < b->length);

    size_t word_idx;
    word_idx = div_word_size(i);

    uint8_t bit_idx;
    bit_idx = mod_word_size(i);

    b->data[word_idx] |= (UINT64_C(1) << bit_idx);
}

bool
stupidedi_bitstr_test(const stupidedi_bitstr_t* b, size_t i)
{
    assert(b != NULL);
    assert(i < b->length);

    size_t word_idx;
    word_idx = div_word_size(i);

    uint8_t bit_idx;
    bit_idx = mod_word_size(i);

    return (b->data[word_idx] >> bit_idx) & 1;
}

void
stupidedi_bitstr_clear(const stupidedi_bitstr_t* b, size_t i)
{
    assert(b != NULL);
    assert(i < b->length);

    size_t word_idx;
    word_idx = div_word_size(i);

    uint8_t bit_idx;
    bit_idx = mod_word_size(i);
    b->data[word_idx] &= ~(UINT64_C(1) << bit_idx);
}

uint64_t
stupidedi_bitstr_read(const stupidedi_bitstr_t* b, size_t i, uint8_t width)
{
    if (width == 0)
        return UINT64_C(0);

    assert(b != NULL);
    assert(width <= 64);
    assert(width <= WORD_SIZE);

    /* NOTE: When using fixed-width records, the last record might not be a full
     * block so we don't want to crash if the read ends past the last bit. But
     * we'll at least be sure it starts inbounds. */
    assert(i < b->length);

    if (i + width > b->length)
        width = b->length - i;

    size_t word_idx;
    word_idx = div_word_size(i);

    uint8_t bit_idx, need;
    bit_idx = mod_word_size(i);
    need    = WORD_SIZE - bit_idx; /* Number of b >= bit_idx in the 1st block */

    uint64_t mask, value;
    mask  = width < 64 ? (UINT64_C(1) << width) - 1 : -1;
    value = (b->data[word_idx] >> bit_idx) & mask;

    if (need < width)
    {
        uint8_t more;
        more   = width - need;
        mask   = (UINT64_C(1) << more) - 1;
        value |= (b->data[word_idx + 1] & mask) << need;
    }

    return value;
}

size_t
stupidedi_bitstr_write(const stupidedi_bitstr_t* b, size_t i, uint8_t width, uint64_t value)
{
    assert(b != NULL);
    assert(i + width <= b->length);
    assert(width <= WORD_SIZE);
    assert(value < (UINT64_C(1) << width));

    if (width == 0)
        return i;

    size_t word_idx;
    word_idx = div_word_size(i);

    uint8_t bit_idx;
    bit_idx = mod_word_size(i);

    /* How many b are we writing to the 1st block? */
    uint8_t done;
    done = (WORD_SIZE < bit_idx + width) ? WORD_SIZE - bit_idx : width;

    /* Mask b we are going to write in 1st block */
    uint64_t mask, prev;
    prev = b->data[word_idx];
    mask = ((UINT64_C(1) << done) - 1) << bit_idx;
    b->data[word_idx] = (prev & ~mask) | (value << bit_idx);

    if (done < width)
    {
        uint8_t more;
        more = width - done;
        prev = b->data[word_idx + 1];
        mask = (UINT64_C(1) << more) - 1;
        b->data[word_idx + 1] = (prev & ~mask) | (value >> done);
    }

    return i + width;
}

/*****************************************************************************/

static inline uint8_t
mod_word_size(size_t x)
{
    return x & (WORD_SIZE - 1);
}

static inline size_t
div_word_size(size_t x)
{
    return x >> WORD_NBITS;
}

static inline size_t
cdiv_word_size(size_t x)
{
    return div_word_size(x + WORD_SIZE - 1);
}
