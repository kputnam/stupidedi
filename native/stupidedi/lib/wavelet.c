#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/wavelet.h"
#include "stupidedi/include/builtins.h"

struct stupidedi_wavelet_t
{
    size_t              length;
    size_t              *nzeros;
    size_t              *levels;
    stupidedi_rrr_t     *matrix;
    stupidedi_huffman_t *codec;
};

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
stupidedi_wavelet_new(stupidedi_packed_t* a, uint8_t height)
{
    return stupidedi_wavelet_init(stupidedi_wavelet_alloc(), a, height);
}

/* S is a sequence over the alphabet 𝝨 = {0, ..., σ-1}.
 *
 * In a wavelet tree, each symbol in 𝝨 can be represented by ⌈log σ⌉ bits. The
 * bits representing a symbol corresponds to a path in a binary tree where the
 * symbol is a leaf. This results in a complete binary tree with height σ.
 *
 * Each internal node stores a bit sequence obtained as follows. Partition the
 * alphabet in two, 𝝨₀ and 𝝨₁. Let S₀ and S₁ denote the subsequences of S
 * induced by the alphabets 𝝨₀ and 𝝨₁. Then the i-th bit indicates if the symbol
 * S[i] belongs to S₀ or S₁. The left and right subtrees are built recursively
 * from S₀ and S₁. Common methods of partitioning the alphabet dividing the
 * alphabet range in half, {0..(σ-1)/2} and {(σ-1)/2..σ}, or using the l-th bit
 * of the binary representation of the symbol (where l is the internal node's
 * depth in the tree).
 *
 * In a Huffman wavelet matrix, each symbol is represented by a codeword of
 * variable length. Unlike the wavelet tree, there is only one contiguous bit
 * sequence per level. Each level is arranged with all the 0-children are placed
 * to the right of the 1-children. The alphabet is partitioned using the l-th
 * bit of the binary Huffman codeword.
 */
stupidedi_wavelet_t*
stupidedi_wavelet_init(stupidedi_wavelet_t* w, stupidedi_packed_t* s, uint8_t height)
{
    assert(s != NULL);
    assert(w != NULL);

    /* TODO: Count how many times each character occurs */
    stupidedi_packed_t *symbols, *histogram;
    symbols   = stupidedi_packed_new(10, 32);
    histogram = stupidedi_packed_new(10, 32);

    stupidedi_huffman_t* codec;
    codec = stupidedi_huffman_new(58, histogram, PACKED);

    const size_t length
        = stupidedi_packed_length(s);

    const size_t depth
        = stupidedi_huffman_max_codeword_length(codec);

    /* nzeros[l]: Number of 0-bits on level l. If B[l], the bitmap for level l,
     * has a 0-bit at position i, the corresponding position at level l+1 will
     * be rank0(B[l], i). If instead there is a 1-bit, the position at level
     * l+1 will be nzeros[l] + rank1(B[l], i) */
    size_t* nzeros;
    nzeros    = calloc(depth, sizeof(size_t));
    nzeros[0] = 0;

    size_t* levels;
    levels = calloc(depth, sizeof(size_t));

    /* Calculate the size of the input string if it was Huffman coded */
    size_t encoded_length;
    encoded_length = 0;

    for (size_t k = 0; k < length; ++k)
        encoded_length += stupidedi_huffman_encode(codec, stupidedi_packed_read(s, k), NULL);

    /* The wavelet matrix contains one bit for every bit in the Huffman-coded
     * sequence that it represents. The bits are rearranged and stored in a
     * compressed RRR bitmap. */
    stupidedi_rrr_builder_t* rrr_;
    rrr_ = stupidedi_rrr_builder_new(53, 512, encoded_length);

    /* Ones on the left, zeros on the right */
    stupidedi_packed_t *lo, *rz;
    lo = stupidedi_packed_new(length, nbits(length));
    rz = stupidedi_packed_new(0,      nbits(length));

    /* lo and rz contain integer offsets i that refer to S[i] */
    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(lo, k, k);

    /*
    for (size_t l = 0; l < depth; ++l)
    {
        // Remember where this level begins //
        levels[l] = stupidedi_rrr_builder_written(rrr_);

        // The variables suffixed with _ are related to the matrix row being
         * built in this iteration, and will be read from in the next one. //
        stupidedi_packed_t *lo_, *rz_;
        lo_ = stupidedi_packed_new(length, nbits(length));
        rz_ = stupidedi_packed_new(length, nbits(length));

        size_t nl_, nr_;
        nl_ = 0;
        nr_ = 0;

        // First left (ones), then right (zeros) //
        for (size_t j = 0; j < 2; ++j)
        {
            const stupidedi_packed_t *v
                = (j == 0) ? lo : rz;

            const size_t nv =
                stupidedi_packed_length(v);

            for (size_t k = 0; k < nv; ++k)
            {
                size_t i;
                i = stupidedi_packed_read(v, k);

                // We want to know the l-th bit of the Huffman code //
                uint64_t c;
                l = stupidedi_huffman_encode(codec, i, &c);

                if (l < stupidedi_codeword_length(codec, c))
                {
                    if ((c & (UINT64_C(1) << l)) == 0)
                    {
                        stupidedi_rrr_builder_write(rrr_, 1, 0);
                        stupidedi_packed_write(lo_, nl_ ++, i);
                    }
                    else
                    {
                        stupidedi_rrr_builder_write(rrr_, 1, 0);
                        stupidedi_packed_write(rz_, nr_ ++, i);
                    }
                }
            }
        }

        if (l < depth - 1)
            nzeros[l+1] = nl_;

        free(lo); lo = lo_;
        free(rz); rz = rz_;
    }
    */


    w->levels   = levels;
    w->length   = length;
    w->matrix   = stupidedi_rrr_builder_to_rrr(rrr_, NULL);
    w->nzeros   = nzeros;
    w->codec    = codec;

    stupidedi_rrr_builder_free(rrr_);

    return w;
}

stupidedi_wavelet_t*
stupidedi_wavelet_deinit(stupidedi_wavelet_t* w)
{
    if (w == NULL)
        return NULL;

    /* TODO */

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
    return 0; /* TODO */
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
stupidedi_wavelet_access(const stupidedi_wavelet_t* w, size_t i)
{
    assert(w != NULL);
    return 0; /* TODO */
}

size_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t* w, uint64_t c, size_t i)
{
    assert(w != NULL);
    return 0; /* TODO */
}

size_t
stupidedi_wavelet_select(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    assert(w != NULL);
    return 0; /* TODO */
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
/*****************************************************************************/
/*****************************************************************************/

struct stupidedi_wavelet_builder_t
{
};

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_alloc(void)
{
    return NULL;
}

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_new(size_t length, uint8_t width)
{
    return NULL;
}

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_init(stupidedi_wavelet_builder_t* b, size_t length, uint8_t width)
{
    return NULL;
}

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_deinit(stupidedi_wavelet_builder_t* b)
{
    return NULL;
}

stupidedi_wavelet_builder_t*
stupidedi_wavelet_builder_free(stupidedi_wavelet_builder_t* b)
{
    return NULL;
}

/*****************************************************************************/

size_t
stupidedi_wavelet_builder_sizeof(const stupidedi_wavelet_builder_t* b)
{
    return 0;
}

size_t
stupidedi_wavelet_builder_length(const stupidedi_wavelet_builder_t* b)
{
    return 0;
}

/*****************************************************************************/

size_t
stupidedi_wavelet_builder_written(const stupidedi_wavelet_builder_t* b)
{
    return 0;
}

size_t
stupidedi_wavelet_builder_write(stupidedi_wavelet_builder_t* b, uint64_t value)
{
    return 0;
}

stupidedi_wavelet_t*
stupidedi_wavelet_builder_to_wavelet(stupidedi_wavelet_builder_t* b, stupidedi_wavelet_t* w)
{
    return NULL;
}
