#ifndef STUPIDEDI_WAVELET_H_
#define STUPIDEDI_WAVELET_H_

#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/huffman.h"

/* Represents an immutable sequence of symbols S={sᵢ| sᵢ ∈ [0,σ)} and provides
 * the following operations:
 *
 *   - access(i):    returns the i-th symbol
 *   - rank(c, i):   returns the number of occurrences of c in S[0..i)
 *   - select(c, r): returns the index of the r-th occurrence of c in S
 *
 * Symbols are integers spanning a contiguous range [0,σ). To represent
 * sequences of elements like sparse random numbers, words, letters, or other
 * non-integer items, use an external table to translate element to and from
 * integers 0..σ. The wavelet matrix is designed to efficiently handle very
 * large alphabets.
 *
 * The maximum codeword length L is bound by log σ <= L <= 64. When using
 * variable-length coding, the average codeword length L* is bound by H₀(S) <=
 * L* <= H₀(S) + 1, where S is the sequence of symbols being encoded and H₀
 * computes the zero-order entropy of a sequence.
 *
 * With fixed-width encoding, L* = L, which is inferred from the width of the
 * packed array represented by the wavelet matrix.
 *
 * When wavelet matrix uses fixed-length encoding:
 *   Space complexity:  o(nL) ≅ o(n log σ)
 *   Variable overhead: O(L log nL)
 *   Constant overhead: 40 + 2*33 + 1*182 = 288 bytes
 *
 * When wavelet matrix uses variable-length encoding (uncompressed codebook):
 *   Space complexity:  TODO
 *   Variable overhead: TODO
 *   Constant overhead: 48 + 2*33 + 1*182 + 1*231 = 527 bytes
 *
 * When wavelet matrix uses variable-length encoding (compressed codebook):
 *   Space complexity:  TODO
 *   Variable overhead: TODO
 *   Constant overhead: 48 + 2*33 + 1*182 + 1*659 = 955 bytes */
typedef struct stupidedi_wavelet_t          stupidedi_wavelet_t;

typedef struct stupidedi_wavelet_builder_t  stupidedi_wavelet_builder_t;

/*****************************************************************************/

stupidedi_wavelet_t*
stupidedi_wavelet_alloc(void);

stupidedi_wavelet_t*
stupidedi_wavelet_free(stupidedi_wavelet_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_new(stupidedi_packed_t*, stupidedi_huffman_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_init(stupidedi_wavelet_t*, stupidedi_packed_t*, stupidedi_huffman_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_deinit(stupidedi_wavelet_t*);

stupidedi_wavelet_t*
stupidedi_wavelet_copy(stupidedi_wavelet_t*);

/*****************************************************************************/

size_t
stupidedi_wavelet_sizeof(const stupidedi_wavelet_t*);

size_t
stupidedi_wavelet_length(const stupidedi_wavelet_t*);

char*
stupidedi_wavelet_to_string(const stupidedi_wavelet_t*);

stupidedi_packed_t*
stupidedi_wavelet_to_packed(const stupidedi_wavelet_t*);

/*****************************************************************************/

/* O(log σ), access(S, i) = S[i]
 *
 * Returns the i-th symbol. */
uint64_t
stupidedi_wavelet_access(const stupidedi_wavelet_t*, size_t);

/* O(log σ), rank(S, i, c) = |{j ∈ [0,i) : S[j] = c}|
 *
 * Counts the number of times c occurs in the first i symbols. */
size_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t*, uint64_t, size_t);

/* O(log σ), select(S, r, a) = min{j ∈ [0,n) | rank(S, j, c) = r}
 *
 * Returns the length of the shortest prefix that contains r c symbols. */
size_t
stupidedi_wavelet_select(const stupidedi_wavelet_t*, size_t, uint64_t);

/* O(log σ), TODO */
size_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* w, uint64_t, size_t);

/* O(log σ), TODO */
size_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* w, uint64_t, size_t);

#endif
