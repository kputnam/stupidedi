#ifndef STUPIDEDI_RRR_H_
#define STUPIDEDI_RRR_H_

#include <stddef.h>
#include <stdint.h>
#include "bit_vector.h"

#define RRR_BLOCK_SIZE_MIN 2
#define RRR_BLOCK_SIZE_MAX 64

#define RRR_MARKER_SIZE_MIN 3
#define RRR_MARKER_SIZE_MAX 2048

typedef struct rrr_t {
    uint32_t size;          /* total number of bits in input */
    uint32_t rank;          /* number of 1-bits in input */

    uint8_t block_size;     /* number of input bits per block */
    uint32_t nblocks;

    uint16_t marker_size;   /* number of input bits per marker */
    uint32_t nmarkers;

    bit_vector_t* classes;  /* fixed width "K" */
    bit_vector_t* offsets;  /* variable width "R" */

    /* Each marker counts how many 1-bits occured in the first (1+k)*marker_size bits */
    bit_vector_t* marked_ranks;

    /* Points to the offset for the block with the (1+k)*marker_size-1 th bit. */
    bit_vector_t* marked_offsets;
} rrr_t;

typedef struct rrr_builder_t {
    rrr_t* rrr;
    uint8_t  offset_nbits_max, block_need;
    uint16_t marker_need;
    uint32_t written, class_at, offset_at, marker_at;
    uint64_t block;
} rrr_builder_t;

rrr_builder_t* rrr_builder_alloc(uint8_t, uint16_t, uint32_t, rrr_builder_t*, rrr_t*);
void rrr_builder_append(rrr_builder_t*, uint8_t, uint64_t);
uint32_t rrr_builder_written(rrr_builder_t*);
rrr_t* rrr_builder_finish(rrr_builder_t*);
void rrr_builder_free(rrr_builder_t*);
uint32_t rrr_builder_size(const rrr_builder_t*);
size_t rrr_builder_sizeof(const rrr_builder_t*);
uint64_t rrr_builder_size_bits(const rrr_builder_t*);

rrr_t* rrr_alloc(bit_vector_t*, uint8_t, uint16_t, rrr_t*);
void rrr_free(rrr_t*);
char* rrr_to_string(const rrr_t*);
bit_vector_t* rrr_to_bit_vector(const rrr_t*);

uint32_t rrr_size(const rrr_t*);
size_t rrr_sizeof(const rrr_t*);
uint64_t rrr_size_bits(const rrr_t*);

/* access(B, i) = B[i] */
uint8_t rrr_access(const rrr_t*, bit_idx_t);

/* rank0(B, i) = |{j ∈ [0, i) : B[j] = 0}| */
bit_idx_t rrr_rank0(const rrr_t*, bit_idx_t);

/* rank1(B, i) = |{j ∈ [0, i) : B[j] = 1}| */
bit_idx_t rrr_rank1(const rrr_t*, bit_idx_t);

/* select0(B, i) = max{j ∈ [0, n) | rank0(j) = i} */
bit_idx_t rrr_select0(const rrr_t*, bit_idx_t);

/* select1(B, i) = max{j ∈ [0, n) | rank1(j) = i} */
bit_idx_t rrr_select1(const rrr_t*, bit_idx_t);

#endif
