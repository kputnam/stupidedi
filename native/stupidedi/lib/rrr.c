#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/packed.h"
#include "stupidedi/include/builtins.h"

typedef struct stupidedi_rrr_t
{
    /* Total number of bits in input */
    size_t length;

    /* Number of 1-bits in input */
    size_t rank;

    /* Number of input bits per block */
    uint8_t block_size;
    size_t nblocks;

    /* classes[k] is number of 1s bits in kth block. */
    stupidedi_packed_t* classes;

    /* Variable width, offsets[k] points to one of the values with classes[k] 1s bits. */
    stupidedi_bitstr_t* offsets;

    /* Number of input bits per marker */
    uint16_t marker_size;
    size_t nmarkers;

    /* Each marker counts how many 1-bits occured in the first (1+k)*marker_size bits. */
    stupidedi_packed_t* marked_ranks;

    /* Points to the offset for the block with the (1+k)*marker_size-1 th bit. */
    stupidedi_packed_t* marked_offsets;
} stupidedi_rrr_t;

static uint64_t **binomial = NULL;

static          void        precompute_binomials(void);
static inline   uint8_t     offset_nbits(uint64_t block_size, uint64_t class);
static          uint64_t    encode_block(uint8_t block_size, uint8_t class, uint64_t value);
static inline   uint64_t    decode_block(uint8_t, uint8_t, uint64_t);
static inline   size_t      class_bit_idx(const stupidedi_rrr_t*, size_t);
static inline   size_t      marker_bit_idx(const stupidedi_rrr_t*, size_t);
static inline   size_t      read_class(const stupidedi_rrr_t*, size_t);
static inline   size_t      read_offset(const stupidedi_rrr_t*, size_t, uint8_t);
static inline   size_t      read_marked_rank0(const stupidedi_rrr_t*, size_t);
static inline   size_t      read_marked_rank1(const stupidedi_rrr_t*, size_t);
static inline   size_t      read_marked_offset(const stupidedi_rrr_t*, size_t);
static          size_t      stupidedi_rrr_find_marker0(const stupidedi_rrr_t*, size_t);
static          size_t      stupidedi_rrr_find_marker1(const stupidedi_rrr_t*, size_t);

/*****************************************************************************/

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_alloc(void)
{
    return malloc(sizeof(stupidedi_rrr_builder_t));
}

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_dealloc(stupidedi_rrr_builder_t* rrrb)
{
    if (rrrb != NULL)
        free(stupidedi_rrr_builder_deinit(rrrb));

    return NULL;
}

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_new(uint8_t block_size, uint16_t marker_size, size_t length)
{
    return stupidedi_rrr_builder_init(stupidedi_rrr_builder_alloc(), block_size, marker_size, length);
}

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_init(stupidedi_rrr_builder_t* rrrb, uint8_t block_size, uint16_t marker_size, size_t length)
{
    assert(rrrb != NULL);
    assert(length > 0);
    assert(block_size >= STUPIDEDI_RRR_BLOCK_SIZE_MIN);
    assert(block_size <= STUPIDEDI_RRR_BLOCK_SIZE_MAX);
    assert(block_size <= marker_size);
    assert(marker_size >= STUPIDEDI_RRR_MARKER_SIZE_MIN);
    assert(marker_size <= STUPIDEDI_RRR_MARKER_SIZE_MAX);

    stupidedi_rrr_t* rrr;
    rrr = stupidedi_rrr_alloc();
    assert(rrr != NULL);
    rrrb->rrr = rrr;

    rrr->length       = length;
    rrr->rank         = 0;
    rrr->nblocks      = (length + block_size - 1) / block_size;
    rrr->nmarkers     = (length + marker_size - 1) / marker_size - 1;
    rrr->block_size   = block_size;
    rrr->marker_size  = marker_size;

    rrrb->offset_nbits_max = offset_nbits(block_size, block_size / 2);
    rrrb->block       = 0;
    rrrb->written     = 0;
    rrrb->class_at    = 0;
    rrrb->offset_at   = 0;
    rrrb->marker_at   = 0;
    rrrb->marker_need = marker_size;
    rrrb->block_need  = block_size;
    rrrb->is_done     = false;

    /* These two vectors are sufficient to encode the original bit vector. The
     * additional vectors allocated below are the o(n) atop nH₀, and are used
     * for making rank and select operations fast. */
    rrr->classes = stupidedi_packed_new(rrr->nblocks, nbits(block_size + 1));
    rrr->offsets = stupidedi_bitstr_new((uint32_t)(rrr->nblocks * rrrb->offset_nbits_max));

    if (rrr->nmarkers > 0)
    {
        rrr->marked_ranks   = stupidedi_packed_new(rrr->nmarkers, nbits(length + 1));
        rrr->marked_offsets = stupidedi_packed_new(rrr->nmarkers, nbits(stupidedi_bitstr_length(rrr->offsets)));
    }
    else
    {
        rrr->marked_ranks   = NULL;
        rrr->marked_offsets = NULL;
    }

    return rrrb;
}

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_deinit(stupidedi_rrr_builder_t* rrrb)
{
    if (rrrb == NULL)
        return rrrb;

    if (rrrb->rrr != NULL && !rrrb->is_done) /* TODO hmm? */
        rrrb->rrr = stupidedi_rrr_dealloc(rrrb->rrr);

    return rrrb;
}

/*****************************************************************************/

size_t
stupidedi_rrr_builder_sizeof(const stupidedi_rrr_builder_t* rrrb)
{
    return rrrb == NULL ? 0 : sizeof(*rrrb) + stupidedi_rrr_sizeof(rrrb->rrr);
}

size_t
stupidedi_rrr_builder_length(const stupidedi_rrr_builder_t* rrrb)
{
    assert(rrrb != NULL);
    assert(rrrb->rrr != NULL);
    return stupidedi_rrr_length(rrrb->rrr);
}

/*****************************************************************************/

size_t
stupidedi_rrr_builder_written(const stupidedi_rrr_builder_t* rrrb)
{
    assert(rrrb != NULL);
    assert(rrrb->rrr != NULL);

    stupidedi_rrr_t* rrr;
    rrr = rrrb->rrr;

    uint8_t uncommitted;
    uncommitted = rrr->block_size - rrrb->block_need;

    return (size_t)uncommitted + rrrb->written;
}

size_t
stupidedi_rrr_builder_write(stupidedi_rrr_builder_t* rrrb, uint8_t width, uint64_t value)
{
    assert(rrrb != NULL);
    assert(rrrb->rrr != NULL);
    assert(width <= STUPIDEDI_RRR_BLOCK_SIZE_MAX);
    assert(value <= (width < 64 ? (1 << width) - 1 : UINT64_MAX));

    stupidedi_rrr_t* rrr;
    rrr = rrrb->rrr;

    uint64_t block, mask, uncommitted;
    uncommitted = rrr->block_size - rrrb->block_need;
    assert(rrrb->written + uncommitted + width <= rrr->length);

    while (rrrb->block_need <= width)
    {
        /* Select only bits needed to finish filling this block, then append to
         * the end of the current block*/
        mask   = (1 << rrrb->block_need) - 1;
        block  = rrrb->block;
        block |= (value & mask) << (rrr->block_size - rrrb->block_need);

        /* Discard the used bits */
        value  = value >> rrrb->block_need;
        width -= rrrb->block_need;

        uint64_t class, offset;
        class  = popcount(block);
        offset = encode_block(rrr->block_size, class, block);

        /* Write marker if we have enough data. We know there is no more
         * than one marker because block_size <= sblock_nbits */
        int16_t marker_extra = rrr->block_size - rrrb->marker_need;

        if (marker_extra >= 0)
        {
            /* We might need only first few bits from the current `block` */
            uint64_t want, prefix;
            want   = rrr->block_size - marker_extra;
            prefix = want >= 64 ? block : block & ((1 << want) - 1);

            stupidedi_packed_write(rrr->marked_ranks,   rrrb->marker_at, rrr->rank + popcount(prefix));
            stupidedi_packed_write(rrr->marked_offsets, rrrb->marker_at, rrrb->offset_at);
            ++rrrb->marker_at;

            /* Next marker counts the bits not used in last marker */
            rrrb->marker_need = rrr->marker_size - marker_extra;
        }
        else
        {
            rrrb->marker_need -= rrr->block_size;
        }

        rrrb->class_at  = stupidedi_packed_write(rrr->classes, rrrb->class_at, class);
        rrrb->offset_at = stupidedi_bitstr_write(rrr->offsets, rrrb->offset_at, offset_nbits(rrr->block_size, class), offset);
        rrrb->written  += rrr->block_size;

        /* Next time we'll need a full block */
        rrrb->block      = 0;
        rrrb->block_need = rrr->block_size;

        rrr->rank += class;
    }

    /* Remaining value is guaranteed to be shorter than block_need */
    mask   = (1 << rrrb->block_need) - 1;
    block  = rrrb->block;
    block |= (value & mask) << (rrr->block_size - rrrb->block_need);
    rrrb->block = block;
    rrrb->block_need -= width;

    return rrrb->written + (rrr->block_size - rrrb->block_need);
}

stupidedi_rrr_t*
stupidedi_rrr_builder_to_rrr(stupidedi_rrr_builder_t* rrrb, stupidedi_rrr_t* rrr)
{
    assert(rrrb != NULL);
    assert(rrrb->rrr != NULL);

    if (rrr == NULL || rrr == rrrb->rrr)
        rrr = rrrb->rrr;
    else
    {
        rrr->length         = rrrb->rrr->length;
        rrr->rank           = rrrb->rrr->rank;
        rrr->block_size     = rrrb->rrr->block_size;
        rrr->nblocks        = rrrb->rrr->nblocks;
        rrr->classes        = rrrb->rrr->classes;
        rrr->offsets        = rrrb->rrr->offsets;
        rrr->marker_size    = rrrb->rrr->marker_size;
        rrr->nmarkers       = rrrb->rrr->nmarkers;
        rrr->marked_ranks   = rrrb->rrr->marked_ranks;
        rrr->marked_offsets = rrrb->rrr->marked_offsets;
    }

    uint8_t uncommitted;
    uncommitted = rrr->block_size - rrrb->block_need;
    assert(rrrb->written + (size_t)uncommitted == rrr->length);

    if (rrrb->marker_at < rrr->nmarkers)
    {
        /* Last marker wasn't written yet because of EOF. We may only need some
         * of the bits that haven't yet been written. */
        uint64_t mask, marked_rank;
        mask        = (1 << rrrb->marker_need) - 1;
        marked_rank = rrr->rank + popcount(rrrb->block & mask);

        stupidedi_packed_write(rrr->marked_ranks,   rrrb->marker_at, marked_rank);
        stupidedi_packed_write(rrr->marked_offsets, rrrb->marker_at, rrrb->offset_at);
    }

    if (uncommitted > 0)
    {
        /* Haven't yet written the last block */
        uint64_t class, offset;
        class  = popcount(rrrb->block);
        offset = encode_block(rrr->block_size, class, rrrb->block);
        rrr->rank += class;

        rrrb->class_at  = stupidedi_packed_write(rrr->classes, rrrb->class_at, class);
        rrrb->offset_at = stupidedi_bitstr_write(rrr->offsets, rrrb->offset_at, offset_nbits(rrr->block_size, class), offset);
    }

    /* Truncate unused space */
    stupidedi_bitstr_resize(rrr->offsets, rrrb->offset_at);

    rrrb->is_done = true;
    return rrr;
}

/*****************************************************************************/
/*****************************************************************************/
/*****************************************************************************/

stupidedi_rrr_t*
stupidedi_rrr_alloc(void)
{
    return malloc(sizeof(stupidedi_rrr_t));
}

stupidedi_rrr_t*
stupidedi_rrr_dealloc(stupidedi_rrr_t* rrr)
{
    if (rrr != NULL)
        free(stupidedi_rrr_deinit(rrr));

    return NULL;
}

stupidedi_rrr_t*
stupidedi_rrr_new(const stupidedi_bitstr_t* bs, uint8_t block_size, uint16_t marker_size)
{
    return stupidedi_rrr_init(stupidedi_rrr_alloc(), bs, block_size, marker_size);
}

stupidedi_rrr_t*
stupidedi_rrr_init(stupidedi_rrr_t* rrr, const stupidedi_bitstr_t* bs, uint8_t block_size, uint16_t marker_size)
{
    assert(rrr != NULL);

    stupidedi_rrr_builder_t rrrb;
    stupidedi_rrr_builder_init(&rrrb, block_size, marker_size, stupidedi_bitstr_length(bs));

    /* This counts full blocks, but may exclude the last block if it's partial */
    size_t nblocks;
    nblocks = stupidedi_bitstr_length(bs) / STUPIDEDI_RRR_BLOCK_SIZE_MAX;

    for (size_t k = 0; k < nblocks; ++k)
        stupidedi_rrr_builder_write(&rrrb, STUPIDEDI_RRR_BLOCK_SIZE_MAX,
                stupidedi_bitstr_read(bs, k * STUPIDEDI_RRR_BLOCK_SIZE_MAX, STUPIDEDI_RRR_BLOCK_SIZE_MAX));

    /* The last block could be smaller than a full block, so we handle it separately */
    uint8_t remainder;
    remainder = stupidedi_bitstr_length(bs) - (nblocks * STUPIDEDI_RRR_BLOCK_SIZE_MAX);

    if (remainder > 0)
        stupidedi_rrr_builder_write(&rrrb, remainder,
                stupidedi_bitstr_read(bs, nblocks * STUPIDEDI_RRR_BLOCK_SIZE_MAX, remainder));

    stupidedi_rrr_builder_to_rrr(&rrrb, rrr);
    stupidedi_rrr_builder_deinit(&rrrb);
    return rrr;
}

stupidedi_rrr_t*
stupidedi_rrr_deinit(stupidedi_rrr_t* rrr)
{
    if (rrr == NULL)
        return NULL;

    if (rrr->classes)
        rrr->classes = stupidedi_packed_dealloc(rrr->classes);

    if (rrr->offsets)
        rrr->offsets = stupidedi_bitstr_dealloc(rrr->offsets);

    if (rrr->marked_ranks)
        rrr->marked_ranks = stupidedi_packed_dealloc(rrr->marked_ranks);

    if (rrr->marked_offsets)
        rrr->marked_offsets = stupidedi_packed_dealloc(rrr->marked_offsets);

    return rrr;
}

/*****************************************************************************/

size_t
stupidedi_rrr_sizeof(const stupidedi_rrr_t* rrr)
{
    return (rrr == NULL) ? 0 :
        sizeof(*rrr) +
        stupidedi_packed_sizeof(rrr->classes) +
        stupidedi_bitstr_sizeof(rrr->offsets) +
        stupidedi_packed_sizeof(rrr->marked_ranks) +
        stupidedi_packed_sizeof(rrr->marked_offsets);
}

size_t
stupidedi_rrr_length(const stupidedi_rrr_t* rrr)
{
    assert(rrr != NULL);
    return rrr->length;
}

/*****************************************************************************/

char*
stupidedi_rrr_to_string(const stupidedi_rrr_t* rrr)
{
    if (rrr == NULL)
        return strdup("NULL");

    char *s, *offsets, *classes, *marked_ranks, *marked_offsets;
    asprintf(&s, "size=%zu rank=%zu block_size=%u nblocks=%zu marker_size=%u nmarkers=%zu "
            "offsets=%s classes=%s marked_ranks=%s marked_offsets=%s",
            rrr->length,
            rrr->rank,
            rrr->block_size,
            rrr->nblocks,
            rrr->marker_size,
            rrr->nmarkers,
            offsets = stupidedi_bitstr_to_string(rrr->offsets),
            classes = stupidedi_packed_to_string(rrr->classes),
            marked_ranks = stupidedi_packed_to_string(rrr->marked_ranks),
            marked_offsets = stupidedi_packed_to_string(rrr->marked_offsets));

    free(offsets);
    free(classes);
    free(marked_ranks);
    free(marked_offsets);

    return s;
}

stupidedi_bitstr_t*
stupidedi_rrr_to_bitstr(const stupidedi_rrr_t* rrr, stupidedi_bitstr_t* b)
{
    if (rrr == NULL)
        return NULL;

    b = (b == NULL) ?
        stupidedi_bitstr_new(rrr->length) :
        stupidedi_bitstr_init(stupidedi_bitstr_deinit(b), rrr->length);

    size_t offset_at, class_at;
    offset_at = 0;
    class_at  = 0;

    for (; class_at < rrr->nblocks - 1; ++class_at)
    {
        uint64_t block, class, offset;
        class = read_class(rrr, class_at);

        uint8_t width;
        width = offset_nbits(rrr->block_size, class);

        offset = read_offset(rrr, offset_at, width);
        block  = decode_block(rrr->block_size, class, offset);
        offset_at += width;
        stupidedi_bitstr_write(b, class_at*rrr->block_size, rrr->block_size, block);
    }

    /* Last block might be partial, so avoid writing more bits than we have */
    uint64_t block, class, offset;
    class = read_class(rrr, class_at);

    uint8_t width;
    width = offset_nbits(rrr->block_size, class);

    offset = read_offset(rrr, offset_at, width);
    block  = decode_block(rrr->block_size, class, offset);

    uint8_t block_size;
    block_size = rrr->length - class_at*rrr->block_size;
    stupidedi_bitstr_write(b, class_at*rrr->block_size, block_size, block);

    return b;
}

/*****************************************************************************/

uint8_t
stupidedi_rrr_access(const stupidedi_rrr_t* rrr, size_t i)
{
    assert(rrr != NULL);
    assert(i < rrr->length);

    size_t marker_at, class_at, offset_at, i_;
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

size_t
stupidedi_rrr_rank0(const stupidedi_rrr_t* rrr, size_t i)
{
    return ((i < rrr->length) ? i + 1 : rrr->length) - stupidedi_rrr_rank1(rrr, i);
}

size_t
stupidedi_rrr_rank1(const stupidedi_rrr_t* rrr, size_t i)
{
    assert(rrr != NULL);

    if (i >= rrr->length)
        return rrr->rank;

    size_t i_, rank, marker_at, class_at, offset_at;
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
    mask  = mask < 64 ? (1 << mask) - 1 : UINT64_MAX;
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
    mask   = n < 64 ? (1 << n) - 1 : UINT64_MAX;

    return (size_t) (rank + popcount(block & mask));
}

size_t
stupidedi_rrr_select0(const stupidedi_rrr_t* rrr, size_t r)
{
    assert(rrr != NULL);

    if (r == 0 || r > rrr->length - rrr->rank)
        return SIZE_MAX;

    uint8_t twice;
    int16_t i;
    uint64_t class, width, block, offset;
    size_t marker_i, rank, class_at, offset_at, marker_at;

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
        size_t class_i;
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
            block &= ~(1 << i);
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
        block &= ~(1 << n);
    }

    return n + class_at * rrr->block_size;
}

size_t
stupidedi_rrr_select1(const stupidedi_rrr_t* rrr, size_t r)
{
    assert(rrr != NULL);

    if (r == 0 || r > rrr->rank)
        return SIZE_MAX;

    int16_t i;
    uint64_t class, width, rank, block, offset;
    size_t class_at, offset_at, marker_at;

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
        rank      = read_marked_rank1(rrr, marker_at - 1);
        offset_at = read_marked_offset(rrr, marker_at - 1);
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
        block &= ~(1 << i);
    }

    return i + class_at * rrr->block_size;
}

size_t
stupidedi_rrr_prev0(const stupidedi_rrr_t* rrr, size_t i)
{
    return 0; /* TODO */
}

size_t
stupidedi_rrr_prev1(const stupidedi_rrr_t* rrr, size_t i)
{
    return 0; /* TODO */
}

size_t
stupidedi_rrr_next0(const stupidedi_rrr_t* rrr, size_t i)
{
    return 0; /* TODO */
}

size_t
stupidedi_rrr_next1(const stupidedi_rrr_t* rrr, size_t i)
{
    return 0; /* TODO */
}

/*****************************************************************************/

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

inline uint8_t
offset_nbits(uint64_t block_size, uint64_t class)
{
    precompute_binomials();
    uint64_t count;
    count = binomial[block_size][class];
    return nbits(count == 0 ? 0 : count - 1);
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
            value  |= (1 << n);
            offset -= before;
            class  --;
        }
    }

    if (class > 0)
        value |= (1 << class) - 1;

    return value;
}

static inline size_t
class_bit_idx(const stupidedi_rrr_t* rrr, size_t k)
{
    return k * rrr->block_size;
}

static inline size_t
marker_bit_idx(const stupidedi_rrr_t* rrr, size_t k)
{
    return (k + 1) * rrr->marker_size;
}

static inline size_t
read_class(const stupidedi_rrr_t* rrr, size_t class_at)
{
    return (size_t)stupidedi_packed_read(rrr->classes, class_at);
}

static inline size_t
read_offset(const stupidedi_rrr_t* rrr, size_t offset_at, uint8_t width)
{
    return (rrr->offsets == NULL || stupidedi_bitstr_length(rrr->offsets) == 0) ?
        0 : (size_t)stupidedi_bitstr_read(rrr->offsets, offset_at, width);
}

static inline size_t
read_marked_rank0(const stupidedi_rrr_t* rrr, size_t marker_at)
{
    return marker_bit_idx(rrr, marker_at) - read_marked_rank1(rrr, marker_at);
}

static inline size_t
read_marked_rank1(const stupidedi_rrr_t* rrr, size_t marker_at)
{
    return (size_t)stupidedi_packed_read(rrr->marked_ranks, marker_at);
}

static inline size_t
read_marked_offset(const stupidedi_rrr_t* rrr, size_t marker_at)
{
    return (size_t)stupidedi_packed_read(rrr->marked_offsets, marker_at);
}

static size_t
stupidedi_rrr_find_marker0(const stupidedi_rrr_t* rrr, size_t r)
{
    assert(rrr != NULL);
    assert(r <= rrr->length - rrr->rank);

    /* The key here is to use marked_ranks[k], which counts 1s bits that occur
     * in the first i=(k+1)*rrr->marker_size bits. Since each bit is 0 or 1, we
     * can work out the number of 0s from the number of 1s.
     */

    if (rrr->nmarkers == 0)
        return 0;

    size_t lo, hi, save, k, r_;
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

static size_t
stupidedi_rrr_find_marker1(const stupidedi_rrr_t* rrr, size_t r)
{
    assert(rrr != NULL);
    assert(r <= rrr->rank);

    if (rrr->nmarkers == 0)
        return 0;

    size_t lo, hi, save, k, r_;
    lo = 0;
    hi = rrr->nmarkers - 1;
    save = -1;

    do
    {
        k  = lo + (hi - lo) / 2;
        r_ = read_marked_rank1(rrr, k);

        if (r_ < r)
            lo = (save = k) + 1;
        else
            hi = k - 1;

    } while (0 < k && lo <= hi);

    if (r <= r_)
        k = save;

    return k + 1;
}
