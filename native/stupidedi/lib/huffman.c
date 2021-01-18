#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "stupidedi/include/intmap.h"
#include "stupidedi/include/packed.h"
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/ringbuf.h"

#define CODEWORD_SIZE_MAX   58
#define LENGTH_SIZE_MAX     (64-58)

typedef struct stupidedi_huffman_t
{
    long double l_avg;
    long double K;
    stupidedi_packed_t* levels;
} stupidedi_huffman_t;

static long double* init_normalize_frequencies(size_t count, stupidedi_packed_t* f, stupidedi_packed_t* pi);
static long double* init_adjust_frequencies(size_t L, size_t count, long double* p);
long double         init_compute_kraft_sum(size_t L, size_t* c);
static size_t*      init_compute_codeword_lengths(size_t L, size_t count, const long double* p);
static size_t*      init_fill_unused_space(size_t L, size_t* c);
static uint64_t*    init_generate_codewords(size_t L, const size_t* c);

static inline uint64_t  pack_codeword(size_t l, uint64_t w);

/*
static inline size_t    unpack_length(uint64_t c);
static inline uint64_t  unpack_codeword(uint64_t c);
*/

/******************************************************************************/

stupidedi_huffman_t*
stupidedi_huffman_alloc(void)
{
    return malloc(sizeof(stupidedi_huffman_t));
}

stupidedi_huffman_t*
stupidedi_huffman_dealloc(stupidedi_huffman_t* h)
{
    if (h != NULL)
        stupidedi_huffman_deinit(h);
    return NULL;
}

stupidedi_huffman_t*
stupidedi_huffman_new(stupidedi_packed_t* f)
{
    return stupidedi_huffman_init(stupidedi_huffman_alloc(), f);
}

/* f[i]: the number of occurrences of the i-th symbol */
stupidedi_huffman_t*
stupidedi_huffman_init(stupidedi_huffman_t* h, stupidedi_packed_t* f)
{
    assert(h != NULL);
    assert(f != NULL);

    const uint8_t L    = 58;
    const size_t count =
        stupidedi_packed_length(f);

    assert(log2(count) <= L);

    /* Sort frequencies ascending, and remember the ordering so it can be
     * used to reorder the corresponding array of symbols */
    stupidedi_packed_t *pi;
    pi = stupidedi_packed_argsort(f);

    long double *p;
    p = init_adjust_frequencies(L, count,
            init_normalize_frequencies(count, f, pi));

    /* If we view each symbol as a leaf in a binary tree, its codeword length
     * corresponds to its depth. The Kraft sum K equals exactly 1 only for a
     * full binary tree (every node has either 0 or 2 children). If K < 1, this
     * means there is space in the tree that is not used, because at least one
     * node has a single child. We can bring lower nodes upward to fill in these
     * holes, which corresponds to shortening their codewords. */
    size_t *c;
    c = init_fill_unused_space(L, init_compute_codeword_lengths(L, count, p));

    uint64_t *w;
    w = init_generate_codewords(L, c);

    free(p);
    free(c);

    return h;
}

stupidedi_huffman_t*
stupidedi_huffman_deinit(stupidedi_huffman_t* h)
{
    return h; /* TODO */
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


/*****************************************************************************/

/* Returns an array where p[i] is the frequency of the i-th least frequent
 * symbol. */
static long double*
init_normalize_frequencies(size_t count, stupidedi_packed_t* f, stupidedi_packed_t* pi)
{
    /* Scale frequencies to 0 <= f <= 1 */
    uint64_t total;
    total = 0;

    for (size_t k = 0; k < count; ++k)
        total += stupidedi_packed_read(f, k);

    long double *p;
    p = (long double*) malloc(count * sizeof(long double));

    /* Here we are doing p = sort(f).map{|x| x / total } */
    for (size_t k = 0; k < count; ++k)
        p[k] = (long double) stupidedi_packed_read(f, stupidedi_packed_read(pi, k)) / total;

    return p;
}

/* Returns an array where p[i] is the adjusted frequency of the i-th least
 * frequent symbol. This ensures codewords don't exceed L bits in length. */
static long double*
init_adjust_frequencies(size_t L, size_t count, long double* p)
{
    /* If the least frequent symbol in a model has frequency 0 < f <= 1, and
     * 1/F(k+3) <= f <= F(k+2), where F(k) denotes the k-th Fibonacci number,
     * then the longest codeword is at most K.
     *
     *   Y. S. Abu-Mostafa, R. J. McEliece. Maximal Codeword Lengths in Huffman
     *   Codes. Computers & Mathematics with Applications, vol 39 no 11. pg
     *   129-134, 2000.
     *
     * The most infrequent symbols are assigned the longest codes. To ensure the
     * longest codeword does not exceed L bits, we increase the probabilities of
     * all symbols to at least 2^-L. However, we need to decrease the others to
     * maintain the property that all probabilities sum to 1. */
    long double s, min_p, numerator, denominator;
    min_p       = powl((long double) 2, -(long double) L);
    numerator   = 1;
    denominator = 1.0;

    size_t k;

    for (k = 0; k < count - 1; ++k)
    {
        /* We need to scale the remaining probabilities down by this factor. */
        s = numerator / denominator;

        numerator   -= min_p;
        denominator -= p[k];

        /* Don't stop if scaling down the next largest probability makes it
         * so small that it would be assigned a codeword length longer than L. */
        if (s * p[k+1] >= min_p)
            break;
    }

    if (k > 0)
    {
        for (size_t j = 0; j <= k; ++j)
            p[j] = min_p;

        for (size_t j = k + 1; j < count; ++j)
            p[j] *= s;
    }

    return p;
}

/* TODO */
long double
init_compute_kraft_sum(size_t L, size_t* c)
{
    long double K;
    K = 0;

    /* Compute Kraft sum K = Σ 2^(-p[i]) */
    for (size_t l = 0; l <= L; ++l)
    {
        size_t n;
        n  = c[l];
        K += n * powl((long double) 2, -(long double) l);
    }

    return K;
}

/* Returns array where c[i] is the number of i-bit codewords */
static size_t*
init_compute_codeword_lengths(size_t L, size_t count, const long double* p)
{
    size_t *c;
    c = calloc(L + 1, sizeof(size_t));

    for (size_t i = 0; i < count; ++i)
    {
        long double l;
        l = ceil(-log2l((long double) p[i])) - 1;

        assert(l <= L);
        ++ c[(size_t) l];
    }

    /* The codeword with the highest "value", which is the ratio of how much the
     * Kraft sum decreases to how much the average codeword length increases, is
     * chosen at each iteration. The formula is v = 2^(-l-1)/p.
     *
     * Since we initialized l = ceil(-log2(p)), then v = 2^(ceil(-log2(p))-1)/p,
     * this is monotonically decreasing in p. There's no need to re-sort symbols
     * descending by v, as they are already sorted ascending by p.
     *
     * As stated above, we know the initial codeword length will not increase by
     * more than 1 bit. Therefore, after choosing a codeword, we do not need to
     * consider it again. There's no need to calculate it's new value and sort
     * it amongst the other codewords. */

    long double K;
    K = init_compute_kraft_sum(L, c);

    /* Find the longest codeword that was assigned */
    size_t max_l; for (max_l = L; max_l >= 0 && c[max_l] == 0; --max_l);

    /* When the Kraft sum K > 1, a set of prefix-free codewords cannot be
     * constructed having the lengths in c. The remedy is to increase the
     * codeword lengths, but the difficulty is deciding which ones.
     *
     * Inreasing the length of a codeword from l to l + 1 will lower K by
     * 2^(-l). That means increasing the length of a short codeword has the
     * greater effect, but it also increases the average codeword length by
     * the frequency of that codeword, and short codewords are given higher
     * frequencies.
     *
     * Liddel and Moffat propose at each step, choosing the symbol with the
     * highest ratio between decrease in K to increase in average codeword
     * length. This is calculated by the following formula: v = 2^(-l-1)/p[i].
     * Using the initial lengths we assigned above, this can be written as
     * 2^(-ceil(-log2(p[i])) + 1))/p[i], which decreases as p[i] increases.
     * Because p is sorted ascending, it is also sorted descending by the
     * corresponding v values.
     *
     * The KRAFT-CODER algorithm assigns codeword lengths satisfying ⌈-log p⌉ -
     * 1 <= l <= ⌈-log p⌉, so the initial length is within a single bit of the
     * final length. There is no need to reinsert an element into p after
     * evaluating it once, so we can assign codeword lengths in two passes,
     * counting the initialization pass.
     */
    for (size_t l = max_l; l; --l)
    {
        long double delta;
        delta = K - 1;

        if (delta <= 0)
            break;

        long double unit;
        unit = powl((long double) 2, -(long double) (l + 1));

        size_t n;
        n = ceil(delta / unit);

        if (n > c[l])
            n = c[l];

        /* Increase the length of n l-bit codewords to l+1 bits */
        c[l]     -= n;
        c[l + 1] += n;
        K        -= n * unit;
    }

    return c;
}

/* Returns array where c[i] is the number of i-bit codewords */
static size_t*
init_fill_unused_space(size_t L, size_t* c)
{
    long double K;
    K = init_compute_kraft_sum(L, c);

    /* Find largest codeword length in use */
    size_t max_l; for (max_l = L; max_l > 0 && c[max_l] == 0; --max_l);

    for (size_t l = 1; l < max_l; ++l)
    {
        const long double w =
            powl((long double) 2, -(long double) l);

        /* While there is unused space at level l */
        while (K < 1 - w)
        {
            /* Find a leaf at a lower level to move up to level l */
            size_t j; for (j = l + 1; j <= max_l && c[j] == 0; ++j);

            /* Move leaf from level j up to level l */
            ++ c[l];
            -- c[j];

            K += w - powl((long double) 2, -(long double) j);
        }
    }

    return c;
}

/* Returns an array where w[i] is the codeword for the i-th least frequent
 * symbol. The most significant 64-L bits contain a bit mask that selects
 * the codeword in w[i]. */
static uint64_t*
init_generate_codewords(size_t L, const size_t* c)
{
    size_t n;
    n = 0;

    for (size_t l = 1; l < L; ++l)
        n += c[l];

    /* This will contain the packed codewords */
    uint64_t* w;
    w = malloc(n * sizeof(uint64_t));

    stupidedi_ringbuf_t* q;
    q = stupidedi_ringbuf_new(n, L, EXPAND);

    /* Our queue of unused codewords begins with all 1-bit codes. Each loop
     * iteration removes the needed number of codewords. The codewords that
     * remain are each replaced with two codewords that are 1 bit longer.
     *
     * This method is different from the canonical Huffman coding algorithm,
     * but both produce a set of prefix-free codewords. One property of this
     * coding scheme is that when the codes are placed along the levels of
     * a wavelet matrix, the leaves span a contiguous area not interrupted by
     * any internal nodes. */
    stupidedi_ringbuf_enqueue(q, UINT64_C(0));
    stupidedi_ringbuf_enqueue(q, UINT64_C(1));

    /* Find the longest codeword that was assigned */
    size_t max_l; for (max_l = L; max_l >= 0 && c[max_l] == 0; --max_l);

    /* Codewords are generated in increasing length, so we assign them to
     * decreasingly frequent symbols, starting at the end of the array. */
    for (size_t l = 1; l <= max_l ; ++l)
    {
        for (size_t k = c[l]; k > 0; --k)
            w[--n] = pack_codeword(l, stupidedi_ringbuf_dequeue(q));

        const size_t qsize
            = stupidedi_ringbuf_length(q);

        if (l < max_l - 1) /* No need to do this at the last iteration */
        {
            /* Increase the length of codes in the queue. If the queue looks like
             * A,B,C then the result should look like A0,B0,C0,A1,B1,C1. */
            for (size_t k = 0; k < qsize; ++k)
                stupidedi_ringbuf_enqueue(q, stupidedi_ringbuf_dequeue(q) << 1);

            for (size_t k = 0; k < qsize; ++k)
                stupidedi_ringbuf_enqueue(q, stupidedi_ringbuf_peek(q, k) | 1);
        }
    }

    stupidedi_ringbuf_dealloc(q);

    return w;
}

static inline uint64_t
pack_codeword(size_t l, uint64_t w)
{
    /* The maximum code length that can be supported is described by WORDSIZE =
     * ceil(log2(x)) + x. On a 64-bit machine, x = 58 bits.
     */
    assert(l < (UINT64_C(1) << LENGTH_SIZE_MAX));
    assert(w < (UINT64_C(1) << CODEWORD_SIZE_MAX));

    return (l << CODEWORD_SIZE_MAX) | w;
}

/*
static inline size_t
unpack_length(uint64_t c)
{
    return c >> CODEWORD_SIZE_MAX;
}

static inline uint64_t
unpack_codeword(uint64_t c)
{
    return c & ((1 << unpack_length(c)) - 1);
}*/
