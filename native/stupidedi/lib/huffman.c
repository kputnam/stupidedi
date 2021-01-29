#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "stupidedi/include/packed.h"
#include "stupidedi/include/ringbuf.h"
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/wavelet.h"
#include "stupidedi/include/builtins.h"

#define MIN(a,b) ((a) < (b) ? (a) : (b))
#define CODEWORD_LENGTH_MAX 64

/* Compressed representation of a codebook */
typedef struct stupidedi_huffman_wavelet_t
{
    /* O(L log σ) */
    stupidedi_packed_t*     nodes;      /* nodes[l]:   Number of nodes in code tree at level l */

    /* O(L log σ) */
    stupidedi_packed_t*     leaves;     /* leaves[l]:  Number of leaves in code tree at level l */

    /* O(TODO) */
    stupidedi_wavelet_t*    lengths;    /* lengths[i]: Length of codeword for i-th most common symbol */
} stupidedi_huffman_wavelet_t;

/* Uncompressed representation of a codebook */
typedef struct stupidedi_huffman_packed_t
{
    /* O(σL), encode[i]:  The codeword for the i-th most common symbol */
    stupidedi_packed_t* encode;

    /* O(oL), Codewords sorted in ascending lexicographic order
     * TODO: This could be O(σ log σ) */
    stupidedi_packed_t* decode;

    /* O(σ log σ), lengths[i]: Length of codeword for i-th most common symbol */
    stupidedi_packed_t* lengths;

    /* O(σ log σ), symbols[k]: The symbol corresponding to decode[k] */
    stupidedi_packed_t* symbols;

    /* O(L log σ), offsets[l]: Number of codewords shorter than l bits */
    stupidedi_packed_t* offsets;
} stupidedi_huffman_packed_t;

struct stupidedi_huffman_t
{
    /* σ, Number of symbols */
    size_t      count;

    /* L, Length of longest codeword */
    uint8_t     max_l;

    /* Average codeword length, weighted by their frequencies */
    long double avg_l;

    /* Kraft sum. When K=1, the code tree has unused space */
    long double K;

    enum type   type;
    union
    {
        stupidedi_huffman_wavelet_t wavelet;
        stupidedi_huffman_packed_t  packed;
    };
};

static void         init_assert_no_zeros(stupidedi_packed_t*);
static void         init_assert_sorted_asc(stupidedi_packed_t*);
static long double* init_normalize_frequencies(size_t, stupidedi_packed_t*);
static long double* init_adjust_frequencies(size_t, size_t, long double*);
static long double  init_compute_kraft_sum(size_t, size_t*);
static size_t*      init_compute_codeword_lengths(size_t, size_t, const long double*);
static size_t*      init_fill_unused_space(size_t, size_t*);
static void         init_generate_codewords_wavelet(stupidedi_huffman_t*, const size_t, const size_t*);
static void         init_generate_codewords_packed(stupidedi_huffman_t*, const size_t, const size_t*);

/******************************************************************************/

stupidedi_huffman_t*
stupidedi_huffman_alloc(void)
{
    return malloc(sizeof(stupidedi_huffman_t));
}

stupidedi_huffman_t*
stupidedi_huffman_free(stupidedi_huffman_t* h)
{
    if (h != NULL)
        stupidedi_huffman_deinit(h);
    return NULL;
}

stupidedi_huffman_t*
stupidedi_huffman_new(uint8_t L, stupidedi_packed_t* f, enum type type)
{
    return stupidedi_huffman_init(stupidedi_huffman_alloc(), L, f, type);
}

/* Constructs an approximately optimal prefix-free length-limited code in O(σ)
 * time, where σ is the number of symbols in the alphabet. The codebook itself
 * is represented in O(σL) space, encoding a symbol requires O(1) time, and
 * decoding a codeword of length l requires O(l) time.
 *
 * With further compression, the codebook can be represented in O(σ log L)
 * space, though both encoding and decoding require O(l) time. Using O(2^εL)
 * additional bits, with constant ε>0, this time is brought down to O(1).
 */
stupidedi_huffman_t*
stupidedi_huffman_init(stupidedi_huffman_t* h, uint8_t L, stupidedi_packed_t* f, enum type type)
{
    assert(h != NULL);
    assert(f != NULL);

    const size_t alphabet_size =
        stupidedi_packed_length(f);

    assert(L <= CODEWORD_LENGTH_MAX);
    assert(ceill(log2l(alphabet_size)) <= L);
    assert(alphabet_size > 0);
    init_assert_no_zeros(f);
    init_assert_sorted_asc(f);

    long double *p;
    p = init_normalize_frequencies(alphabet_size, f);
    p = init_adjust_frequencies(L, alphabet_size, p);

    size_t *c;
    c = init_compute_codeword_lengths(L, alphabet_size, p);
    c = init_fill_unused_space(L, c);

    h->K     = init_compute_kraft_sum(L, c);
    h->avg_l = 0; /* TODO */
    h->count = alphabet_size;

    if (type == WAVELET)
        init_generate_codewords_wavelet(h, L, c);
    else
        init_generate_codewords_packed(h, L, c);

    free(p);
    free(c);

    return h;
}

stupidedi_huffman_t*
stupidedi_huffman_deinit(stupidedi_huffman_t* h)
{
    if (h == NULL)
        return h;

    if (h->type == WAVELET)
    {
        if (h->wavelet.nodes != NULL)   h->wavelet.nodes   = stupidedi_packed_free(h->wavelet.nodes);
        if (h->wavelet.leaves != NULL)  h->wavelet.leaves  = stupidedi_packed_free(h->wavelet.leaves);
        if (h->wavelet.lengths != NULL) h->wavelet.lengths = stupidedi_wavelet_free(h->wavelet.lengths);
    }
    else
    {
        if (h->packed.encode != NULL)   h->packed.encode  = stupidedi_packed_free(h->packed.encode);
        if (h->packed.lengths != NULL)  h->packed.lengths = stupidedi_packed_free(h->packed.lengths);
        if (h->packed.offsets != NULL)  h->packed.offsets = stupidedi_packed_free(h->packed.offsets);
        if (h->packed.decode != NULL)   h->packed.decode  = stupidedi_packed_free(h->packed.decode);
        if (h->packed.symbols != NULL)  h->packed.symbols = stupidedi_packed_free(h->packed.symbols);
    }

    return h;
}

/*****************************************************************************/

size_t
stupidedi_huffman_sizeof(const stupidedi_huffman_t* h)
{
    return (h == NULL) ? 0 : sizeof(*h) /*+ TODO */;
}

/* Returns number of symbols in the codebook */
size_t
stupidedi_huffman_count(const stupidedi_huffman_t* h)
{
    assert(h != NULL);
    return h->count;
}

char*
stupidedi_huffman_to_string(const stupidedi_huffman_t* h)
{
    if (h == NULL)
        return strdup("NULL");

    /* TODO */
    return NULL;
}

/*****************************************************************************/

uint8_t
stupidedi_huffman_max_codeword_length(const stupidedi_huffman_t* h)
{
    assert(h != NULL);
    return h->max_l;
}

static uint8_t
stupidedi_huffman_encode_wavelet(const stupidedi_huffman_t* h, const size_t i, uint64_t* w)
{
    uint8_t l;
    l = stupidedi_wavelet_access(h->wavelet.lengths, i);

    size_t r;
    r = stupidedi_wavelet_rank(h->wavelet.lengths, l, i);

    /* Below, r[x] denotes the lexicographic rank of x's reversed path label
     * among all other reversed path labels at x's depth, and l[x] is the path
     * length to x.
     *
     * - v is u's 0-child, if and only if r[v] <= nodes[l[v]]/2. This is because
     *   0-children and 1-children are each half the nodes at any depth, and the
     *   reversed path labels of all 0-children are less than the reversed path
     *   labels of 1-children at the same depth (0... < 1...).
     *
     * - if v is u's 0-child, then r[u] = r[v] + leaves[l[u]]. This is because
     *   the reversed path labels of leaves are ranked less than the reversed
     *   path labels of internal nodes at the same depth, and leaves at l[u] are
     *   not present at l[v], one level deeper.
     *
     * - if v is u's 1-child, then r[u] = r[v] + leaves[l[u]] - nodes[l[v]]/2.
     *   This is for the same reasons given for the two observations above.
     *
     * - v is a leaf if and only if r[v] <= leaves[l[v]], because the the
     *   reversed path labels of leaves are ranked less than the reversed path
     *   labels of internal nodes at the same depth.
     */
    assert(r <= stupidedi_packed_read(h->wavelet.leaves, l));

    if (w == NULL)
        return l;

    uint64_t _w;
    _w = 0;

    for (; l > 0; --l)
    {
        /* Child level is l, parent level is l-1 */

        if (r <= stupidedi_packed_read(h->wavelet.nodes, l) / 2)
        {
            /* Current node is a 0-child of parent */
            _w = (_w << 1) | 0;
            r += stupidedi_packed_read(h->wavelet.leaves, l - 1);
        }
        else
        {
            /* Current node is a 1-child of parent */
            _w = (_w << 1) | 1;
            r += stupidedi_packed_read(h->wavelet.leaves, l - 1);
            r -= stupidedi_packed_read(h->wavelet.nodes, l)/2;
        }
    }

    *w = _w;
    return l;
}

static uint8_t
stupidedi_huffman_encode_packed(const stupidedi_huffman_t* h, const size_t i, uint64_t* w)
{
    *w = stupidedi_packed_read(h->packed.encode, i);
    return stupidedi_packed_read(h->packed.lengths, h->count - i - 1);
}

uint8_t
stupidedi_huffman_encode(const stupidedi_huffman_t* h, const size_t i, uint64_t* w)
{
    assert(h != NULL);
    assert(w != NULL);
    assert(i < h->count);

    return (h->type == WAVELET) ?
        stupidedi_huffman_encode_wavelet(h, i, w) :
        stupidedi_huffman_encode_packed(h, i, w);
}

static uint8_t
stupidedi_huffman_decode_wavelet(const stupidedi_huffman_t* h, const uint64_t bits, const uint8_t length, size_t* i)
{
    /* This requires O(l) time, even when the length of the first codeword in
     * `bits` is not known. If a match is found, an additional O(log l) step
     * is performed. */

    /* Below, r[x] denotes the lexicographic rank of x's reversed path label
     * among all other reversed path labels at x's depth, and l[x] is the path
     * length to x.
     *
     * - v is u's 0-child, if and only if r[v] <= nodes[l[v]]/2. This is because
     *   0-children and 1-children are each half the nodes at any depth, and the
     *   reversed path labels of all 0-children are less than the reversed path
     *   labels of 1-children at the same depth (0... < 1...).
     *
     * - if v is u's 0-child, then r[v] = r[u] - leaves[l[u]]. This is because
     *   the reversed path labels of leaves are ranked less than the reversed
     *   path labels of internal nodes at the same depth, and leaves at l[u] are
     *   not present at l[v], one level deeper.
     *
     * - if v is u's 1-child, then r[v] = r[u] - leaves[l[u]] + nodes[l[v]]/2.
     *   This is for the same reasons given for the two observations above.
     *
     * - v is a leaf if and only if r[v] <= leaves[l[v]], because the the
     *   reversed path labels of leaves are ranked less than the reversed path
     *   labels of internal nodes at the same depth.
     */

    /* Root node is l=0, r=1 */
    size_t r = 1;

    uint64_t mask;
    mask = UINT64_C(1) << (length - 1);

    for (size_t l = 0; l < length; ++l)
    {
        /* Parent level is l, child level is l+1 */
        r -= stupidedi_packed_read(h->wavelet.leaves, l);

        if ((bits & mask) != 0)
            r += stupidedi_packed_read(h->wavelet.nodes, l + 1)/2;

        if (r < stupidedi_packed_read(h->wavelet.leaves, l + 1))
        {
            if (i != NULL)
                *i = stupidedi_wavelet_select(h->wavelet.lengths, l + 1, r);
            return l + 1;
        }

        mask <<= 1;
    }

    return 0;
}

static uint8_t
stupidedi_huffman_decode_packed(const stupidedi_huffman_t* h, uint64_t bits, uint8_t l, size_t* i)
{
    /* We assume `bits` is an input buffer that may contain a partial codeword,
     * a whole codeword, or a codeword and some parts of the next codeword. We
     * have to probe each possible codeword length individually, so this search
     * requires O(l + (l-1) + (l-2) + ... + 1) = O(l²) time.
     *
     * If `l` is known in advance and `bits` contains a valid codeword, this
     * only requires O(l) time.
     *
     * TODO: This makes decoding bit streams infeasible! */
    for (size_t _l = MIN(l, h->max_l); _l > 0; --_l)
    {
        uint64_t mask;
        mask = (UINT64_C(1) << _l) - 1;

        uint64_t w;
        w = (bits >> (l - _l)) & mask;

        size_t lo, hi;
        lo = stupidedi_packed_read(h->packed.offsets, _l);
        hi = stupidedi_packed_read(h->packed.offsets, _l + 1);

        if (lo == hi)
            continue; /* No codewords have length _l */

        /* Since lo <= hi and lo != hi, this will not overflow */
        -- hi;

        if (w < stupidedi_packed_read(h->packed.decode, lo) ||
            stupidedi_packed_read(h->packed.decode, hi) < w)
            continue; /* No codewords of length _l are as large or small as w */

        /* Perform a binary search on all codewords of length _l */
        while (lo <= hi)
        {
            size_t k;
            k = lo + (hi - lo) / 2;

            uint64_t _w;
            _w = stupidedi_packed_read(h->packed.decode, k);

            if (_w < w)
                lo = k + 1;
            else if (_w > w)
                hi = k - 1;
            else
            {
                if (i != NULL)
                    *i = stupidedi_packed_read(h->packed.symbols, k);
                return _l;
            }
        }
    }

    return 0;
}

uint8_t
stupidedi_huffman_decode(const stupidedi_huffman_t* h, uint64_t w, uint8_t l, size_t* i)
{
    assert(h != NULL);

    if (l == 0)
        return 0;

    return (h->type == WAVELET) ?
        stupidedi_huffman_decode_wavelet(h, w, l, i) :
        stupidedi_huffman_decode_packed(h, w, l, i);
}

uint8_t
stupidedi_huffman_decode_next(const stupidedi_huffman_t* h, const stupidedi_bitstr_t* b, size_t i)
{
    return 0; /* TODO */
}

/*****************************************************************************/

static void
init_assert_no_zeros(stupidedi_packed_t* f)
{
    const size_t count
        = stupidedi_packed_length(f);

    for (size_t i = 0; i < count; ++i)
        assert(0 < stupidedi_packed_read(f, i));
}

static void
init_assert_sorted_asc(stupidedi_packed_t* f)
{
    const size_t count
        = stupidedi_packed_length(f);

    uint64_t a;
    a = stupidedi_packed_read(f, 0);

    for (size_t i = 0; i < count - 1; ++i)
    {
        uint64_t b;
        b = stupidedi_packed_read(f, i + 1);

        assert(a <= b);
        a = b;
    }
}

/* Returns an array where p[i] is the frequency of the i-th least frequent
 * symbol. */
static long double*
init_normalize_frequencies(size_t count, stupidedi_packed_t* f)
{
    /* Scale frequencies to 0 <= f <= 1 */
    uint64_t total;
    total = 0;

    for (size_t i = 0; i < count; ++i)
        total += stupidedi_packed_read(f, i);

    long double *p;
    p = (long double*) malloc(count * sizeof(long double));

    for (size_t i = 0; i < count; ++i)
        p[i] = (long double) stupidedi_packed_read(f, i) / total;

    return p;
}

/* Returns an array where p[i] is the adjusted frequency of the i-th least
 * frequent symbol. This ensures codewords don't exceed L bits in length. */
static long double*
init_adjust_frequencies(size_t L, size_t count, long double* p)
{
    /* If the least frequent symbol in a model has frequency 0 < f <= 1, and
     * 1/F(k+3) <= f <= F(k+2), where F(k) denotes the k-th Fibonacci number,
     * then the longest codeword is at most K bits.
     *
     *   Y. S. Abu-Mostafa, R. J. McEliece. Maximal Codeword Lengths in Huffman
     *   Codes. Computers & Mathematics with Applications, vol 39 no 11. pg
     *   129-134, 2000.
     *
     * The most infrequent symbols are assigned the longest codes. To ensure the
     * longest codeword does not exceed L bits, we increase the probabilities of
     * all symbols to at least 2^-L. However, we then need to decrease the
     * others to maintain the property that all probabilities sum to 1. */
    long double s, min_p, numerator, denominator;
    min_p       = powl((long double) 2, -(long double) L);
    numerator   = 1;
    denominator = 1.0;

    size_t i;

    for (i = 0; i < count - 1; ++i)
    {
        /* We need to scale the remaining probabilities down by this factor. */
        s = numerator / denominator;

        numerator   -= min_p;
        denominator -= p[i];

        /* Don't stop if scaling down the next largest probability makes it
         * so small that it would be assigned a codeword length longer than L. */
        if (s * p[i+1] >= min_p)
            break;
    }

    if (i > 0)
    {
        for (size_t j = 0; j <= i; ++j)
            p[j] = min_p;

        for (size_t j = i + 1; j < count; ++j)
            p[j] *= s;
    }

    return p;
}

/* TODO */
static long double
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
        l = ceill(-log2l((long double) p[i])) - 1;

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
        n = ceill(delta / unit);

        if (n > c[l])
            n = c[l];

        /* Increase the length of n l-bit codewords to l+1 bits */
        c[l]     -= n;
        c[l + 1] += n;
        K        -= n * unit;
    }

    return c;
}


/* If we view each symbol as a leaf in a binary tree, its codeword length
 * corresponds to its depth. The Kraft sum K equals exactly 1 only for a full
 * binary tree (every node has either 0 or 2 children). If K < 1, this means
 * there is space in the tree that is not used, because at least one node has a
 * single child. We can bring lower nodes upward to fill in these holes, which
 * corresponds to shortening their codewords.
 *
 * Returns array where c[i] is the number of i-bit codewords */
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

static void
init_generate_codewords_packed(stupidedi_huffman_t* h, const size_t L, const size_t* c)
{
    assert(h != NULL);

    size_t count;
    count = 0;

    for (size_t l = 1; l < L; ++l)
        count += c[l];

    stupidedi_ringbuf_t* q;
    q = stupidedi_ringbuf_new(count, L, FAIL);

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

    /* Find the longest codeword that was assigned. */
    size_t max_l; for (max_l = L; max_l >= 0 && c[max_l] == 0; --max_l);

    /* These are used when we're not compressing the Huffman model */
    stupidedi_packed_t *encode, *decode, *lengths, *offsets, *symbols;
    encode  = stupidedi_packed_new(count, max_l);
    decode  = stupidedi_packed_new(count, max_l);
    lengths = stupidedi_packed_new(count, nbits(max_l + 1));
    symbols = stupidedi_packed_new(count, nbits(count));
    offsets = stupidedi_packed_new(max_l + 2, nbits(count + 1));

    for (size_t l = 1, i = 0; l <= max_l ; ++l)
    {
        stupidedi_packed_write(offsets, l, i);

        for (size_t k = c[l]; k > 0; --k, ++i)
        {
            uint64_t w;
            w = stupidedi_ringbuf_dequeue(q);

            stupidedi_packed_write(encode,  count - i - 1, w);
            stupidedi_packed_write(lengths, i, l);
            stupidedi_packed_write(decode,  i, w);
        }

        const size_t qsize
            = stupidedi_ringbuf_length(q);

        /* Increase the length of codes in the queue. If the queue looks
         * like A,B,C then the result should look like A0,B0,C0,A1,B1,C1. */
        for (size_t k = 0; k < qsize; ++k)
            stupidedi_ringbuf_enqueue(q, stupidedi_ringbuf_dequeue(q) << 1);

        for (size_t k = 0; k < qsize; ++k)
            stupidedi_ringbuf_enqueue(q, stupidedi_ringbuf_peek(q, k) | 1);
    }

    stupidedi_ringbuf_free(q);

    stupidedi_packed_write(offsets, 0, 0);
    stupidedi_packed_write(offsets, max_l+1, count);

    /* Sort codewords and their corresponding symbols at each level, so we can
     * locate codewords using binary search when decoding. */
    for (size_t l = 0; l <= max_l; ++l)
    {
        size_t start, length;
        start  = stupidedi_packed_read(offsets, l);
        length = stupidedi_packed_read(offsets, l + 1) - start;

        if (length > 0)
        {
            size_t *idx;
            idx = stupidedi_packed_argsort_range(decode, start, length);

            uint64_t *tmp;
            tmp = malloc(length * sizeof(uint64_t));

            for (size_t i = 0; i < length; ++i)
            {
                stupidedi_packed_write(symbols, start + i, count - (start + idx[i]) - 1);
                tmp[i] = stupidedi_packed_read(decode, start + idx[i]);
            }

            for (size_t i = 0; i < length; ++i)
                stupidedi_packed_write(decode, start + i, tmp[i]);
        }
    }

    h->type             = PACKED;
    h->max_l            = max_l;
    h->packed.encode    = encode;
    h->packed.decode    = decode;
    h->packed.lengths   = lengths;
    h->packed.offsets   = offsets;
    h->packed.symbols   = symbols;
}

/* Represent the sequence D={length(w[i]) | i=0..σ-1} using a wavelet tree,
 * in O(σ log L) bits. This provides the following operations in O(log L)
 * time:
 *
 * - l = access(D,i): gives the length of i-th codeword
 * - r = rank(D,l,i): gives the position of the i-th codeword among those of length l
 * - i = select(D,l,r): gives the position in D of the rth codeword of length l
 *
 * To decode the first symbol from an encoded string, we first need to
 * determine l and r of the first codeword in the string. Using this, we
 * can decode i = select(D,l,r). To encode a symbol i, we determine l =
 * access(D,i) and r = rank(D,l,i), and then must find the codeword given l
 * an r.
 *
 * These can be accomplished in O(l) time using an additional O(L log σ)
 * bits. Let leaves[d] and nodes[d] be the number of leaves and the total
 * number of nodes at depth d, respectively. Let r[v] be the lexicographic
 * rank of v's reversed path label among all the reversed path labels of
 * nodes at v's depth. Due to how codewords are chosen, the following rules
 * hold:
 *
 * - reversed path labels of all leaves at each depth are lexicographically
 *   less than the reversed path labels of internal nodes at that depth
 * - v is u's left child if and only if r[v] <= nodes(depth(v)) / 2
 * - if v is u's left child,  then r[v] = r[u] - leaves(depth(u))
 * - if v is u's right child, then r[v] = r[u] - leaves(depth(u)) + nodes(depth(v))/2
 *
 * We can decode a string by starting at the root of the code tree and in
 * O(l) time, descending bit-by-bit until we reach a leaf. We know v is a
 * leaf when r[v] <= leaves(depth(v)), due to the first observation. This
 * provides l and r, which can be used to find i, which is the index into
 * the array of symbols.
 *
 * To encode the i-th symbol, we determine l and r using the wavelet tree.
 * Using the formulas to walk upwards to the root, finding r[u] and deciding
 * if v is the left or right child of u. This yields the l bits of the i-th
 * codeword in reverse order, and in time O(l).
 */
static void
init_generate_codewords_wavelet(stupidedi_huffman_t* h, size_t L, const size_t* c)
{
    assert(h != NULL);

    size_t count;
    count = 0;

    for (size_t l = 1; l < L; ++l)
        count += c[l];

    /* Find the longest codeword that was assigned. */
    size_t max_l; for (max_l = L; max_l >= 0 && c[max_l] == 0; --max_l);

    stupidedi_packed_t *nodes, *leaves, *lengths;
    nodes   = stupidedi_packed_new(max_l + 1, nbits(count));
    leaves  = stupidedi_packed_new(max_l + 1, nbits(count));
    lengths = stupidedi_packed_new(h->count, max_l);

    /* Root node at level 0 */
    stupidedi_packed_write(nodes,  0, 1);
    stupidedi_packed_write(leaves, 0, 0);

    size_t qsize;
    qsize = 2; /* {0, 1} */

    for (size_t l = 1; l <= max_l ; ++l)
    {
        stupidedi_packed_write(leaves, l, c[l]);
        stupidedi_packed_write(nodes,  l, qsize);

        for (size_t k = c[l]; --k; )
            stupidedi_packed_write(lengths, l, c[l]);

        qsize -= c[l];
        qsize *= 2;
    }

    /* The deepest level has no internal nodes, only leaves */
    stupidedi_packed_write(nodes, max_l,
            stupidedi_packed_read(leaves, max_l));

    h->type            = WAVELET;
    h->max_l           = max_l;
    h->wavelet.nodes   = nodes;
    h->wavelet.leaves  = leaves;
    h->wavelet.lengths = stupidedi_wavelet_new(lengths, NULL);

    stupidedi_packed_free(lengths);
}
