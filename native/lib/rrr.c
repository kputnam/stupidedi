#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "rrr.h"
#include "bit_vector.h"

/* This implementation is based on "Fast, Small, Simple Rank/Select on Bitmaps",
 * and implements "A Structure for Compressed Bitmaps"
 *
 *  https://users.dcc.uchile.cl/~gnavarro/ps/sea12.1.pdf
 *
 * Bit string s of length n is divided to blocks of size u bits. There are ⌈n/u⌉
 * blocks. Each block is assigned a class, r, which is the number of 1-bits in
 * the block. Each class contains (u choose r) elements. We can encode each block
 * as a pair (r, o) where r is its class and o identifies the element in class r.
 *
 * Representing a class requires ⌈lb(u+1)⌉ bits, and representing an element of
 * class r requires ⌈lb(u choose r)⌉ bits. Because this width varies based on
 * r, the amount of compression RRR encoding can achieve varies depending on
 * the entropy, H₀, of the original bit string. Entropy can be calculated by
 * n₀lb(n/n₀) + n₁lb(n/n₁); it is minimized when the bit string is either all
 * 1s or all 0s (most dense or most sparse), and maximized when the bit string
 * is half 0s and half 1s.
 *
 * The table below shows how many bits are needed to encode one input * bit,
 * based on the entropy of the input (p₁ is the probability of 1s bits, so
 * maximum entropy is p₁=0.50). RRR compression increases with lower entropy
 * and/or with larger block sizes. When entropy is high enough, an RRR-encoded
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
 * One important thing to note is compression increases from u=2^k up to
 * 2^(k+1)-1, where k is an intereger; but then it drops at 2^(k+1). This is
 * because a block size of 2^k requires k+1 bits to encode each block's class,
 * but that extra bit is mostly wasted; on the other hand, block size 2^k-1
 * requires k bits to encode class and the full range from 0..2^k-1 is used.
 */

/* (b choose r) = binomial[b][r] */
static uint64_t **binomial = NULL;

static void rrr_precompute_binomials(void);
static inline uint8_t popcount(uint64_t);
static inline uint8_t clz(uint64_t);
static inline uint8_t ctz(uint64_t);
static inline uint8_t nbits(uint64_t);
static inline uint8_t offset_nbits(uint64_t, uint64_t);
static inline uint64_t rrr_encode_block(uint64_t, uint64_t, uint64_t);
static inline uint64_t rrr_decode_block(uint64_t, uint64_t, uint64_t);

#define RRR_READ_OFFSET(rrr, offset_at, width) \
    (rrr)->offsets->size == 0 ? 0 : bit_vector_read((rrr)->offsets, (offset_at), (width))

rrr_builder_t* rrr_builder_alloc(uint8_t block_size, uint16_t marker_size, bit_idx_t size, rrr_builder_t* builder, rrr_t* rrr) {
    assert(size > 0);
    assert(block_size >= RRR_BLOCK_SIZE_MIN);
    assert(block_size <= RRR_BLOCK_SIZE_MAX);
    assert(block_size <= marker_size);
    assert(marker_size >= RRR_MARKER_SIZE_MIN);
    assert(marker_size <= RRR_MARKER_SIZE_MAX);

    /* One-time initialization of global variables */
    rrr_precompute_binomials();

    if (builder == NULL)
        builder = malloc(sizeof(rrr_builder_t));
    assert(builder != NULL);

    if (rrr == NULL)
        rrr = malloc(sizeof(rrr_t));

    builder->rrr = rrr;
    assert(rrr != NULL);

    rrr->size         = size;
    rrr->rank         = 0;
    rrr->nblocks      = (size + block_size - 1) / block_size;
    rrr->nmarkers     = (size + block_size - 1) / marker_size;
    rrr->block_size   = block_size;
    rrr->marker_size  = marker_size;

    builder->offset_nbits_max = offset_nbits(block_size, block_size / 2);
    builder->block       = 0;
    builder->written     = 0;
    builder->class_at    = 0;
    builder->offset_at   = 0;
    builder->marker_at   = 0;
    builder->marker_need = marker_size;
    builder->block_need  = block_size;

    /* These two vectors are sufficient to encode the original bit vector. The
     * additional vectors allocated below are the o(n) atop nH₀, and are used
     * for making rank and select operations fast. */
    rrr->classes = bit_vector_alloc_record(rrr->nblocks, nbits(block_size + 1), NULL);
    rrr->offsets = bit_vector_alloc((bit_idx_t)(rrr->nblocks * builder->offset_nbits_max), NULL);

    if (rrr->nmarkers > 0) {
        rrr->marked_ranks   = bit_vector_alloc_record(rrr->nmarkers, nbits(size + 1), NULL);
        rrr->marked_offsets = bit_vector_alloc_record(rrr->nmarkers, nbits(rrr->offsets->size), NULL);
    } else {
        rrr->marked_ranks   = NULL;
        rrr->marked_offsets = NULL;
    }

    return builder;
}

void rrr_builder_append(rrr_builder_t* builder, uint8_t width, uint64_t value) {
    assert(builder != NULL);
    assert(builder->rrr != NULL);
    assert(width <= RRR_BLOCK_SIZE_MAX);
    assert(value <= (width < 64) ? (1ull << width) - 1 : -1);

    rrr_t* rrr;
    rrr = builder->rrr;

    uint64_t block, mask, uncommitted;
    uncommitted = rrr->block_size - builder->block_need;
    assert(builder->written + uncommitted + width <= rrr->size);

    while (builder->block_need <= width) {
        /* Select only bits needed to finish filling this block, then append to
         * the end of the current block*/
        mask   = (1ull << builder->block_need) - 1;
        block  = builder->block;
        block |= (value & mask) << (rrr->block_size - builder->block_need);

        /* Discard the used bits */
        value  = value >> builder->block_need;
        width -= builder->block_need;

        uint64_t class, offset;
        class  = popcount(block);
        offset = rrr_encode_block(rrr->block_size, class, block);

        /* Write marker if we have enough data. We know there is no more
         * than one marker because block_size <= sblock_nbits */
        int64_t marker_extra = rrr->block_size - builder->marker_need;

        if (marker_extra >= 0) {
            /* We might need only first few bits from `block` */
            uint64_t want, prefix;
            want   = rrr->block_size - marker_extra;
            prefix = (want >= 64) ? block : block & ((1ull << want) - 1);

            bit_vector_write_record(rrr->marked_ranks,   builder->marker_at, rrr->rank + popcount(prefix));
            bit_vector_write_record(rrr->marked_offsets, builder->marker_at, builder->offset_at);
            builder->marker_at ++;

            /* Next marker counts the bits not used in last marker */
            builder->marker_need = rrr->marker_size - marker_extra;
        } else {
            builder->marker_need -= rrr->block_size;
        }

        builder->class_at  = bit_vector_write_record(rrr->classes, builder->class_at, class);
        builder->offset_at = bit_vector_write(rrr->offsets, builder->offset_at, offset_nbits(rrr->block_size, class), offset);
        builder->written  += rrr->block_size;

        /* Next time we'll need a full block */
        builder->block      = 0ull;
        builder->block_need = rrr->block_size;

        rrr->rank += class;
    }

    /* Remaining value is guaranteed to be shorter than block_need */
    mask   = (1ull << builder->block_need) - 1;
    block  = builder->block;
    block |= (value & mask) << (rrr->block_size - builder->block_need);
    builder->block = block;
    builder->block_need -= width;
}

rrr_t* rrr_builder_finish(rrr_builder_t* builder) {
    assert(builder != NULL);
    assert(builder->rrr != NULL);

    rrr_t* rrr;
    rrr = builder->rrr;

    uint64_t uncommitted;
    uncommitted = rrr->block_size - builder->block_need;
    assert(builder->written + uncommitted == rrr->size);

    if (builder->class_at < rrr->nblocks) {
        /* Haven't yet written the last block */
        uint64_t class, offset;
        class  = popcount(builder->block);
        offset = rrr_encode_block(rrr->block_size, class, builder->block);
        rrr->rank += class;

        bit_vector_write_record(rrr->classes, builder->class_at, class);
        bit_vector_write(rrr->offsets, builder->offset_at, offset_nbits(rrr->block_size, class), offset);
    }

    if (builder->marker_need < rrr->marker_size && builder->marker_at < rrr->nmarkers) {
        /* Haven't yet written the last marker */
        bit_vector_write_record(rrr->marked_ranks,   builder->marker_at, rrr->rank);
        bit_vector_write_record(rrr->marked_offsets, builder->marker_at, builder->offset_at);
    }

    /* Truncate unused space */
    bit_vector_resize(rrr->offsets, builder->offset_at);
    return rrr;
}

void rrr_builder_free(rrr_builder_t* builder) {
    if (builder != NULL) free(builder);
}

rrr_t*
rrr_alloc(bit_vector_t* bits, uint8_t block_size, uint16_t marker_size, rrr_t* rrr) {
    rrr_builder_t builder;
    rrr_builder_alloc(block_size, marker_size, bits->size, &builder, rrr);

    uint64_t nblocks, remainder;

    /* This counts full blocks, but may exclude the last block if it's partial */
    nblocks = bits->size / RRR_BLOCK_SIZE_MAX;
    for (uint64_t k = 0; k < nblocks; k ++)
        rrr_builder_append(&builder, RRR_BLOCK_SIZE_MAX,
                bit_vector_read(bits, k * RRR_BLOCK_SIZE_MAX, RRR_BLOCK_SIZE_MAX));

    /* The last block could be smaller, so we handle it separately */
    remainder = bits->size - (nblocks * RRR_BLOCK_SIZE_MAX);
    if (remainder > 0)
        rrr_builder_append(&builder, remainder,
                bit_vector_read(bits, nblocks * RRR_BLOCK_SIZE_MAX, remainder));

    return rrr_builder_finish(&builder);

    /*
    assert(bits->size > 0);
    assert(block_size >= RRR_BLOCK_SIZE_MIN);
    assert(block_size <= RRR_BLOCK_SIZE_MAX);
    assert(block_size <= marker_size);
    assert(marker_size >= RRR_MARKER_SIZE_MIN);
    assert(marker_size <= RRR_MARKER_SIZE_MAX);

    // One-time initialization of global variables //
    rrr_precompute_binomials();

    if (rrr == NULL)
        rrr = malloc(sizeof(rrr_t));
    assert(rrr != NULL);

    rrr->size         = bits->size;
    rrr->rank         = 0;
    rrr->nblocks      = (bits->size + block_size - 1) / block_size;
    rrr->nmarkers     = (bits->size + block_size - 1) / marker_size;
    rrr->block_size   = block_size;
    rrr->marker_size  = marker_size;

    uint8_t  offset_nbits_max;
    uint16_t orig_width;
    uint64_t marker_need;

    // These are where the _next_ write will be //
    bit_idx_t class_at, offset_at, marker_at;

    // The most bits needed to store any offset. While offsets are stored
     * in variable number of bits, this is used to estimate how much space
     * to allocate for the whole vector of offsets. We will give back any
     * unused bits. //
    offset_nbits_max = offset_nbits(block_size, block_size / 2);

    // These two vectors are enough to represent the original bit vector. The
     * additional vectors allocated below are the o(n) atop nH₀, and are used
     * for making rank and select operations fast. //
    rrr->classes = bit_vector_alloc_record(rrr->nblocks, nbits(block_size + 1), NULL);
    rrr->offsets = bit_vector_alloc((bit_idx_t)(rrr->nblocks * offset_nbits_max), NULL);

    class_at  = 0;
    offset_at = 0;

    if (rrr->nmarkers > 0) {
        rrr->marked_ranks   = bit_vector_alloc_record(rrr->nmarkers, nbits(bits->size + 1), NULL);
        rrr->marked_offsets = bit_vector_alloc_record(rrr->nmarkers, nbits(rrr->offsets->size), NULL);
    } else {
        rrr->marked_ranks   = NULL;
        rrr->marked_offsets = NULL;
    }

    marker_at   = 0;
    marker_need = marker_size;

    // Read and encode input one block at a time //
    orig_width  = bits->width;
    bits->width = block_size;

    for (bit_idx_t k = 0; k < rrr->nblocks; k ++) {
        uint64_t block, class, offset;
        block  = bit_vector_read_record(bits, k);
        class  = popcount(block);
        offset = rrr_encode_block(block_size, class, block);

        // Write marker if we have enough data. We know there is no more
         * than one marker because block_size <= sblock_nbits //
        int64_t marker_extra = block_size - marker_need;


        if (marker_extra >= 0) {
            // We might need only first few bits from `block` //
            uint64_t want, prefix;
            want   = block_size - marker_extra;
            prefix = (want >= 64) ? block : block & ((1ull << want) - 1);

            bit_vector_write_record(rrr->marked_offsets, marker_at, offset_at);
            bit_vector_write_record(rrr->marked_ranks, marker_at, rrr->rank + popcount(prefix));
            marker_at ++;

            // Next marker counts the bits not used in last marker //
            marker_need = marker_size - marker_extra;
        } else {
            marker_need -= block_size;
        }

        class_at  = bit_vector_write_record(rrr->classes, class_at, class);
        offset_at = bit_vector_write(rrr->offsets, offset_at, offset_nbits(block_size, class), offset);

        rrr->rank += class;
    }

    if (marker_need < marker_size && marker_at < rrr->nmarkers) {
        bit_vector_write_record(rrr->marked_offsets, marker_at, offset_at);
        bit_vector_write_record(rrr->marked_ranks, marker_at, rrr->rank);
    }

    bits->width = orig_width;

    // Truncate unused space //
    bit_vector_resize(rrr->offsets, offset_at);

    return rrr;
    */
}

void
rrr_free(rrr_t* rrr) {
    if (rrr == NULL) return;

    if (rrr->classes) free(rrr->classes);
    if (rrr->offsets) free(rrr->offsets);
    if (rrr->marked_ranks) free(rrr->marked_ranks);
    if (rrr->marked_offsets) free(rrr->marked_offsets);
    free(rrr);
}

#define RRR_PRINT_RECORDS(bits, n) \
    for (bit_idx_t k = 0; k < (n); k ++) { \
        printf("%llu", bit_vector_read_record((bits), k)); \
        if (k + 1 < n) \
            printf(","); \
    }

void
rrr_print(const rrr_t* rrr) {
    if (rrr == NULL) {
        printf("NULL");
        return;
    }

    printf("<rrr size=%u rank=%u t=%u s=%u\n", rrr->size, rrr->rank, rrr->block_size, rrr->marker_size);
    printf("  classes="); RRR_PRINT_RECORDS(rrr->classes, rrr->nblocks); printf("\n");
    printf("  offsets="); bit_vector_print(rrr->offsets); printf("\n");
    printf("  marked_ranks="); RRR_PRINT_RECORDS(rrr->marked_ranks, rrr->nmarkers); printf("\n");
    printf("  marked_offsets="); RRR_PRINT_RECORDS(rrr->marked_offsets, rrr->nmarkers); printf("\n");
}

bit_idx_t
rrr_size(const rrr_t* rrr) {
    return rrr == NULL ? 0 : rrr->size;
}

size_t
rrr_sizeof(const rrr_t* rrr) {
    return sizeof(rrr) + ((rrr_size_bits(rrr) + 7) >> 3);
}

uint64_t
rrr_size_bits(const rrr_t* rrr) {
    return (rrr == NULL ? 0 : 8 * sizeof(*rrr)
            + bit_vector_size_bits(rrr->classes)
            + bit_vector_size_bits(rrr->offsets)
            + bit_vector_size_bits(rrr->marked_ranks)
            + bit_vector_size_bits(rrr->marked_offsets));
}

uint8_t /* access(B, i) = B[i] */
rrr_access(const rrr_t* rrr, bit_idx_t i) {
    assert(rrr != NULL);
    assert(i < rrr->size);

    bit_idx_t marker_at, class_at, offset_at;
    uint64_t class, width, offset, block, i_;

    /* Find nearest marker so we can skip forward in rrr->offsets */
    marker_at = i / rrr->marker_size - 1;

    if (i < rrr->marker_size) {
        class_at  = 0;
        offset_at = 0;
    } else {
        i_        = (marker_at + 1) * rrr->marker_size - 1;
        class_at  = i_ / rrr->block_size;
        offset_at = (bit_idx_t)bit_vector_read_record(rrr->marked_offsets, marker_at);
    }

    /* Move forward one block at a time */
    for ( i -= class_at * rrr->block_size
        ; i >= rrr->block_size
        ; i -= rrr->block_size ) {
        class = bit_vector_read_record(rrr->classes, class_at);
        width = offset_nbits(rrr->block_size, class);
        offset_at += width;
        class_at  ++;
    }

    class  = bit_vector_read_record(rrr->classes, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = RRR_READ_OFFSET(rrr, offset_at, width);
    block  = rrr_decode_block(rrr->block_size, class, offset);

    return (block & (1 << i)) >> i;
}

bit_idx_t /* rank0(B, i) = |{j ∈ [0, i) : B[j] = 0}| */
rrr_rank0(const rrr_t* rrr, bit_idx_t i) {
    return i - rrr_rank1(rrr, i);
}

bit_idx_t /* rank0(B, i) = |{j ∈ [0, i) : B[j] = 1}| */
rrr_rank1(const rrr_t* rrr, bit_idx_t i) {
    assert(rrr != NULL);

    if (i >= rrr->size)
        return rrr->rank;

    int64_t twice, extra, n;
    uint64_t i_, rank, class, width, offset, block, mask;
    bit_idx_t marker_at, class_at, offset_at;

    /* Find nearest sample so we can skip forward in rrr->offsets */
    marker_at = i / rrr->marker_size - 1;

    if (i < rrr->marker_size) {
        rank      = 0;
        offset_at = 0;
        i_        = 0;
        class_at  = 0;
    } else {
        rank      = bit_vector_read_record(rrr->marked_ranks, marker_at);
        offset_at = (bit_idx_t)bit_vector_read_record(rrr->marked_offsets, marker_at);

        /* The last bit index counted within the marker */
        i_        = (marker_at + 1) * rrr->marker_size - 1;
        class_at  = i_ / rrr->block_size;
    }

    /* This first block needs special handling to mask out unwanted bits */
    class  = bit_vector_read_record(rrr->classes, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = RRR_READ_OFFSET(rrr, offset_at, width);
    block  = rrr_decode_block(rrr->block_size, class, offset);

    /* Because the marker may not point to the start of a block, we have to take
     * some care to not double-count the 1s bits before the marker. The term
     * being subtracted is the last bit index in the nearest block. */
    twice = i_ < (class_at * rrr->block_size - 1) ? 0 :
            i_ - (class_at * rrr->block_size - 1);

    /* Lastly we need to ignore these bits that occur past i */
    extra = (class_at + 1) * rrr->block_size < i ? 0 :
            (class_at + 1) * rrr->block_size - i;

    mask  = rrr->block_size - twice - extra;
    mask  = mask < 64 ? (1ull << mask) - 1 : -1;
    mask  = mask << twice;
    rank += popcount(block & mask);

    /* This is how many bits we still need to process. If it's negative, that
     * means we read past i but masked out the extra bits. */
    n = (int)i - (int)(class_at + 1) * rrr->block_size;
    if (n <= 0)
        return rank;

    class_at  ++;
    offset_at += width;

    /* Process one block at a time */
    for ( ; n > rrr->block_size ; n -= rrr->block_size ) {
        class = bit_vector_read_record(rrr->classes, class_at);
        width = offset_nbits(rrr->block_size, class);
        rank += class;
        offset_at += width;
        class_at  ++;
    }

    /* There's one last block, we may need only part of it */
    class  = bit_vector_read_record(rrr->classes, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = RRR_READ_OFFSET(rrr, offset_at, width);
    block  = rrr_decode_block(rrr->block_size, class, offset);

    assert(n > 0);
    mask   = n < 64 ? (1ull << n) - 1 : -1;

    return (uint32_t) (rank + popcount(block & mask));
}

static bit_idx_t
rrr_find_marker0(const rrr_t* rrr, bit_idx_t r) {
    assert(rrr != NULL);
    assert(r <= rrr->rank);

    /* TODO: The key here is to use marked_ranks[k], which counts 1s bits that
     * occur in the first i=(k+1)*rrr->marker_size bits. Since each bit is 0 or
     * 1, we can work out the number of 0s from the number of 1s, which amounts
     * to i - marked_ranks[k].
     */
    return 0ull;
}

/* select0(B, r) = max{j ∈ [0, n) | rank0(j) = r}.
 * NOTE: When there are fewer than r 0-bits, return value will be 0.
 */
bit_idx_t
rrr_select0(const rrr_t* rrr, bit_idx_t r) {
    /* TODO */
    return 0ull;
}

static bit_idx_t
rrr_find_marker1(const rrr_t* rrr, bit_idx_t r) {
    assert(rrr != NULL);
    assert(r <= rrr->rank);

    bit_idx_t lo, hi, _k, k;
    uint64_t rank;

    /* Check if `r` occurs before the start of the first marker */
    if (rrr->marked_ranks == NULL || r < bit_vector_read_record(rrr->marked_ranks, 0))
        return 0;

    for ( lo = 0, hi = rrr->nmarkers - 1, _k = -1; lo <= hi; ) {
        k    = lo + (hi - lo) / 2;
        rank = bit_vector_read_record(rrr->marked_ranks, k);

        if (rank < r)
            lo = (_k = k) + 1;
        else if (r < rank)
            hi = k - 1;
        else
            break;
    }

    if (r <= rank)
        k = _k;

    return k + 1;
}

/* select1(B, r) = max{j ∈ [0, n) | rank1(j) = r}.
 * NOTE: When there are fewer than r 1-bits, return value will be 0.
 */
bit_idx_t
rrr_select1(const rrr_t* rrr, bit_idx_t r) {
    if (r > rrr->rank)
        return 0;

    int16_t i;
    uint64_t class, width, rank, block, offset;
    bit_idx_t class_at, offset_at, marker_at;

    /* Start at marker before rank = r */
    marker_at = rrr_find_marker1(rrr, r);
    class_at  = (marker_at * rrr->marker_size) / rrr->block_size;

    if (marker_at <= 0) {
        rank      = 0;
        offset_at = 0;
    } else {
        rank      = bit_vector_read_record(rrr->marked_ranks, marker_at - 1);
        offset_at = (bit_idx_t)bit_vector_read_record(rrr->marked_offsets, marker_at - 1);
    }

    /* Scan past blocks one at a time */
    for (; class_at < rrr->nblocks; class_at ++) {
        class = bit_vector_read_record(rrr->classes, class_at);
        width = offset_nbits(rrr->block_size, class);

        if (rank + class >= r)
            break;

        rank      += class;
        offset_at += width;
    }

    /* The r-th 1-bit occurs within this block */
    offset = RRR_READ_OFFSET(rrr, offset_at, width);
    block  = rrr_decode_block(rrr->block_size, class, offset);

    assert(r - rank <= popcount(block));

    /* Need to locate the (r - rank)-th 1-bit of block */
    for (i = -1; rank < r; rank ++) {
        i      = ctz(block);
        block &= ~(1ull << i);
    }

    return 1 + i + class_at * rrr->block_size;
}

/* Number of 1-bits */
static inline uint8_t
popcount(uint64_t x) {
    return __builtin_popcountll(x);
    /*
    register uint64_t v = x - ((x & 0xaaaaaaaaaaaaaaaa) >> 1);
    v = (v & 0x3333333333333333) + ((v >> 2) & 0x3333333333333333);
    v = (v + (v >> 4)) & 0x0f0f0f0f0f0f0f0f;
    return v * 0x0101010101010101 >> 56;
    */
}

/* Count leading zeros */
static inline uint8_t
clz(uint64_t x) {
    return __builtin_clzll(x);
}

/* Count trailing zeros */
static inline uint8_t
ctz(uint64_t x) {
    return __builtin_ctzll(x);
    /* (x == 0) ? 64 : 63 - clz((x ^ -x)); */
}

/* Minimum number of bits needed to represent x */
static inline uint8_t
nbits(uint64_t x) {
    return (x < 2) ? 0 : 64 - clz(x - 1);
}

static inline uint8_t
offset_nbits(uint64_t block_size, uint64_t class) {
    return nbits(binomial[block_size][class]);
}

static void
rrr_precompute_binomials(void) {
    if (binomial == NULL) {
        binomial = malloc(sizeof(uint64_t*) * (RRR_BLOCK_SIZE_MAX + 1));
        assert(binomial != NULL);

        /* (n choose k) = binomial[n][k] */
        for (uint8_t n = 0; n <= RRR_BLOCK_SIZE_MAX; n ++) {
            binomial[n] = malloc(sizeof(uint64_t) * (n + 1));
            assert(binomial[n] != NULL);

            binomial[n][0] = 1;
            binomial[n][n] = 1;

            for (uint8_t k = 1; k < n; k ++)
                binomial[n][k] = binomial[n - 1][k - 1] + binomial[n - 1][k];
        }
    }
}

static inline uint64_t
rrr_encode_block(uint64_t block_size, uint64_t class, uint64_t value) {
    assert(block_size > 0);
    assert(binomial != NULL);
    assert(class <= block_size);
    assert(class == popcount(value));

    if (class == 0 || class == block_size)
        return 0;

    /* When block_size is 5, here are all elements of class 2 next to their
     * offset:
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

    uint64_t offset = 0; /* Minimum offset so far */
    uint64_t n;         /* Which bit we're inspecting */

    /* Immediately skip leading zeros to the most significant 1-bit */
    n = (value == 0) ? 0 : 63 - clz(value);

    for (; class > 0 && n >= class; n --) {
        if (value & (1ull << n)) {
            offset += binomial[n][class];
            class  --;
        }
    };

    return offset;
}

static inline uint64_t
rrr_decode_block(uint64_t block_size, uint64_t class, uint64_t offset) {
    assert(block_size > 0);
    assert(binomial != NULL);
    assert(class <= block_size);
    assert(offset < binomial[block_size][class]);

    /* When block_size is 5, here are the elements of class 2 with their offset:
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
    uint64_t n = block_size - 1; /* Which bit we're generating */

    for (; class <= n && n > 0; n --) {
        uint64_t before = binomial[n][class];

        if (before <= offset) {
            value  |= (1ull << n);
            offset -= before;
            class  --;
        }
    }

    if (class > 0)
        value |= (1ull << class) - 1;

    return value;
}
