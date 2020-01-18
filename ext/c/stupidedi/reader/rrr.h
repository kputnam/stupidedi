#include <stdint.h>
#include "bit_vector.h"

struct rrr_t {
    uint32_t size;          /* total number of bits in original input */
    uint32_t rank;          /* number of 1-bits in original input */
    uint32_t nblocks;       /* number of blocks in original input */
    uint8_t block_nbits;    /* number of bits each block represents */

    bit_vector_t *classes;  /* fixed width; one per block */
    bit_vector_t *offsets;  /* variable width; one per block */

    uint16_t rank_sample_nbits;     /* how frequently rank is sampled */
    uint16_t select_sample_nones;   /* how frequently select is sampled */

    /* fixed width; rank_samples[x] is the total number of 1-bits in the
     * bit string from 0 to the (x*(1+rank_sample_nbits) - 1)-th bit */
    bit_vector_t *rank_samples;

    /* fixed width; select_samples[x] is the bit index at which the
     * (x * select_sample_nones)-th 1-bit occurs */
    bit_vector_t *select_samples;

    /* fixed width; offset_samples[x] is the location where the offset for the
     * (x * 
     *
     * To randomly access and decode a block k, its class is `classes[k]`, and
     * its offset occupies (block_size choose classes[k]) bits beginning at:
     *
     *    SUM( CEIL(LB(block_size choose classes[j])), FOR j = 0..k-1)
     *
     * This is the sum of all the offset lengths for blocks that preceed this
     * block. Computing this sum would become increasingly slow as k increases.
     *
     * We can precompute these offsets at regular intervals, leaving only a
     * smaller partial sum that needs to be computed for any particular block.
     *
     * Note `rank_simples` samples are `SUM( classes[j], FOR J = 0..k)`, but
     * we can't derive offset_samples from that or vice versa because:
     *
     *    SUM( 5 5 10 )                                = 20
     *    SUM( ⌈lb 5⌉ + ⌈lb 5⌉ + ⌈lb 10⌉ ) = 3 + 3 + 4 = 10
     *
     *    SUM( 10 10 )                                 = 20
     *    SUM( ⌈lb 10⌉ + ⌈lb 10⌉] )        = 4 + 4     = 8
     *
     * These two sequences of block classes have the same rank (20), but the
     * offset for their next block begins at different locations (10 and 8).
     */
    bit_vector_t *offset_samples;
};

typedef struct rrr_t rrr_t;

rrr_t* rrr_alloc(bit_vector_t*, uint8_t, uint16_t, uint16_t);
void rrr_free(rrr_t*);

/* access(B, i) = B[i] */
uint64_t rrr_access(const rrr_t*, const uint64_t);

/* rank0(B, i) = |{j ∈ [0, i) : B[j] = 0}| */
uint32_t rrr_rank0(const rrr_t*, const uint64_t);

/* rank0(B, i) = |{j ∈ [0, i) : B[j] = 1}| */
uint32_t rrr_rank1(const rrr_t*, const uint64_t);

/* select0(B, i) = max{j ∈ [0, n) | rank0(j) = i} */
uint32_t rrr_select0(const rrr_t*, const uint64_t);

/* select0(B, i) = max{j ∈ [0, n) | rank1(j) = i} */
uint32_t rrr_select1(const rrr_t*, const uint64_t);
