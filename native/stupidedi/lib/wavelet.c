#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/wavelet.h"
#include "stupidedi/include/builtins.h"

/* TODO: Is it possible to build incrementally, so the original sequence doesn't
 * need to be held in memory all at once?
 *
 * TODO: Is it possible to build directly from a Huffman-encoded bit stream?
 *
 * TODO: Could we store s_curr and s_next as Huffman-encoded bit streams?
 *
 * TODO: Could we design a coding scheme to minimize entropy in the coded
 * sequence, by taking advantage of how the wavelet matrix rearranges bits?
 */

struct stupidedi_wavelet_t
{
    /* n */
    size_t               length;

    /* L, When wavelet is uncompressed, L is inferred from the width of elements
     * in a packed array; otherwise, L is the longest Huffman codeword assigned
     * to any symbol. In both cases,  */
    size_t               depth;

    /* NULL when wavelet matrix is not compressed */
    stupidedi_huffman_t* codec;

    /* O(nL*) bits in o(nL*) space */
    stupidedi_rrr_t*     matrix;

    /* O(L log n), n_ones[l]: The number of 0-bits on level l */
    stupidedi_packed_t*  n_ones;

    /* O(L log nL), rows[l]: Bit index where level l+1 begins */
    stupidedi_packed_t*  rows;

    /* O(σ log L), symbols[i]: Bit offset relative to the start of the row,
     * where the final bit of i-th symbol is located */
    stupidedi_packed_t* symbols;
};

static inline size_t row_location(const stupidedi_wavelet_t*, uint8_t);
static inline size_t row_ones(const stupidedi_wavelet_t*, uint8_t);
static inline size_t row_rank0(const stupidedi_wavelet_t*, uint8_t, size_t);
static inline size_t row_rank1(const stupidedi_wavelet_t*, uint8_t, size_t);
static inline size_t row_access(const stupidedi_wavelet_t*, uint8_t, size_t);
static inline size_t row_select0(const stupidedi_wavelet_t*, uint8_t, size_t);
static inline size_t row_select1(const stupidedi_wavelet_t*, uint8_t, size_t);
static inline size_t matrix_rank0(const stupidedi_wavelet_t*, uint8_t l);
static inline size_t matrix_rank1(const stupidedi_wavelet_t*, uint8_t l);

/*****************************************************************************/

stupidedi_wavelet_t*
stupidedi_wavelet_alloc(void)
{
    return malloc(sizeof(stupidedi_wavelet_t));
}

stupidedi_wavelet_t*
stupidedi_wavelet_free(stupidedi_wavelet_t* w)
{
    if (w != NULL)
        free(stupidedi_wavelet_deinit(w));

    return NULL;
}

stupidedi_wavelet_t*
stupidedi_wavelet_new(stupidedi_packed_t* s, stupidedi_huffman_t* codec)
{
    return stupidedi_wavelet_init(stupidedi_wavelet_alloc(), s, codec);
}

stupidedi_wavelet_t*
stupidedi_wavelet_init(stupidedi_wavelet_t* w, stupidedi_packed_t* s, stupidedi_huffman_t* codec)
{
    assert(s != NULL);
    assert(w != NULL);

    size_t length, depth, encoded_length, alphabet_size;
    length = stupidedi_packed_length(s);
    depth  = (codec == NULL) ?
        stupidedi_packed_width(s) :
        stupidedi_huffman_max_codeword_length(codec);

    /* The wavelet matrix contains one bit for every bit in the Huffman-coded
     * sequence that it represents. If a fixed-width encoding is used instead
     * of Huffman coding, then the encoded length is equal to the size of the
     * input in bits. The bits are rearranged and stored in one long compressed
     * bitmap. */
    if (codec == NULL)
    {
        encoded_length = length * depth;
        alphabet_size  = 0;

        for (size_t i = 0; i < length; ++i)
        {
            const uint64_t c
                = stupidedi_packed_read(s, i);

            if (c > alphabet_size)
                alphabet_size = c;
        }
    }
    else
    {
        alphabet_size  = stupidedi_huffman_count(codec);
        encoded_length = 0;

        for (size_t i = 0; i < length; ++i)
            encoded_length += stupidedi_huffman_encode(codec, stupidedi_packed_read(s, i), NULL);
    }

    /* n_ones[l]: The number of 0-bits at level l. */
    stupidedi_packed_t *n_ones, *rows, *symbols;
    n_ones  = stupidedi_packed_new(depth - 1, nbits(length + 1));
    rows    = stupidedi_packed_new(depth - 1, nbits(encoded_length));
    symbols = stupidedi_packed_new(alphabet_size, nbits(length + 1));

    /* These entries will only be overwritten when the symbol is encountered
     * while building the wavelet matrix. Legal values are 0..length-1, so if
     * we see an L when doing rank or select, we'll know that symbol did not
     * occur in the given sequence. */
    for (size_t k = 0; k < alphabet_size; ++k)
        stupidedi_packed_write(symbols, k, length);

    /* Each bit in the wavelet matrix bitmap corresponds to one of the bits from
     * the input sequence. Using a compressed bitstr (RRR) allows the wavelet
     * matrix to represent the original sequence in O() space */
    stupidedi_rrr_builder_t* rb;
    rb = stupidedi_rrr_builder_new(53, 512, encoded_length);

    /* TODO: At each level, we need a copy of the sequence to reorder symbols.
     * When using variable-length coding, it would save considerable memory to
     * encode that sequence at each iteration. This requires writing a bitstr
     * decoding API first.
     *
     * Note to self: there's no way to avoid re-encoding at each iteration, as
     * shifting off one bit each level would result in an un-readable bitstr.
     * Using a packed array could fix that, but it defeats the purpose of using
     * variable-length coding in the first place. */
    stupidedi_packed_t *s_curr, *s_next;
    s_curr = stupidedi_packed_copy(s, NULL);
    s_next = stupidedi_packed_new(length, depth);

    size_t n_curr, n_next;
    n_curr = length;

    for (size_t l = 0; l < depth; ++l)
    {
        if (l > 0)
            stupidedi_packed_write(rows, l-1, stupidedi_rrr_builder_written(rb));

        size_t n1;
        n1     = 0;
        n_next = 0;

        /* First pass generates matrix[l] and counts number of 0's and 1's. */
        for (size_t i = 0; i < n_curr; ++i)
        {
            /* We're reading the bits from left-to-right */
            uint64_t c, w, mask;
            mask = UINT64_C(1) << (depth - l - 1);
            c    = stupidedi_packed_read(s_curr, i);
            w    = c;

            stupidedi_huffman_encode(codec, c, &w);

            if (w & mask)
            {
                ++n1;
                stupidedi_rrr_builder_write(rb, 1, 1);
            }
            else
                stupidedi_rrr_builder_write(rb, 1, 0);
        }

        /* Second pass reorders symbols, s_next = {c | c[l]==0} + {c | c[l]==1 } */
        for (size_t i = 0, n0_ = 0, n1_ = 0; i < n_curr; ++i)
        {
            /* We're reading the bits from left-to-right */
            uint64_t c, w, mask;
            mask = UINT64_C(1) << (depth - l - 1);
            c    = stupidedi_packed_read(s_curr, i);
            w    = c;

            size_t n_w;
            n_w  = 0;
            n_w    = stupidedi_huffman_encode(codec, c, &w);

            if ((codec == NULL && l == depth - 1) || l == n_w - 1)
                /* Record where last bit of this symbol is located, relative to
                 * the start of this row. NOTE: If these values were written in
                 * a separate pass (probably using depth rank calls per symbol),
                 * then we could discard length bits from s_next each iteration.
                 * For fixed-width encoded sequences, that does not reduce the
                 * peak memory usage at the first iteration though. It doesn't
                 * apply to variable-length encoded sequences, so it's not worth
                 * doing this. */
                stupidedi_packed_write(symbols, c, (w & mask) ? n1_ : n1 + n0_);
            else /*if ((codec == NULL && l < depth - 1) || l < n_w - 1)*/
            {
                /* We only need to keep this symbol until all the bits of its
                 * codeword have been processed. */
                stupidedi_packed_write(s_next,     (w & mask) ? n1_++ : n1 + n0_++, c);
                ++ n_next;
            }
        }

        if (l < depth - 1)
            stupidedi_packed_write(n_ones, l, n1);

        n_curr = n_next;
        s_curr = s_next;
    }

    w->length = length;
    w->depth  = depth;
    w->codec  = codec;
    w->matrix = stupidedi_rrr_builder_to_rrr(rb, NULL);
    w->n_ones = n_ones;
    w->rows   = rows;

    stupidedi_rrr_builder_free(rb);
    stupidedi_packed_free(s_curr);
    stupidedi_packed_free(s_next);

    return w;
}

stupidedi_wavelet_t*
stupidedi_wavelet_deinit(stupidedi_wavelet_t* w)
{
    if (w == NULL)
        return NULL;

    if (w->matrix) w->matrix = stupidedi_rrr_free(w->matrix);
    if (w->codec)  w->codec  = stupidedi_huffman_free(w->codec);
    if (w->n_ones) w->n_ones = stupidedi_packed_free(w->n_ones);
    if (w->rows)   w->rows   = stupidedi_packed_free(w->rows);

    return w;
}

/*****************************************************************************/

size_t
stupidedi_wavelet_sizeof(const stupidedi_wavelet_t* w)
{
    return (w == NULL) ? 0 : sizeof(*w) /* + TODO */;
}

size_t
stupidedi_wavelet_length(const stupidedi_wavelet_t* w)
{
    assert(w != NULL);
    return w->length;
}

char*
stupidedi_wavelet_to_string(const stupidedi_wavelet_t* w)
{
    return NULL; /* TODO */
}

stupidedi_packed_t*
stupidedi_wavelet_to_packed(const stupidedi_wavelet_t* w)
{
    return NULL; /* TODO */
}

/*****************************************************************************/

uint64_t
stupidedi_wavelet_access(const stupidedi_wavelet_t* wm, size_t i)
{
    assert(wm != NULL);

    size_t c, l;
    c = 0;
    l = 0;

    for (; l < wm->depth; ++l)
    {
        if (row_access(wm, l, i) == 0)
        {
            /* We're writing bits left-to-right */
            c = (c << 1) | 0;
            i = row_rank0(wm, l, i);
        }
        else
        {
            c = (c << 1) | 1;
            i = row_rank1(wm, l, i);
        }

        /* Check if we're at a leaf node */
        if (wm->codec != NULL && stupidedi_huffman_decode(wm->codec, c, l + 1, &c))
            return c;
    }

    assert(wm->codec == NULL);
    return c;
}

size_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t* wm, uint64_t c, size_t i)
{
    assert(wm != NULL);

    /* TODO: Delete p */
    size_t depth, l, p;
    depth = wm->depth;
    l     = 0;
    p     = 0;

    /* We're reading the bits from left-to-right */
    uint64_t mask, w;
    mask = UINT64_C(1) << (depth - 1);
    w    = c;

    if (wm->codec != NULL)
        depth = stupidedi_huffman_encode(wm->codec, c, &w);

    for (; l < depth; ++l)
    {
        if (w & mask)
        {
            p = row_rank1(wm, l, p) + row_ones(wm, l);
            i = row_rank1(wm, l, i) + row_ones(wm, l);
        }
        else
        {
            p = row_rank0(wm, l, p);
            i = row_rank0(wm, l, i);
        }

        w <<= 1;
    }

    assert(p == stupidedi_packed_read(wm->symbols, c));
    return i - p;
}

size_t
stupidedi_wavelet_select(const stupidedi_wavelet_t* wm, size_t r, uint64_t c)
{
    assert(wm != NULL);

    size_t depth;
    depth = wm->depth;

    /* We're reading the bits from right-to-left */
    uint64_t mask, w;
    mask = UINT64_C(1);
    w    = c;

    if (wm->codec != NULL)
        depth = stupidedi_huffman_encode(wm->codec, c, &w);

    r += stupidedi_packed_read(wm->symbols, c);

    for (size_t l = depth - 1; l > 0; --l)
    {
        if (w & mask)
            r = row_select1(wm, l, r);
        else
            r = row_select0(wm, l, r - row_ones(wm, l));

        w >>= 1;
    }

    return r;
}

size_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    assert(w != NULL);
    return 0; /* TODO */
}

size_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    assert(w != NULL);
    return 0; /* TODO */
}

/*****************************************************************************/

/* Calculate location of the first bit in row level l */
static inline size_t
row_location(const stupidedi_wavelet_t* w, uint8_t l)
{
    if (l == 0)
        return 0;

    if (l >= w->depth)
        return stupidedi_rrr_length(w->matrix);

    return stupidedi_packed_read(w->rows, l);
}

static inline size_t
row_ones(const stupidedi_wavelet_t* wm, uint8_t l)
{
    if (l == 0)
        return 0;

    return stupidedi_packed_read(wm->n_ones, l - 1);
}

static inline size_t
row_rank0(const stupidedi_wavelet_t* wm, uint8_t l, size_t i)
{
    size_t from, upto;
    from = row_location(wm, l);
    upto = from + i;

    return stupidedi_rrr_rank0(wm->matrix, upto) - matrix_rank0(wm, l);
}

static inline size_t
row_rank1(const stupidedi_wavelet_t* wm, uint8_t l, size_t i)
{
    size_t from, upto;
    from = row_location(wm, l);
    upto = from + i;

    return stupidedi_rrr_rank1(wm->matrix, upto) - matrix_rank1(wm, l);
}

static inline size_t
row_access(const stupidedi_wavelet_t* wm, uint8_t l, size_t i)
{
    size_t from;
    from = row_location(wm, l);

    return stupidedi_rrr_access(wm->matrix, from + i);
}

static inline size_t
row_select0(const stupidedi_wavelet_t* wm, uint8_t l, size_t r)
{
    size_t from, rank;
    from = row_location(wm, l);
    rank = matrix_rank0(wm, l);

    return stupidedi_rrr_select0(wm->matrix, rank + r) - from;
}

static inline size_t
row_select1(const stupidedi_wavelet_t* wm, uint8_t l, size_t r)
{
    size_t from, rank;
    from = row_location(wm, l);
    rank = matrix_rank1(wm, l);

    return stupidedi_rrr_select1(wm->matrix, rank + r) - from;
}

static inline size_t
matrix_rank0(const stupidedi_wavelet_t* wm, uint8_t l)
{
    return row_location(wm, l) - matrix_rank1(wm, l);
}

static inline size_t
matrix_rank1(const stupidedi_wavelet_t* wm, uint8_t l)
{
    size_t n_ones;
    n_ones = 0;

    for (size_t l_ = 1; l_ <= l; ++l_)
        n_ones += row_ones(wm, l);

    return n_ones;
}
