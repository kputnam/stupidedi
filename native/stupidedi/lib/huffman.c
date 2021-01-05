#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "stupidedi/include/intmap.h"
#include "stupidedi/include/packed.h"
#include "stupidedi/include/huffman.h"

stupidedi_huffman_t*
stupidedi_huffman_alloc(stupidedi_packed_t* m)
{
    return stupidedi_huffman_init(malloc(sizeof(stupidedi_huffman_t)), m);
}

stupidedi_huffman_t*
stupidedi_huffman_dealloc(stupidedi_huffman_t* h)
{
    if (h != NULL)
        stupidedi_huffman_deinit(h);
    return NULL;
}

/* f[i]: the number of occurrences of the i-th symbol */
stupidedi_huffman_t*
stupidedi_huffman_init(stupidedi_huffman_t* h, stupidedi_packed_t* f)
{
    assert(h != NULL);
    assert(f != NULL);

    /* If the least probable symbol in a model has probability 0 < p <= 1, and
     * 1/F(k+3) <= p <= F(k+2), where F(k) denotes the k-th Fibonacci number,
     * then the longest codeword is at most K.
     *
     *   Y. S. Abu-Mostafa, R. J. McEliece. Maximal Codeword Lengths in Huffman
     *   Codes. Computers & Mathematics with Applications, vol 39 no 11. pg
     *   129-134, 2000.
     *
     * This suggests that a pathological input could force the Huffman coding
     * algorithm to generate impractically large codewords and lead to undefined
     * results. To prevent this, we implement an algorithm described by M.
     * Liddel and A. Moffat to restrict the length of codewords.
     */

    const uint8_t L    = 58;
    const size_t count =
        stupidedi_packed_length(f);

    /* Symbol counts must be sorted in ascending order */
    stupidedi_packed_t *pi;
    pi = stupidedi_packed_argsort(f);

    /* Convert counts to frequencies */
    uint64_t total;
    total = 0;

    for (size_t k = 0; k < count; ++k)
        total += stupidedi_packed_read(f, k);

    long double *p;
    p = (long double*) malloc(count * sizeof(long double));

    /* Here we are doing p = sort(f).map{|x| x / total } */
    for (size_t k = 0; k < count; ++k)
        p[k] = stupidedi_packed_read(f, stupidedi_packed_read(pi, k)) / total;

    /* The most infrequent symbols are assigned the longest codes. To ensure the
     * longest codeword does not exceed L bits, we increase the probabilities of
     * all symbols to at least 2^-L. However, we need to decrease the others to
     * maintain the property that all probabilities sum to 1. */
    long double s, min, numerator, denominator;
    min         = powl(2.0, -L);
    numerator   = 1;
    denominator = total;

    size_t k;

    for (k = 0; k < count - 1; ++k)
    {
        /* We need to scale the remaining probabilities down by this factor */
        s = numerator / denominator;

        numerator   -= min;
        denominator -= p[k];

        /* Don't stop if scaling down the next largest probability makes it
         * so small that it would be assigned a codeword length longer than L */
        if (s * p[k+1] >= min)
            break;
    }

    if (k > 0)
    {
        for (size_t j = 0; j <= k; ++j)
            p[j] = min;

        for (size_t j = k + 1; j < count; ++j)
            p[j] *= s;
    }

    stupidedi_packed_t* l;
    l = stupidedi_packed_alloc(count, ceil(log2(L + 1)));

    /* The KRAFT-CODER algorithm generates codeword lengths which satisfy
     * ceil(-log2(p)) - 1 <= l <= ceil(-log2(p)). We will start small and
     * add a single bit as needed, to lower the Kraft sum (𝝨 2^-l) to <= 1. */
    for (size_t k = 0; k < count; ++k)
        stupidedi_packed_write(l, k, ceil(-log2l(p[k])) - 1);

    /* The codeword with the highest "value", which is the ratio of how much the
     * Kraft sum decreases to how much the average codeword length increases, is
     * chosen at each iteration. The formula is v = 2^(-l-1)/p.
     *
     * Since we initialized l = ceil(-log2(p)), then v = 2^(ceil(-log2(p))-1)/p.
     * This is monotonically decreasing in p, so there's no need to re-sort
     * symbols descending by v, as they are already sorted ascending by p.
     *
     * As stated above, we know the initial codeword length will not increase by
     * more than 1 bit. Therefore, after choosing a codeword, we do not need to
     * consider it again. There's no need to calculate it's new value and sort
     * it amongst the other codewords. */

    uint8_t max;
    max = 0;

    long double K;
    K = 0;

    for (size_t k = 0; k < count; ++k)
        K += powl(2, -stupidedi_packed_read(l, k));

    for (size_t k = 0; k < count; ++k)
    {
        if (K <= 1)
            break;

        const uint8_t _l =
            stupidedi_packed_read(l, k) + 1;

        if (_l > max)
            max = _l;

        stupidedi_packed_write(l, k, _l);

        K -= powl(2, -_l);
    }

    /* If we view each symbol as a leaf in a binary tree, its codeword length
     * corresponds to its depth. The Kraft sum K equals exactly 1 only for a
     * full binary tree (every node has either 0 or 2 children). If K < 1, this
     * means there is space in the tree that is not used, because at least one
     * node has a single child. We can bring lower nodes upward to fill in these
     * holes, which corresponds to shortening their codewords. */

    size_t *c;
    c = (size_t*) calloc(max, sizeof(size_t));

    /* Count the codewords of each length */
    for (size_t k = 0; k < count; ++k)
        c[stupidedi_packed_read(l, k)] ++;

    /* Look for space starting at the top level */
    for (size_t k = 0; k < max; ++k)
    {
        const long double w =
            powl(2, -k);

        while (K < 1 - w)
        {
            /* Find the nearest deeper node */
            size_t j;

            for (j = k + 1; j < max; ++j)
                if (c[j] > 0)
                    break;

            assert(j < max);

            /* Move the node from level j up to level k */
            -- c[j];
            ++ c[k];

            K += w - powl(2, -j);
        }
    }

    /* We now have the number of codewords of each length. Our symbols are
     * sorted least to most frequent, which means longest to shortest codeword,
     * so we can deal out the codewords in the same order */
    long double l_avg;
    l_avg = 0;

    for (size_t i = 0, k = max; --k; )
    {
        l_avg += k * c[k];

        for (size_t j = 0; j < c[k]; ++j)
        {
            /* This undoes the sort done to `f`. Now the elements of `l` will
             * correspond with the elements in `f`. */
            stupidedi_packed_write(l, stupidedi_packed_read(pi, i ++), k);
        }
    }

    l_avg /= count;
    h->l_avg  = l_avg;
    h->levels = l;
    h->K      = K;

    stupidedi_packed_dealloc(pi);
    free(p);
    free(c);

    return h;
}

stupidedi_huffman_t*
stupidedi_huffman_deinit(stupidedi_huffman_t* h)
{
    return h;
}

/*****************************************************************************/

size_t
stupidedi_huffman_sizeof(const stupidedi_huffman_t* h)
{
    return 0;
}

size_t
stupidedi_huffman_length(const stupidedi_huffman_t* h)
{
    assert(h != NULL);
    return 0;
}

char*
stupidedi_huffman_to_string(const stupidedi_huffman_t* h)
{
    if (h == NULL)
        return strdup("NULL");

    return NULL;
}

/*****************************************************************************/

void
stupidedi_huffman_encode(stupidedi_huffman_t* h, uint64_t i)
{
}

void
stupidedi_huffman_decode(stupidedi_huffman_t* h, uint64_t i)
{
}
