#ifndef STUPIDEDI_RRR_H_
#define STUPIDEDI_RRR_H_

#include <stdint.h>
#include "stupidedi/include/bitmap.h"

#define STUPIDEDI_RRR_BLOCK_SIZE_MIN 2
#define STUPIDEDI_RRR_BLOCK_SIZE_MAX 64

#define STUPIDEDI_RRR_MARKER_SIZE_MIN 3
#define STUPIDEDI_RRR_MARKER_SIZE_MAX 2048

typedef struct stupidedi_rrr_t
{
    /* Total number of bits in input */
    stupidedi_bit_idx_t size;

    /* Number of 1-bits in input */
    stupidedi_bit_idx_t rank;

    /* Number of input bits per block */
    uint8_t block_size;
    stupidedi_bit_idx_t nblocks;

    /* classes[k] is number of 1s bits in kth block. */
    stupidedi_bitmap_t* classes;

    /* Variable width, offsets[k] points to one of the values with classes[k] 1s bits. */
    stupidedi_bitmap_t* offsets;

    /* Number of input bits per marker */
    uint16_t marker_size;
    stupidedi_bit_idx_t nmarkers;

    /* Each marker counts how many 1-bits occured in the first (1+k)*marker_size bits. */
    stupidedi_bitmap_t* marked_ranks;

    /* Points to the offset for the block with the (1+k)*marker_size-1 th bit. */
    stupidedi_bitmap_t* marked_offsets;

    /* TODO
    uint16_t counter_step;
    stupidedi_bit_idx_t ncounters;
    stupidedi_bitmap_t* counters; */
} stupidedi_rrr_t;

typedef struct stupidedi_rrr_builder_t
{
    stupidedi_rrr_t* rrr;
    uint8_t  offset_nbits_max, block_need;
    uint16_t marker_need;
    stupidedi_bit_idx_t written, class_at, offset_at, marker_at;
    uint64_t block;
} stupidedi_rrr_builder_t;

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_alloc(uint8_t block_size, uint16_t marker_size, stupidedi_bit_idx_t size, stupidedi_rrr_builder_t* target, stupidedi_rrr_t*);

void
stupidedi_rrr_builder_free(stupidedi_rrr_builder_t*);

/* Number of bytes occupied in memory */
size_t
stupidedi_rrr_builder_sizeof(const stupidedi_rrr_builder_t*);

/* Number of bits occupied in memory */
uint64_t
stupidedi_rrr_builder_sizeof_bits(const stupidedi_rrr_builder_t*);

/* Append some number of bits (<=64) to the RRR vector. */
void
stupidedi_rrr_builder_append(stupidedi_rrr_builder_t*, uint8_t width, uint64_t value);

/* Number of bits already written */
stupidedi_bit_idx_t
stupidedi_rrr_builder_written(const stupidedi_rrr_builder_t*);

/* Finish constructing and return the RRR vector */
stupidedi_rrr_t*
stupidedi_rrr_builder_build(stupidedi_rrr_builder_t*);

/* Number of bits the RRR vector represents */
stupidedi_bit_idx_t
stupidedi_rrr_builder_size(const stupidedi_rrr_builder_t*);

stupidedi_rrr_t*
stupidedi_rrr_alloc(const stupidedi_bitmap_t* source, uint8_t block_size, uint16_t marker_size, stupidedi_rrr_t* target);

void
stupidedi_rrr_free(stupidedi_rrr_t*);

/* Number of bytes occupied in memory, not counting the pointer itself */
size_t
stupidedi_rrr_sizeof(const stupidedi_rrr_t*);

/* Number of bits occupied in memory, not counting the pointer itself */
uint64_t
stupidedi_rrr_sizeof_bits(const stupidedi_rrr_t*);

/* Pretty print RRR vector. */
char*
stupidedi_rrr_to_string(const stupidedi_rrr_t*);

/* Decodes the entire RRR vector. */
stupidedi_bitmap_t*
stupidedi_rrr_to_bitmap(const stupidedi_rrr_t*);

/* Number of bits represented by this RRR vector */
stupidedi_bit_idx_t
stupidedi_rrr_size(const stupidedi_rrr_t*);

/* The i-th bit (using zero-based indexing)
 *
 * access(B, i) = B[i] */
uint8_t
stupidedi_rrr_access(const stupidedi_rrr_t*, stupidedi_bit_idx_t);

/* Number of 0s bits up to and including position i
 *
 * rank0(B, i) = |{j ∈ [0..i) : B[j] = 0}| */
stupidedi_bit_idx_t
stupidedi_rrr_rank0(const stupidedi_rrr_t*, stupidedi_bit_idx_t i);

/* Number of 1s bits up to and including position i
 *
 * rank1(B, i) = |{j ∈ [0..i] : B[j] = 1}| */
stupidedi_bit_idx_t
stupidedi_rrr_rank1(const stupidedi_rrr_t*, stupidedi_bit_idx_t i);

/* Position of the j-th 0 bit in B (using zero-based indexing), or 0 when j
 * exceeds the number of 0s bits in B
 *
 * select0(B, j) = min{i ∈ [0..n] | rank0(i) = j} */
stupidedi_bit_idx_t
stupidedi_rrr_select0(const stupidedi_rrr_t*, stupidedi_bit_idx_t r);

/* Position of the r-th 1 bit in B (using zero-based indexing), or 0 when j
 * exceeds the number of 1s bits in B
 *
 * select1(B, j) = min{i ∈ [0..n) | rank1(i) = j} */
stupidedi_bit_idx_t
stupidedi_rrr_select1(const stupidedi_rrr_t*, stupidedi_bit_idx_t r);

/* Position of nearest the 0-bit before position i */
stupidedi_bit_idx_t
stupidedi_rrr_prev0(const stupidedi_rrr_t*, stupidedi_bit_idx_t i);

/* Position of the nearest 1-bit before position i */
stupidedi_bit_idx_t
stupidedi_rrr_prev1(const stupidedi_rrr_t*, stupidedi_bit_idx_t i);

/* Position of the nearest 0-bit after position i */
stupidedi_bit_idx_t
stupidedi_rrr_next0(const stupidedi_rrr_t*, stupidedi_bit_idx_t i);

/* Position of the nearest 1-bit after position i */
stupidedi_bit_idx_t
stupidedi_rrr_next1(const stupidedi_rrr_t*, stupidedi_bit_idx_t i);

#endif
