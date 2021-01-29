#ifndef STUPIDEDI_RRR_H_
#define STUPIDEDI_RRR_H_

#include <stdint.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/packed.h"

#define STUPIDEDI_RRR_BLOCK_SIZE_MIN 2
#define STUPIDEDI_RRR_BLOCK_SIZE_MAX 64

#define STUPIDEDI_RRR_MARKER_SIZE_MIN 3
#define STUPIDEDI_RRR_MARKER_SIZE_MAX 2048

/* Represents an immutable bit sequence B={bᵢ| bᵢ ∈ {0,1}} and provides the
 * following constant-time O(1) operations:
 *
 *   - access(i):  returns the i-th symbol
 *   - rank0(i):   returns the number of 0-bits in B[0..i)
 *   - rank1(i):   returns the number of 1-bits in B[0..i)
 *   - select0(n): returns the index of the nth 0-bit in B
 *   - select1(n): returns the index of the nth 1-bit in B
 *
 * The bit sequence is compressed but does not require fully decompressing the
 * sequence to operate on it. Where n is the length of the bit sequence and
 * H₀(B) denotes its zero-order entropy, the space required is proportional to
 * nH₀(B). Zero-order entropy can be calculated by -(p₀log(p₀) + p₁log(p₁)),
 * where p₀ = 1 - p₁ is the probability of a 0 bit.
 *
 * When p₀ = 0.5, H₀ reaches its maximum of 1.0. As p₀ approaches 0, H₀ also
 * approaches 0. In other words, when a bit sequence is uniformly random, it
 * has maximum entropy and there is no reduction in size using compression.
 * Compression is most effective when the bit sequence is mostly 0-bits or
 * mostly 1-bits.
 *
 * Space complexity:  o(n)
 * Variable overhead: o(n)
 * Constant overhead: 67 + 3*33 + 1*16 = 182 bytes */
typedef struct stupidedi_rrr_t          stupidedi_rrr_t;

/* TODO
 *
 * Space complexity:  o(n)
 * Variable overhead: o(n)
 * Constant overhead: 45 + 67 + 3*33 + 1*16 = 227 bytes */
typedef struct stupidedi_rrr_builder_t  stupidedi_rrr_builder_t;

/*****************************************************************************/

/* O(1) */
stupidedi_rrr_t*
stupidedi_rrr_alloc(void);

/* O(1) */
stupidedi_rrr_t*
stupidedi_rrr_free(stupidedi_rrr_t*);

/* O(n) */
stupidedi_rrr_t*
stupidedi_rrr_new(const stupidedi_bitstr_t*, uint8_t block_size, uint16_t marker_size);

/* O(n) */
stupidedi_rrr_t*
stupidedi_rrr_init(stupidedi_rrr_t*, const stupidedi_bitstr_t*, uint8_t block_size, uint16_t marker_size);

/* O(1) */
stupidedi_rrr_t*
stupidedi_rrr_deinit(stupidedi_rrr_t*);

/* O(n) */
stupidedi_rrr_t*
stupidedi_rrr_copy(stupidedi_rrr_t*);

/*****************************************************************************/

/* O(1) */
size_t
stupidedi_rrr_sizeof(const stupidedi_rrr_t*);

/* O(1) */
size_t
stupidedi_rrr_length(const stupidedi_rrr_t*);

/* O(n) */
char*
stupidedi_rrr_to_string(const stupidedi_rrr_t*);

/* O(n) */
stupidedi_bitstr_t*
stupidedi_rrr_to_bitstr(const stupidedi_rrr_t*, stupidedi_bitstr_t*);

/*****************************************************************************/

/* O(1), access(B, i) = B[i]
 *
 * Returns the i-th bit. */
uint8_t
stupidedi_rrr_access(const stupidedi_rrr_t*, size_t);

/* O(1), rank0(S, i) = |{j ∈ [0,i) : B[j] = 0}|
 *
 * Conuts the number of times 0 occurs in the first i bits. */
size_t
stupidedi_rrr_rank0(const stupidedi_rrr_t*, size_t i);

/* O(1), rank1(S, i) = |{j ∈ [0,i) : B[j] = 1}|
 *
 * Counts the number of times 1 occurs in the first i bits. */
size_t
stupidedi_rrr_rank1(const stupidedi_rrr_t*, size_t i);

/* O(1), select0(S, r) = min{j ∈ [0,n) | rank0(B, j) = r}
 *
 * Returns the length of the shortest prefix where 0 occurs r times. */
size_t
stupidedi_rrr_select0(const stupidedi_rrr_t*, size_t r);

/* O(1), select1(S, r) = min{j ∈ [0,n) | rank1(B, j) = r}
 *
 * Returns the length of the shortest prefix where 1 occurs r times. */
size_t
stupidedi_rrr_select1(const stupidedi_rrr_t*, size_t r);

/* O(1), TODO */
size_t
stupidedi_rrr_prev0(const stupidedi_rrr_t*, size_t i);

/* O(1), TODO */
size_t
stupidedi_rrr_prev1(const stupidedi_rrr_t*, size_t i);

/* O(1), TODO */
size_t
stupidedi_rrr_next0(const stupidedi_rrr_t*, size_t i);

/* O(1), TODO */
size_t
stupidedi_rrr_next1(const stupidedi_rrr_t*, size_t i);

/*****************************************************************************/
/*****************************************************************************/
/*****************************************************************************/

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_alloc(void);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_new(uint8_t block_size, uint16_t marker_size, size_t length);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_init(stupidedi_rrr_builder_t*, uint8_t block_size, uint16_t marker_size, size_t length);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_deinit(stupidedi_rrr_builder_t*);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_free(stupidedi_rrr_builder_t*);

/*****************************************************************************/

size_t
stupidedi_rrr_builder_sizeof(const stupidedi_rrr_builder_t*);

size_t
stupidedi_rrr_builder_length(const stupidedi_rrr_builder_t*);

/*****************************************************************************/

/* O(1) */
size_t
stupidedi_rrr_builder_written(const stupidedi_rrr_builder_t*);

/* O(1) */
size_t
stupidedi_rrr_builder_write(stupidedi_rrr_builder_t*, uint8_t width, uint64_t value);

/* O(1) */
stupidedi_rrr_t*
stupidedi_rrr_builder_to_rrr(stupidedi_rrr_builder_t*, stupidedi_rrr_t*);

#endif
