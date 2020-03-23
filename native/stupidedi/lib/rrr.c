#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitmap.h"
#include "stupidedi/include/builtins.h"

/* (b choose r) = binomial[b][r] */
static uint64_t **binomial = NULL;

/* Helper functions are defined at the end of the file */
static void precompute_binomials(void);
static inline uint8_t offset_nbits(uint64_t, uint64_t);
static inline uint64_t encode_block(uint8_t, uint8_t, uint64_t);
static inline uint64_t decode_block(uint8_t, uint8_t, uint64_t);
static inline stupidedi_bit_idx_t class_bit_idx(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static inline stupidedi_bit_idx_t marker_bit_idx(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static inline stupidedi_bit_idx_t read_class(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static inline stupidedi_bit_idx_t read_offset(const stupidedi_rrr_t*, stupidedi_bit_idx_t, uint8_t);
static inline stupidedi_bit_idx_t read_marked_rank0(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static inline stupidedi_bit_idx_t read_marked_rank1(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static inline stupidedi_bit_idx_t read_marked_offset(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static stupidedi_bit_idx_t stupidedi_rrr_find_marker0(const stupidedi_rrr_t*, stupidedi_bit_idx_t);
static stupidedi_bit_idx_t stupidedi_rrr_find_marker1(const stupidedi_rrr_t*, stupidedi_bit_idx_t);

/* TODO */
stupidedi_rrr_builder_t*
stupidedi_rrr_builder_alloc(uint8_t block_size, uint16_t marker_size, stupidedi_bit_idx_t size, stupidedi_rrr_builder_t* builder, stupidedi_rrr_t* rrr)
{
    assert(size > 0);
    assert(block_size >= STUPIDEDI_RRR_BLOCK_SIZE_MIN);
    assert(block_size <= STUPIDEDI_RRR_BLOCK_SIZE_MAX);
    assert(block_size <= marker_size);
    assert(marker_size >= STUPIDEDI_RRR_MARKER_SIZE_MIN);
    assert(marker_size <= STUPIDEDI_RRR_MARKER_SIZE_MAX);

    /* One-time initialization of global variables */
    precompute_binomials();

    if (builder == NULL)
        builder = malloc(sizeof(stupidedi_rrr_builder_t));
    assert(builder != NULL);

    if (rrr == NULL)
        rrr = malloc(sizeof(stupidedi_rrr_t));

    builder->rrr = rrr;
    assert(rrr != NULL);

    rrr->size         = size;
    rrr->rank         = STUPIDEDI_BIT_IDX_C(0);
    rrr->nblocks      = (size + block_size - 1) / block_size;
    rrr->nmarkers     = (size + marker_size - 1) / marker_size - 1;
    rrr->block_size   = block_size;
    rrr->marker_size  = marker_size;

    builder->offset_nbits_max = offset_nbits(block_size, block_size / 2);
    builder->block       = UINT64_C(0);
    builder->written     = STUPIDEDI_BIT_IDX_C(0);
    builder->class_at    = STUPIDEDI_BIT_IDX_C(0);
    builder->offset_at   = STUPIDEDI_BIT_IDX_C(0);
    builder->marker_at   = STUPIDEDI_BIT_IDX_C(0);
    builder->marker_need = marker_size;
    builder->block_need  = block_size;

    /* These two vectors are sufficient to encode the original bit vector. The
     * additional vectors allocated below are the o(n) atop nH₀, and are used
     * for making rank and select operations fast. */
    rrr->classes = stupidedi_bitmap_alloc_record(rrr->nblocks, nbits(block_size + 1), NULL);
    rrr->offsets = stupidedi_bitmap_alloc((uint32_t)(rrr->nblocks * builder->offset_nbits_max), NULL);

    if (rrr->nmarkers > STUPIDEDI_BIT_IDX_C(0))
    {
        rrr->marked_ranks   = stupidedi_bitmap_alloc_record(rrr->nmarkers, nbits(size + 1), NULL);
        rrr->marked_offsets = stupidedi_bitmap_alloc_record(rrr->nmarkers, nbits(rrr->offsets->size), NULL);
    }
    else
    {
        rrr->marked_ranks   = NULL;
        rrr->marked_offsets = NULL;
    }

    return builder;
}

/* TODO */
void
stupidedi_rrr_builder_append(stupidedi_rrr_builder_t* builder, uint8_t width, uint64_t value)
{
    assert(builder != NULL);
    assert(builder->rrr != NULL);
    assert(width <= STUPIDEDI_RRR_BLOCK_SIZE_MAX);
    assert(value <= (width < 64 ? (UINT64_C(1) << width) - 1 : UINT64_MAX));

    stupidedi_rrr_t* rrr;
    rrr = builder->rrr;

    uint64_t block, mask, uncommitted;
    uncommitted = rrr->block_size - builder->block_need;
    assert(builder->written + uncommitted + width <= rrr->size);

    while (builder->block_need <= width)
    {
        /* Select only bits needed to finish filling this block, then append to
         * the end of the current block*/
        mask   = (UINT64_C(1) << builder->block_need) - 1;
        block  = builder->block;
        block |= (value & mask) << (rrr->block_size - builder->block_need);

        /* Discard the used bits */
        value  = value >> builder->block_need;
        width -= builder->block_need;

        uint64_t class, offset;
        class  = popcount(block);
        offset = encode_block(rrr->block_size, class, block);

        /* Write marker if we have enough data. We know there is no more
         * than one marker because block_size <= sblock_nbits */
        int16_t marker_extra = rrr->block_size - builder->marker_need;

        if (marker_extra >= 0)
        {
            /* We might need only first few bits from the current `block` */
            uint64_t want, prefix;
            want   = rrr->block_size - marker_extra;
            prefix = want >= 64 ? block : block & ((UINT64_C(1) << want) - 1);

            stupidedi_bitmap_write_record(rrr->marked_ranks,   builder->marker_at, rrr->rank + popcount(prefix));
            stupidedi_bitmap_write_record(rrr->marked_offsets, builder->marker_at, builder->offset_at);
            ++builder->marker_at;

            /* Next marker counts the bits not used in last marker */
            builder->marker_need = rrr->marker_size - marker_extra;
        }
        else
        {
            builder->marker_need -= rrr->block_size;
        }

        builder->class_at  = stupidedi_bitmap_write_record(rrr->classes, builder->class_at, class);
        builder->offset_at = stupidedi_bitmap_write(rrr->offsets, builder->offset_at, offset_nbits(rrr->block_size, class), offset);
        builder->written  += rrr->block_size;

        /* Next time we'll need a full block */
        builder->block      = UINT64_C(0);
        builder->block_need = rrr->block_size;

        rrr->rank += class;
    }

    /* Remaining value is guaranteed to be shorter than block_need */
    mask   = (UINT64_C(1) << builder->block_need) - 1;
    block  = builder->block;
    block |= (value & mask) << (rrr->block_size - builder->block_need);
    builder->block = block;
    builder->block_need -= width;
}

/* Number of bits already written */
stupidedi_bit_idx_t
stupidedi_rrr_builder_written(const stupidedi_rrr_builder_t* builder)
{
    assert(builder != NULL);
    assert(builder->rrr != NULL);

    stupidedi_rrr_t* rrr;
    rrr = builder->rrr;

    uint8_t uncommitted;
    uncommitted = rrr->block_size - builder->block_need;

    return (stupidedi_bit_idx_t)uncommitted + builder->written;
}

/* TODO */
stupidedi_rrr_t*
stupidedi_rrr_builder_build(stupidedi_rrr_builder_t* builder)
{
    assert(builder != NULL);
    assert(builder->rrr != NULL);

    stupidedi_rrr_t* rrr;
    rrr = builder->rrr;

    uint8_t uncommitted;
    uncommitted = rrr->block_size - builder->block_need;
    assert(builder->written + (stupidedi_bit_idx_t)uncommitted == rrr->size);

    if (/*builder->marker_need < rrr->marker_size &&*/ builder->marker_at < rrr->nmarkers)
    {
        /* Last marker wasn't written yet because of EOF. We may only need some
         * of the bits that haven't yet been written. */
        uint64_t mask, marked_rank;
        mask        = (UINT64_C(1) << builder->marker_need) - 1;
        marked_rank = rrr->rank + popcount(builder->block & mask);

        stupidedi_bitmap_write_record(rrr->marked_ranks,   builder->marker_at, marked_rank);
        stupidedi_bitmap_write_record(rrr->marked_offsets, builder->marker_at, builder->offset_at);
    }

    if (uncommitted > 0)
    {
        /* Haven't yet written the last block */
        uint64_t class, offset;
        class  = popcount(builder->block);
        offset = encode_block(rrr->block_size, class, builder->block);
        rrr->rank += class;

        builder->class_at  = stupidedi_bitmap_write_record(rrr->classes, builder->class_at, class);
        builder->offset_at = stupidedi_bitmap_write(rrr->offsets, builder->offset_at, offset_nbits(rrr->block_size, class), offset);
    }

    /* Truncate unused space */
    stupidedi_bitmap_resize(rrr->offsets, builder->offset_at);
    return rrr;
}

/* TODO */
void
stupidedi_rrr_builder_free(stupidedi_rrr_builder_t* builder)
{
    if (builder != NULL) free(builder);
}

/* TODO */
uint32_t
stupidedi_rrr_builder_size(const stupidedi_rrr_builder_t* builder)
{
    return builder == NULL || builder->rrr == NULL ? 0 :
        builder->rrr->size;
}

/* TODO */
size_t
stupidedi_rrr_builder_sizeof(const stupidedi_rrr_builder_t* builder)
{
    return builder == NULL ? 0 :
        sizeof(*builder) + stupidedi_rrr_sizeof(builder->rrr);
}

/* TODO */
uint64_t
stupidedi_rrr_builder_size_bits(const stupidedi_rrr_builder_t* builder)
{
    return builder == NULL ? 0 :
        8 * sizeof(*builder) + stupidedi_rrr_sizeof_bits(builder->rrr);
}

/* TODO */
stupidedi_rrr_t*
stupidedi_rrr_alloc(const stupidedi_bitmap_t* bits, uint8_t block_size, uint16_t marker_size, stupidedi_rrr_t* rrr)
{
    stupidedi_rrr_builder_t builder;
    stupidedi_rrr_builder_alloc(block_size, marker_size, bits->size, &builder, rrr);

    /* This counts full blocks, but may exclude the last block if it's partial */
    uint32_t nblocks;
    nblocks = bits->size / STUPIDEDI_RRR_BLOCK_SIZE_MAX;

    for (uint32_t k = 0; k < nblocks; ++k)
        stupidedi_rrr_builder_append(&builder, STUPIDEDI_RRR_BLOCK_SIZE_MAX,
                stupidedi_bitmap_read(bits, k * STUPIDEDI_RRR_BLOCK_SIZE_MAX, STUPIDEDI_RRR_BLOCK_SIZE_MAX));

    /* The last block could be smaller than a full block, so we handle it separately */
    uint8_t remainder;
    remainder = bits->size - (nblocks * STUPIDEDI_RRR_BLOCK_SIZE_MAX);

    if (remainder > 0)
        stupidedi_rrr_builder_append(&builder, remainder,
                stupidedi_bitmap_read(bits, nblocks * STUPIDEDI_RRR_BLOCK_SIZE_MAX, remainder));

    return stupidedi_rrr_builder_build(&builder);
}

/* TODO */
void
stupidedi_rrr_free(stupidedi_rrr_t* rrr)
{
    if (rrr == NULL) return;
    if (rrr->classes) free(rrr->classes);
    if (rrr->offsets) free(rrr->offsets);
    if (rrr->marked_ranks) free(rrr->marked_ranks);
    if (rrr->marked_offsets) free(rrr->marked_offsets);
    free(rrr);
}

/* TODO */
char*
stupidedi_rrr_to_string(const stupidedi_rrr_t* rrr)
{
    if (rrr == NULL)
        return strdup("NULL");

    char *s, *offsets, *classes, *marked_ranks, *marked_offsets;
    offsets         = stupidedi_bitmap_to_string(rrr->offsets);
    classes         = stupidedi_bitmap_to_string_record(rrr->classes);
    marked_ranks    = stupidedi_bitmap_to_string_record(rrr->marked_ranks);
    marked_offsets  = stupidedi_bitmap_to_string_record(rrr->marked_offsets);

    asprintf(&s, "size=%u rank=%u block_size=%u nblocks=%u marker_size=%u nmarkers=%u "
            "offsets=%s classes=%s marked_ranks=%s marked_offsets=%s",
            rrr->size,
            rrr->rank,
            rrr->block_size,
            rrr->nblocks,
            rrr->marker_size,
            rrr->nmarkers,
            offsets,
            classes,
            marked_ranks,
            marked_offsets);

    free(offsets);
    free(classes);
    free(marked_ranks);
    free(marked_offsets);

    return s;
}

/* Decodes entire RRR vector. */
stupidedi_bitmap_t*
stupidedi_rrr_to_bitmap(const stupidedi_rrr_t* rrr)
{
    if (rrr == NULL)
        return NULL;

    stupidedi_bitmap_t* bits;
    bits = stupidedi_bitmap_alloc(rrr->size, NULL);

    for (stupidedi_bit_idx_t offset_at = 0, class_at = 0; class_at < rrr->nblocks; ++class_at)
    {
        uint64_t block, class, offset;
        class  = read_class(rrr, class_at);

        uint8_t width;
        width  = offset_nbits(rrr->block_size, class);

        offset = read_offset(rrr, offset_at, width);
        block  = decode_block(rrr->block_size, class, offset);
        offset_at += width;

        /* Careful not to write past the end of the bitmap on the last (partial) block */
        stupidedi_bitmap_write(bits, class_at*rrr->block_size, class_at < rrr->nblocks - 1 ?
                rrr->block_size : rrr->size - class_at*rrr->block_size, block);
    }

    bits->width = 0;

    return bits;
}

/* Number of bits the RRR vector represents */
uint32_t
stupidedi_rrr_size(const stupidedi_rrr_t* rrr)
{
    return rrr == NULL ? 0 : rrr->size;
}

/* Number of bytes occupied in memory, not counting the pointer itself */
size_t
stupidedi_rrr_sizeof(const stupidedi_rrr_t* rrr)
{
    return rrr == NULL ? 0 :
        sizeof(*rrr) + ((stupidedi_rrr_sizeof_bits(rrr) + 7) >> 3);
}

/* Number of bits occupied in memory not counting the pointer itself */
uint64_t
stupidedi_rrr_sizeof_bits(const stupidedi_rrr_t* rrr)
{
    return rrr == NULL ? 0 :
        8 * sizeof(*rrr)
        + stupidedi_bitmap_sizeof_bits(rrr->classes)
        + stupidedi_bitmap_sizeof_bits(rrr->offsets)
        + stupidedi_bitmap_sizeof_bits(rrr->marked_ranks)
        + stupidedi_bitmap_sizeof_bits(rrr->marked_offsets);
}

/* The i-th bit (using zero-based indexing)
 *
 * access(B, i) = B[i] */
uint8_t
stupidedi_rrr_access(const stupidedi_rrr_t* rrr, uint32_t i)
{
    assert(rrr != NULL);
    assert(i < rrr->size);

    stupidedi_bit_idx_t marker_at, class_at, offset_at, i_;
    uint64_t class, width, offset, block;

    /* Find nearest marker so we can skip forward in rrr->offsets */
    marker_at = i / rrr->marker_size - 1;

    if (i < rrr->marker_size)
    {
        class_at  = 0;
        offset_at = 0;
    }
    else
    {
        i_        = marker_bit_idx(rrr, marker_at) - 1;
        class_at  = i_ / rrr->block_size;
        offset_at = read_marked_offset(rrr, marker_at);
    }

    /* Move forward one block at a time */
    for ( i -= class_at * rrr->block_size
        ; i >= rrr->block_size
        ; i -= rrr->block_size )
    {
        class = read_class(rrr, class_at);
        width = offset_nbits(rrr->block_size, class);
        offset_at += width;
        ++class_at;
    }

    class  = read_class(rrr, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = read_offset(rrr, offset_at, width);
    block  = decode_block(rrr->block_size, class, offset);

    return (block & (1 << i)) >> i;
}

/* Number of 0s bits in the i-bit prefix of B
 *
 * rank0(B, i) = |{j ∈ [0..i) : B[j] = 0}| */
stupidedi_bit_idx_t
stupidedi_rrr_rank0(const stupidedi_rrr_t* rrr, uint32_t i)
{
    return (i < rrr->size ? i + 1 : rrr->size) - stupidedi_rrr_rank1(rrr, i);
}

/* Number of 1s bits up to and including position i
 *
 * rank1(B, i) = |{j ∈ [0..i] : B[j] = 1}| */
stupidedi_bit_idx_t
stupidedi_rrr_rank1(const stupidedi_rrr_t* rrr, uint32_t i)
{
    assert(rrr != NULL);

    if (i + 1 >= rrr->size)
        return rrr->rank;

    stupidedi_bit_idx_t i_, rank, marker_at, class_at, offset_at;
    uint64_t class, width, offset, block, mask;
    int64_t twice, extra, n;

    if (i < rrr->marker_size)
    {
        rank      = 0;
        offset_at = 0;
        i_        = 0;
        class_at  = 0;
        twice     = 0;
    }
    else
    {
        /* Find nearest sample so we can skip forward in rrr->offsets */
        marker_at = (i + 1) / rrr->marker_size - 1;

        rank      = read_marked_rank1(rrr, marker_at);
        offset_at = read_marked_offset(rrr, marker_at);

        /* The last bit position counted within the marker */
        i_        = marker_bit_idx(rrr, marker_at) - 1;
        class_at  = i_ / rrr->block_size;

        /* Because the marker may not point to the start of a block, we have to take
         * some care to not double-count the 1s bits before the marker. The term
         * being subtracted is the last bit index in the nearest block. */
        twice = i_ < class_bit_idx(rrr, class_at) ? 0 :
                i_ - class_bit_idx(rrr, class_at) + 1;
    }

    /* This first block needs special handling to mask out bits that were
     * already counted by the nearest marker. */
    class  = read_class(rrr, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = read_offset(rrr, offset_at, width);
    block  = decode_block(rrr->block_size, class, offset);

    /* Lastly we need to ignore these bits that occur past i */
    extra = class_bit_idx(rrr, class_at + 1) < (i + 1) ? 0 :
            class_bit_idx(rrr, class_at + 1) - (i + 1);

    assert(twice + extra <= rrr->block_size);

    mask  = rrr->block_size - twice - extra;
    mask  = mask < 64 ? (UINT64_C(1) << mask) - 1 : UINT64_MAX;
    mask  = mask << twice;
    rank += popcount(block & mask);

    /* This is how many bits we still need to process. If it's negative, that
     * means the block ended after i (we masked out the extra bits). */
    if (i + 1 <= class_bit_idx(rrr, class_at + 1))
        return rank;

    ++class_at;
    offset_at += width;

    /* Process one block at a time */
    for ( n = (int64_t)(i + 1) - (int64_t)class_bit_idx(rrr, class_at)
        ; n > rrr->block_size
        ; n -= rrr->block_size )
    {
        class = read_class(rrr, class_at);
        width = offset_nbits(rrr->block_size, class);
        rank += class;
        offset_at += width;
        ++class_at;
    }

    /* There's one last block, we may need only part of it */
    class  = read_class(rrr, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = read_offset(rrr, offset_at, width);
    block  = decode_block(rrr->block_size, class, offset);

    assert(n > 0);
    mask   = n < 64 ? (UINT64_C(1) << n) - 1 : UINT64_MAX;

    return (stupidedi_bit_idx_t) (rank + popcount(block & mask));
}

/* Position of the j-th 0-bit in B (using zero-based indexing), or 0 when j
 * exceeds the number of 0s bits in B
 *
 * select0(B, j) = min{i ∈ [0..n] | rank0(i) = j} */
stupidedi_bit_idx_t
stupidedi_rrr_select0(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t r)
{
    if (r == 0 || r > rrr->size - rrr->rank)
        return 0;

    uint8_t twice;
    int16_t i;
    uint64_t class, width, block, offset;
    stupidedi_bit_idx_t marker_i, rank, class_at, offset_at, marker_at;

    /* Start at marker before rank₀ = r */
    marker_at = stupidedi_rrr_find_marker0(rrr, r);

    if (marker_at <= 0)
    {
        rank      = 0;
        offset_at = 0;
        marker_i  = 0; /* Index of first bit not counted by this marker */
        class_at  = 0;
        twice     = 0;
    }
    else
    {
        rank      = read_marked_rank0(rrr, marker_at - 1);
        offset_at = read_marked_offset(rrr, marker_at - 1);

        /* Index of first bit not counted by this marker */
        marker_i = marker_bit_idx(rrr, marker_at - 1);

        /* Block index containing the last bit counted by the marker */
        class_at = (marker_i - 1) / rrr->block_size;

        /* Index of first bit after that block */
        stupidedi_bit_idx_t class_i;
        class_i  = class_bit_idx(rrr, class_at + 1);

        /* Number of lower bits that have already been counted by the marker. */
        twice = rrr->block_size - (class_i - marker_i);
    }

    /* The first block requires special care because the marker already counts
     * at least some of the bits, but maybe not all of them. */
    class  = read_class(rrr, class_at);
    width  = offset_nbits(rrr->block_size, class);
    offset = read_offset(rrr, offset_at, width);

    if (r - rank <= rrr->block_size - twice)
    {
        /* The r-th 0-bit occurs somewhere before the next block.
         *
         * Note this swaps 0s and 1s, so CTZ can be used to skip over 0-bits that
         * used to be 1-bits, and POPCNT can count 1-bits that used to be 0-bits. */
        block  = ~decode_block(rrr->block_size, class, offset);
        block &= UINT64_C(-1) << twice;

        for (i = -1, block = block >> twice; rank < r; ++rank)
        {
            i      = ctz(block);
            block &= ~(UINT64_C(1) << i);
        }

        return marker_i + i;
    }
    else
    {
        /* Just go ahead and count all the unread 0-bits */
        block = decode_block(rrr->block_size, class, offset);
        block = block >> twice;

        rank      += (rrr->block_size - twice) - popcount(block);
        offset_at += width;
        ++ class_at;
    }

    /* Scan past blocks one at a time */
    for (; class_at < rrr->nblocks; ++class_at)
    {
        class = read_class(rrr, class_at);
        width = offset_nbits(rrr->block_size, class);

        if (rank + (rrr->block_size - class) >= r)
            break;

        rank      += rrr->block_size - class;
        offset_at += width;
    }

    /* The r-th 0-bit occurs within this block */
    offset = read_offset(rrr, offset_at, width);
    block  = decode_block(rrr->block_size, class, offset);

    assert(r - rank <= rrr->block_size - popcount(block));

    /* There's not a fast way to count trailing zeros, but we can flip all the
     * bits and use CTZ to count trailing zeros. */
    block = ~block;

    int16_t n;

    /* Need to locate the (r - rank₀)-th 1-bit of block */
    for (n = -1; rank < r; ++rank)
    {
        n      = ctz(block);
        block &= ~(1ull << n);
    }

    return n + class_at * rrr->block_size;
}

/* Position of the r-th 1-bit in B (using zero-based indexing), or 0 when j
 * exceeds the number of 1s bits in B
 *
 * select1(B, j) = min{i ∈ [0..n) | rank1(i) = j} */
uint32_t
stupidedi_rrr_select1(const stupidedi_rrr_t* rrr, uint32_t r)
{
    if (r > rrr->rank)
        return 0;

    int16_t i;
    uint64_t class, width, rank, block, offset;
    uint32_t class_at, offset_at, marker_at;

    /* Start at marker before rank₁ = r */
    marker_at = stupidedi_rrr_find_marker1(rrr, r);
    class_at  = (marker_at * rrr->marker_size) / rrr->block_size;

    if (marker_at <= 0)
    {
        rank      = 0;
        offset_at = 0;
    }
    else
    {
        rank      = stupidedi_bitmap_read_record(rrr->marked_ranks, marker_at - 1);
        offset_at = (uint32_t)stupidedi_bitmap_read_record(rrr->marked_offsets, marker_at - 1);
    }

    /* Scan past blocks one at a time */
    for (; class_at < rrr->nblocks; ++class_at)
    {
        class = read_class(rrr, class_at);
        width = offset_nbits(rrr->block_size, class);

        if (rank + class >= r)
            break;

        rank      += class;
        offset_at += width;
    }

    /* The r-th 1-bit occurs within this block */
    offset = read_offset(rrr, offset_at, width);
    block  = decode_block(rrr->block_size, class, offset);

    assert(r - rank <= popcount(block));

    /* Need to locate the (r - rank₁)-th 1-bit of block */
    for (i = 0; rank < r; ++rank)
    {
        i      = ctz(block);
        block &= ~(1ull << i);
    }

    return i + class_at * rrr->block_size;
}

/* Position of nearest the 0-bit before position i */
uint32_t
stupidedi_rrr_prev0(const stupidedi_rrr_t* rrr, uint32_t i)
{
    return 0; /* TODO */
}

/* Position of the nearest 1-bit before position i */
uint32_t
stupidedi_rrr_prev1(const stupidedi_rrr_t* rrr, uint32_t i)
{
    return 0; /* TODO */
}

/* Position of the nearest 0-bit after position i */
uint32_t
stupidedi_rrr_next0(const stupidedi_rrr_t* rrr, uint32_t i)
{
    return 0; /* TODO */
}

/* Position of the nearest 1-bit after position i */
uint32_t
stupidedi_rrr_next1(const stupidedi_rrr_t* rrr, uint32_t i)
{
    return 0; /* TODO */
}

/*****************************************************************************/

/* Number of bits required to represent block_size bits with class 1s bits */
static inline uint8_t
offset_nbits(uint64_t block_size, uint64_t class)
{
    return nbits(binomial[block_size][class]);
}

static void
precompute_binomials(void)
{
    if (binomial == NULL)
    {
        binomial = malloc(sizeof(uint64_t*) * (STUPIDEDI_RRR_BLOCK_SIZE_MAX + 1));
        assert(binomial != NULL);

        /* (n choose k) = binomial[n][k] */
        for (uint8_t n = 0; n <= STUPIDEDI_RRR_BLOCK_SIZE_MAX; ++n)
        {
            binomial[n] = malloc(sizeof(uint64_t) * (n + 1));
            assert(binomial[n] != NULL);

            binomial[n][0] = 1;
            binomial[n][n] = 1;

            for (uint8_t k = 1; k < n; ++k)
                binomial[n][k] = binomial[n - 1][k - 1] + binomial[n - 1][k];
        }
    }
}

static uint64_t
encode_block(uint8_t block_size, uint8_t class, uint64_t value)
{
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
    uint64_t n;          /* Which bit we're inspecting */

    /* Immediately skip leading zeros to the most significant 1-bit */
    n = (value == 0) ? 0 : 63 - clz(value);

    for (; class > 0 && n >= class; n --)
    {
        if (value & (1ull << n))
        {
            offset += binomial[n][class];
            class  --;
        }
    };

    return offset;
}

static uint64_t
decode_block(uint8_t block_size, uint8_t class, uint64_t offset)
{
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
    uint64_t n     = block_size - 1; /* Which bit we're generating */

    for (; class <= n && n > 0; n --)
    {
        uint64_t before = binomial[n][class];

        if (before <= offset)
        {
            value  |= (1ull << n);
            offset -= before;
            class  --;
        }
    }

    if (class > 0)
        value |= (1ull << class) - 1;

    return value;
}

/* Returns the bit index where the given class begins. */
static inline stupidedi_bit_idx_t
class_bit_idx(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t k)
{
    return k * rrr->block_size;
}

/* Returns the length of the prefix counted by the marker. */
static inline stupidedi_bit_idx_t
marker_bit_idx(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t k)
{
    return (k + 1) * rrr->marker_size;
}

static inline stupidedi_bit_idx_t
read_class(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t class_at)
{
    return (stupidedi_bit_idx_t)stupidedi_bitmap_read_record(rrr->classes, class_at);
}

static inline stupidedi_bit_idx_t
read_offset(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t offset_at, uint8_t width)
{
    return rrr->offsets == NULL || rrr->offsets->size == 0 ?
        0 : (stupidedi_bit_idx_t)stupidedi_bitmap_read(rrr->offsets, offset_at, width);
}

static inline stupidedi_bit_idx_t
read_marked_rank0(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t marker_at)
{
    return marker_bit_idx(rrr, marker_at) - read_marked_rank1(rrr, marker_at);
}

static inline stupidedi_bit_idx_t
read_marked_rank1(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t marker_at)
{
    return (stupidedi_bit_idx_t)stupidedi_bitmap_read_record(rrr->marked_ranks, marker_at);
}

static inline stupidedi_bit_idx_t
read_marked_offset(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t marker_at)
{
    return (stupidedi_bit_idx_t)stupidedi_bitmap_read_record(rrr->marked_offsets, marker_at);
}
/* Helper function that returns 1 + the position of the nearest marker before
 * the r-th 0-bit. Returns 0 when the r-th 0-bit occurs before the first marker. */
static stupidedi_bit_idx_t
stupidedi_rrr_find_marker0(const stupidedi_rrr_t* rrr, stupidedi_bit_idx_t r)
{
    assert(rrr != NULL);
    assert(r <= rrr->size - rrr->rank);

    /* The key here is to use marked_ranks[k], which counts 1s bits that occur
     * in the first i=(k+1)*rrr->marker_size bits. Since each bit is 0 or 1, we
     * can work out the number of 0s from the number of 1s.
     */

    if (rrr->nmarkers == 0)
        return STUPIDEDI_BIT_IDX_C(0);

    stupidedi_bit_idx_t lo, hi, save, k, r_;
    lo = 0;
    hi = rrr->nmarkers - 1;
    save = -1;

    do {
        k  = lo + (hi - lo) / 2;
        r_ = read_marked_rank0(rrr, k);

        if (r_ < r)
            lo = (save = k) + 1;
        else
            hi = k - 1;

    } while (0 < k && lo <= hi);

    if (r <= r_)
        k = save;

    return k + 1;
}

/* Helper function that returns 1 + the position of the nearest marker before
 * the r-th 1-bit. Returns 0 when the r-th 1-bit occurs before the first marker. */
static stupidedi_bit_idx_t
stupidedi_rrr_find_marker1(const stupidedi_rrr_t* rrr, uint32_t r)
{
    assert(rrr != NULL);
    assert(r <= rrr->rank);

    if (rrr->nmarkers == 0)
        return STUPIDEDI_BIT_IDX_C(0);

    stupidedi_bit_idx_t lo, hi, save, k, r_;
    lo = 0;
    hi = rrr->nmarkers - 1;
    save = -1;

    do
    {
        k  = lo + (hi - lo) / 2;
        r_ = stupidedi_bitmap_read_record(rrr->marked_ranks, k);

        if (r_ < r)
            lo = (save = k) + 1;
        else
            hi = k - 1;

    } while (0 < k && lo <= hi);

    if (r <= r_)
        k = save;

    return k + 1;
}

