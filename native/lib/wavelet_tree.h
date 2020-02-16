#ifndef STUPIDEDI_WAVELET_TREE_H_
#define STUPIDEDI_WAVELET_TREE_H_

#include <stdint.h>
#include <stddef.h>
#include "rrr.h"
#include "bit_vector.h"

typedef struct wavelet_tree_t {
    rrr_t* data;
    uint32_t from;
    uint32_t upto;

    struct wavelet_tree_t* l;
    struct wavelet_tree_t* r;
} wavelet_tree_t;

#define wavelet_tree_sym_t uint32_t
#define WAVELET_TREE_SYM_MIN 0
#define WAVELET_TREE_SYM_MAX UINT32_MAX

#define wavelet_tree_idx_t uint32_t
#define WAVELET_TREE_IDX_MIN 0
#define WAVELET_TREE_IDX_MAX UINT32_MAX

wavelet_tree_t* wavelet_tree_alloc(bit_vector_t*, wavelet_tree_t*);
void wavelet_tree_free(wavelet_tree_t*);
void wavelet_tree_print(const wavelet_tree_t*);

wavelet_tree_idx_t wavelet_tree_size(const wavelet_tree_t*);
size_t wavelet_tree_sizeof(const wavelet_tree_t*);
uint64_t wavelet_tree_size_bits(const wavelet_tree_t*);

/* access(S, i) = S[i] */
wavelet_tree_sym_t wavelet_tree_access(const wavelet_tree_t*, wavelet_tree_idx_t);

/* rank(S, i, a) = |{j ∈ [0, i) : S[j] = a}| */
wavelet_tree_idx_t wavelet_tree_rank(const wavelet_tree_t*, wavelet_tree_sym_t, wavelet_tree_idx_t);

/* select1(S, i, a) = max{j ∈ [0, n) | rank(j, a) = i} */
wavelet_tree_idx_t wavelet_tree_select(const wavelet_tree_t*, wavelet_tree_sym_t, wavelet_tree_idx_t);

#endif
