#ifndef STUPIDEDI_RRR_H_
#define STUPIDEDI_RRR_H_

#include <stdint.h>
#include "bit_vector.h"

typedef struct rrr_t {
    uint32_t size;          /* total number of bits in input */
    uint32_t rank;          /* number of 1-bits in input */
    uint8_t block_nbits;    /* number of input bits per block */
    uint8_t marker_nbits;   /* number of input bits per marker */
    uint32_t nblocks;
    uint32_t nmarkers;

    bit_vector_t *classes;  /* fixed width "K" */
    bit_vector_t *offsets;  /* variable width "R" */

    bit_vector_t *marked_ranks;
    bit_vector_t *marked_offsets;
} rrr_t;

void rrr_free(rrr_t*);
void rrr_print(const rrr_t*);

rrr_t* rrr_alloc(bit_vector_t*, uint8_t, uint8_t);

/* access(B, i) = B[i] */
uint8_t rrr_access(const rrr_t*, uint64_t);

/* rank0(B, i) = |{j ∈ [0, i) : B[j] = 0}| */
uint32_t rrr_rank0(const rrr_t*, uint64_t);

/* rank1(B, i) = |{j ∈ [0, i) : B[j] = 1}| */
uint32_t rrr_rank1(const rrr_t*, uint64_t);

/* select0(B, i) = max{j ∈ [0, n) | rank0(j) = i} */
uint32_t rrr_select0(const rrr_t*, uint64_t);

/* select1(B, i) = max{j ∈ [0, n) | rank1(j) = i} */
uint32_t rrr_select1(const rrr_t*, uint64_t);

#endif
