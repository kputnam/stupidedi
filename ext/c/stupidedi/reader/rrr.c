#include <assert.h>
#include "rrr.h"
//#include "ruby.h"

#include <stdlib.h>
#define ALLOC(type)     malloc(sizeof(type))
#define ALLOC_N(type,n) malloc(sizeof(type) * (size_t)(n))
#define FREE(ptr)       free(ptr)
#define MAX_BLOCK_NBITS 64

/* TODO:
 * [ ] Use MSVC intrinsic for CLZ
 * [ ] Fallback implementation of CLZ
 */

/* https://users.dcc.uchile.cl/~gnavarro/ps/sea12.1.pdf
 *
 * Bit string s of length n is divided to blocks of size u bits. There are ⌈n/u⌉
 * blocks. Each block is assigned a class, r, which is the number of 1-bits in
 * the block (popcount). Each class contains (u choose r) elements. So we can
 * encode each block as a pair (r, o) where r is the class and o identifies an
 * element in class r that equals the block's original bit string.
 *
 * Referring to a class requires ⌈lb(u+1)⌉ bits, and referring to an element of
 * class r requires ⌈lb(u choose r)⌉ bits. Because the width varies based on
 * r, the amount of compression RRR encoding can achieve varies depending on
 * the entropy, H₀, of the original bit string. Entropy can be calculated by
 * n₀lb(n/n₀) + n₁lb(n/n₁); it is minimized when the bit string is either all
 * 1s (most dense) or all 0s (most sparse), and maximized when the bit string
 * is half 0s.
 *
 * The table below shows how many RRR bits are needed to represent one input
 * bit, based on the entropy of the input (p₁ is the probability of 1s bits, so
 * maximum entropy is p₁=0.50).  RRR compression increases with lower entropy
 * and/or with larger block sizes.  When entropy is high enough, an RRR-encoded
 * string will require more space than the original string.
 *
 *      u   p₁=0.05  p₁=0.10  p₁=0.20  p₁=0.50
 *     ----------------------------------------
 *      1      1.00     1.00     1.00     1.00
 *      2      1.05     1.09     1.16     1.25
 *      3      0.76     0.85     0.99     1.17
 *      4      0.85     0.93     1.08     1.28
 *      5      0.74     0.86     1.05     1.29
 *      6      0.64     0.76     0.94     1.17
 *      7      0.57     0.70     0.91     1.18
 *      8      0.64     0.77     0.97     1.23
 *     15      0.45     0.60     0.83     1.10
 *     16      0.50     0.65     0.89     1.15
 *     31      0.38     0.55     0.80     1.06
 *     32      0.41     0.58     0.82     1.09
 *     63      0.34     0.52     0.77     1.04
 *
 * One important point to note is compression increases from u=2^k up to
 * 2^(k+1)-1, where k is an intereger; but then it drops at 2^(k+1). This is
 * because a block size of 2^k requires k+1 bits to encode each block's class,
 * but that extra bit is mostly wasted; on the other hand, block size 2^k-1
 * requires k bits to encode class and the full range from 0..2^k-1 is used.
 */

/*
 * https://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
 * https://graphics.stanford.edu/~seander/bithacks.html#NextBitPermutation
 * https://graphics.stanford.edu/~seander/bithacks.html##CountBitsFromMSBToPos
 * https://graphics.stanford.edu/~seander/bithacks.html##SelectPosFromMSBRank
 */

inline static uint64_t popcount(uint64_t i) {
#if defined ___POPCNT___ || defined __SSE3__
    return __builtin_popcountll(i);
#else
    register uint64_t x = i - ((i & 0xaaaaaaaaaaaaaaaa) >> 1);
    x = (x & 0x3333333333333333) + ((x >> 2) & 0x3333333333333333);
    x = (x + (x >> 4)) & 0x0f0f0f0f0f0f0f0f;
    return x * 0x0101010101010101 >> 56;
#endif
}

inline static uint64_t nbits(uint64_t x) {
#if defined __GNUC__ && __has_builtin(__builtin_clzll)
    return (x < 2) ? 0 : 64 - __builtin_clzll(x - 1);
#else
    return ceil(log2(x));
#endif
}

/* (b choose r) = binomial[b-1][r-1] */
static uint64_t **binomial = NULL;

static void
rrr_precompute_binomials(void) {
    if (binomial == NULL) {
        uint64_t **binomial = ALLOC_N(uint64_t*, MAX_BLOCK_NBITS);

        /* (n choose k) = binomial[n][k] */
        for (uint8_t n = 1; n <= MAX_BLOCK_NBITS; n ++) {
            binomial[n] = ALLOC_N(uint8_t, n + 1);
            binomial[n][0] = 1;
            binomial[n][1] = 1;

            for (uint8_t k = 1; k <= n; k ++)
                binomial[n][k] = binomial[n - 1][k - 1] + binomial[n - 1][k];
        }
    }
}

static inline uint64_t
rrr_encode_offset(
        const uint64_t block_nbits,
        uint64_t class,
        const uint64_t value) {
    assert(binomial != NULL);
    assert(block_nbits > 0);
    assert(class <= block_nbits);
    assert(class == popcount(value));

    /* When block_nbits is 5, here are all elements of class 2 and their offset:
     *
     *   0:  00011 \ There are (5-1 choose 2) values with first bit 0
     *   1:  00101 |
     *   2:  00110 |
     *   3:  01001 |
     *   4:  01010 |
     *   5:  01100 /
     *   6:  10001 \ There are (5-1 choose 1) values with first bit 1
     *   7:  10010 |
     *   8:  10100 |
     *   9:  11000 /
     *
     * We can determine the offset of a value from this set by first inspecting
     * its 5th bit. If it's 0, we know it's one of the first 6 values. If it's
     * 1, we know offset >= 6 because 6 values precede it. We next look at the
     * 4th bit and so on, until we've accounted for all the 1s in the given
     * value.
     */

    uint64_t offset = 0;    /* Minumum offset so far */
    uint64_t n;             /* Index of bit we're inspecting */

#if defined __GNUC__ && __has_builtin(__builtin_clzll)
    /* Immediately skip leading zeros to the first 1-bit */
    n = (value == 0) ? 0 : 63 - __builtin_clzll(value);
#else
    n = block_nbits - 1;
#endif

    for (; class <= n; n --) {
        if (value & (1ULL << n)) {
            offset += binomial[n][class];
            class  --;
        }
    };

    return offset;
}

static inline uint64_t
rrr_decode_offset(
        const uint64_t block_nbits,
        uint64_t class,
        uint64_t offset,
        uint8_t nbits) {
    assert(binomial != NULL);
    assert(block_nbits > 0);
    assert(class <= block_nbits);
    assert(offset < binomial[block_nbits][class]);
    assert(offset >= 0);

    /* When block_nbits is 5, here are the elements of class 2 with their offset:
     *
     *   0:  00011 \ There are (5-1 choose 2) values with first bit 0
     *   1:  00101 |
     *   2:  00110 |
     *   3:  01001 |
     *   4:  01010 |
     *   5:  01100 /
     *   6:  10001 \ There are (5-1 choose 1) values with first bit 1
     *   7:  10010 |
     *   8:  10100 |
     *   9:  11000 /
     *
     * We can determine the value at an offset by first comparing the offset to
     * binomial(5-1, 2) = 6. If it's less, then the first bit must be zero, else
     * it is 1. The next bit is determined by comparing either binomial(4, 2)
     * or binomial(4, 1) depending on how many 1s bits have been accounted for.
     * This continues until two 1s bits have been generated.
     */

    uint64_t value = 0;
    uint64_t n = block_nbits - 1; /* Index of bit we're generating */

    for (; class <= n && n > 0; n --) {
        uint64_t before = binomial[n][class];

        if (before <= offset) {
            value  |= (1ULL << n);
            offset -= before;
            class  --;
        }
    }

    if (class > 0)
        value |= (1ULL << class) - 1;

    return value;
}

void rrr_free(rrr_t* rrr) {
    FREE(rrr->classes);
    FREE(rrr->offsets);
    FREE(rrr->rank_samples);
    FREE(rrr->select_samples);
    FREE(rrr);
}

rrr_t*
rrr_alloc(
        bit_vector_t* bits,
        const uint8_t block_nbits,
        const uint16_t rank_sample_nbits,
        const uint16_t select_sample_nones) {
    assert(block_nbits <= 64);
    assert(rank_sample_nbits >= block_nbits);
    assert(select_sample_nones >= block_nbits);

    /* One-time initialization of global variables */
    rrr_precompute_binomials();

    rrr_t *rrr = ALLOC(rrr_t);
    rrr->size  = bits->size;

    uint64_t orig_record_nbits, offset_idx, class_idx, rank_cumsum,
             rank_sample_idx, rank_sample_need, offset_nbits_max,
             select_sample_idx, select_sample_need;

    /* ceiling(bits->size / 64.0) */
    rrr->nblocks = (bits->size + block_nbits - 1) / block_nbits;

    /* The most bits needed to store any offset. While offsets are stored
     * in variable number of bits, this is used to estimate how much space
     * to allocate for the whole vector of offsets. We will give back any
     * unused bits. */
    offset_nbits_max = nbits(binomial[block_nbits][block_nbits / 2]);

    /* These two vectors are enough to represent the original bit vector. The
     * additional vectors allocated below are the o(n) atop nH₀, and are used
     * for making rank and select operations fast. */
    rrr->classes = bit_vector_alloc_record(rrr->nblocks, nbits(block_nbits + 1));
    rrr->offsets = bit_vector_alloc(rrr->nblocks * offset_nbits_max);
    class_idx    = 0;
    offset_idx   = 0;

    /* The values in this vector refer to bit offsets in rrr->offsets, which
     * has a maximum length of nblocks * offset_nbits_max bits */
    rrr->offset_samples = bit_vector_alloc_record(rrr->nblocks / rank_sample_nbits,
            nbits(rrr->nblocks * offset_nbits_max));

    /* Cumulative rank over all bits is from zero to bits->length (all 1-bits) */
    rrr->rank_samples = bit_vector_alloc_record(rrr->nblocks / rank_sample_nbits, nbits(bits->size + 1));
    rank_sample_idx   = 0;
    rank_cumsum       = 0;
    rank_sample_need  = rank_sample_nbits;

    /* The values in this vector refer to bit offsets in the original bit vector */
    rrr->select_samples = bit_vector_alloc_record(bits->size / select_sample_nones, nbits(bits->size));
    select_sample_idx   = 0;
    select_sample_need  = select_sample_nones;

    /* Encode bit vector one block at a time */
    orig_record_nbits  = bits->record_nbits;
    bits->record_nbits = block_nbits;

    for (uint64_t k = 0; k < rrr->nblocks; k ++) {
        uint64_t block, class, offset;
        block  = bit_vector_read_record(bits, k);
        class  = popcount(block);
        offset = rrr_encode_offset(block_nbits, class, block);

        class_idx  = bit_vector_write_record(rrr->classes, class_idx, class);
        offset_idx = bit_vector_write(rrr->offsets, offset_idx,
                nbits(binomial[block_nbits][class]), offset);

        /* Write rank sample if we have enough data. We know there is at most
         * one sample because block_nbits <= rank_sample_nbits */
        uint64_t rank_sample_excess = block_nbits - rank_sample_need;
        if (rank_sample_excess >= 0) {
            /* We might need only some bits from `block` */
            uint64_t mask, prefix;
            mask   = (1ULL << rank_sample_excess) - 1;
            prefix = block & mask;

            bit_vector_write_record(rrr->offset_samples, rank_sample_idx, offset_idx);
            rank_sample_idx = bit_vector_write_record(rrr->rank_samples,
                    rank_sample_idx, rank_cumsum + popcount(prefix));

            /* Next sample includes the bits not used in last sample */
            rank_sample_need = rank_sample_nbits - rank_sample_excess;
        }

        rank_cumsum += class;

        /* Write select sample if we have seen enough 1s. We know there is at
         * most one sample because block_nbits <= select_sample_nones */
        uint64_t select_sample_excess = class - select_sample_need;

        /* One trick used here is to ensure each sample starts at a 1-bit, so
         * we won't need to scan past the leading zeros later. This is achieved
         * by waiting until we have 1 extra 1-bit, then writing the location of
         * the zero just before it. However, at the very end of the bit string,
         * there won't be another 1-bit, so we write the sample as long as we
         * have at least 0 extra bits (class - need == 0). */
        if (k == rrr->nblocks - 1)
            select_sample_excess ++;

        if (select_sample_excess >= 1) {
            uint64_t prefix, index;
            prefix = block;
            index  = 63 - __builtin_clzll(prefix);

            /* Clear unwanted leading 1-bits */
            while (select_sample_excess >= 1) {
                prefix &= (1ULL << (index - 1)) - 1;

                /* This can only happen when k == nblocks - 1, meaning this is
                 * the last block. We actually have an excess of 0 bits, which
                 * is still enough to write a new sample pointing to the very
                 * last bit. This also avoids the undefined behavior of calling
                 * __builtin_clz(0). */
                if (prefix == 0ULL) {
                    assert(k == rrr->nblocks - 1);
                    assert(select_sample_excess == 1);
                    index = 63;
                    break;
                }

                index   = 63 - __builtin_clzll(prefix);
                select_sample_excess --;
            }

            select_sample_idx = bit_vector_write_record(rrr->select_samples,
                select_sample_idx, (k-1) * block_nbits + index - 1);

            select_sample_need = select_sample_nones - class;
        }
    }

    bits->record_nbits = orig_record_nbits;

    /* Truncate unused space */
    bit_vector_resize(rrr->offsets, offset_idx);
    rrr->rank = rank_cumsum;

    return rrr;
}

uint64_t /* access(B, i) = B[i] */
rrr_access(const rrr_t* rrr, const uint64_t i) {
    return 0ULL;
}

uint32_t /* rank0(B, i) = |{j ∈ [0, i) : B[j] = 0}| */
rrr_rank0(const rrr_t* rrr, const uint64_t i) {
    return i - rrr_rank1(rrr, i);
}

uint32_t /* rank0(B, i) = |{j ∈ [0, i) : B[j] = 1}| */
rrr_rank1(const rrr_t* rrr, const uint64_t i) {
    uint64_t class, offset_idx, rank, rank_sample_idx, bit_idx,
             block_idx, last_block_idx, offset_nbits, offset, block;

    /* This is the block that starts at, or just before, i. Because rrr->offsets
     * is has variable-width entries, we can't randomly access it; we have to
     * start from a known reference point which is either the very beginning or
     * a marker in rrr->sample_offsets that corresponds to rrr->rank_samples */
    last_block_idx = i / rrr->block_nbits;

    /* Lookup the nearest cumulative rank sample (not exceeding i) */
    rank_sample_idx = i / rrr->rank_sample_nbits;
    rank       = bit_vector_read_record(rrr->rank_samples, rank_sample_idx);
    offset_idx = bit_vector_read_record(rrr->offset_samples, rank_sample_idx);

    /* We might have a rank_sample in the middle of a block; so we need to
     * read the rest of that block (but only bits before i). */
    rank_sample_idx *= rrr->rank_sample_nbits;
    block_idx        = rank_sample_idx / rrr->block_nbits;
    bit_idx          = block_idx * rrr->block_nbits;

    if (rank_sample_idx > bit_idx) {
        class  = bit_vector_read_record(rrr->classes, block_idx);
        offset = bit_vector_read(rrr->offsets, offset_idx, nbits(binomial[rrr->block_nbits][class]));
        block  = rrr_decode_offset(rrr->block_nbits, class, offset, rrr->block_nbits);
    }

    while (bit_idx < i) {
        offset_idx += nbits(binomial[rrr->block_nbits][class]);
        class       = bit_vector_read_record(rrr->classes, block_idx++);
        rank       += class;
    }

    /* Now class and offset_idx can be used to compute the block_nbits worth of
     * data which contain the i-th bit. The block starts at the j-th bit. */
    offset_nbits = nbits(binomial[rrr->block_nbits][class]);
    offset  = bit_vector_read(rrr->offsets, offset_idx, offset_nbits);
    bit_idx = rrr->block_nbits * (rank_sample_idx - 1);
    block   = rrr_decode_offset(rrr->block_nbits, class, offset, i - bit_idx);

    return rank + popcount(block);
}

uint32_t /* select0(B, i) = max{j ∈ [0, n) | rank0(j) = i} */
rrr_select0(const rrr_t* rrr, const uint64_t rank) {
    return 0ULL;
}

uint32_t /* select0(B, i) = max{j ∈ [0, n) | rank1(j) = i} */
rrr_select1(const rrr_t* rrr, const uint64_t rank) {
    return 0ULL;
}
