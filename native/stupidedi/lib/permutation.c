#if FALSE
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/permutation.h"

/* TODO */
stupidedi_permutation_t*
stupidedi_permutation_alloc(stupidedi_bitstr_t* permute, stupidedi_permutation_t* dst)
{
    assert(permute != NULL);
    assert(permute->width > 0);

    stupidedi_bit_idx_t size;
    size = stupidedi_bitstr_size(permute);

    /* Permutation of size n must have unique elements [0..n) */
    assert(size > 0);
    assert(permute->width >= nbits(size));

    stupidedi_permutation_t* p;

    p = malloc(sizeof(stupidedi_permutation_t));
    assert(p != NULL);

    p->forward = permute;
    p->reverse = stupidedi_bitstr_reverse(permute);

    return p;

    /*
    stupidedi_bitstr_t *inverse, *collapse;
    stupidedi_rrr_t *runs, *rinv;
    stupidedi_rrr_builder_t *runs_, *rinv_;

    inverse = stupidedi_bitstr_alloc_record(size, permute->width, NULL);
    for (stupidedi_bit_idx_t k = 0; k < size; ++k)
        stupidedi_bitstr_write_record(inverse,
                stupidedi_bitstr_read_record(permute, k), k);

    // Mark the position where an increasing run in `permute` begins
    runs_ = stupidedi_rrr_builder_alloc(31, 256, size, NULL, NULL);
    rinv_ = stupidedi_rrr_builder_alloc(31, 256, size, NULL, NULL);
    stupidedi_rrr_builder_append(runs_, 1, 0);

    uint64_t prev, nruns;
    prev  = stupidedi_bitstr_read_record(permute, 0);
    nruns = 0;

    // Mark the beginning of each increasing run
    for (stupidedi_bit_idx_t k = 1; k < size; ++k)
    {
        uint64_t current;
        current = stupidedi_bitstr_read_record(permute, k);

        if (prev + 1 == current)
            stupidedi_rrr_builder_append(runs_, 1, 0);
        else
        {
            stupidedi_rrr_builder_append(runs_, 1, 1);
            ++nruns;
        }

        prev = current;
    }
    runs = stupidedi_rrr_builder_build(runs_);
    stupidedi_rrr_builder_free(runs_);

    // rinv(i) = r(inverse(i))
    for (stupidedi_bit_idx_t k = 0; k < size; ++k)
    {
        uint64_t k_ = stupidedi_bitstr_read_record(inverse, k);
        stupidedi_rrr_builder_append(rinv_, 1,
                stupidedi_rrr_access(runs, k_) == 0 ? 0 : 1);
    }
    rinv = stupidedi_rrr_builder_build(rinv_);
    stupidedi_rrr_builder_free(rinv_);

    // Now create a new permutation of [nruns] that collapses the runs, such
    // that collapse(i) = rank1(rinv, permute(select1(R, i)))
    collapse = stupidedi_bitstr_alloc_record(nruns, nbits(nruns), NULL);
    for (stupidedi_bit_idx_t k = 0; k < nruns; ++k)
        stupidedi_bitstr_write_record(collapse, k,
                stupidedi_rrr_rank1(rinv,
                    stupidedi_bitstr_read_record(permute,
                        stupidedi_rrr_select1(runs, k))));

    // π, R, π', (π')⁻¹, Rinv

    return NULL;
    */
}

/* */
void
stupidedi_permutation_free(stupidedi_permutation_t* p)
{
    if (p == NULL)
        return;

    if (p->forward != NULL) free(p->forward);
    if (p->reverse != NULL) free(p->reverse);

    free(p);
}

/* */
size_t
stupidedi_permutation_sizeof(const stupidedi_permutation_t* p)
{
    return sizeof(p) + ((stupidedi_permutation_sizeof_bits(p) + 7) >> 3);
}

/* */
uint64_t
stupidedi_permutation_sizeof_bits(const stupidedi_permutation_t* p)
{
    return 0; /* TODO */
}

/* */
uint32_t
stupidedi_permutation_size(const stupidedi_permutation_t* perm)
{
    return 0; /* TODO */
}

/* */
char*
stupidedi_permutation_to_string(const stupidedi_permutation_t* p)
{
    if (p == NULL)
        return strdup("NULL");

    char* str;
    str = NULL;

    return str; /* TODO */
}

/* */
stupidedi_bitstr_t*
stupidedi_permutation_to_bitstr(const stupidedi_permutation_t* p)
{
    assert(p != NULL);
    return stupidedi_bitstr_copy(p->forward);
}

/* */
stupidedi_permutation_idx_t
stupidedi_permutation_apply(const stupidedi_permutation_t* p, stupidedi_permutation_idx_t i)
{
    assert(p != NULL);
    assert(p->forward != NULL);

    return (stupidedi_permutation_idx_t)stupidedi_bitstr_read_record(p->forward, i);
    /*
    stupidedi_bit_idx_t i_;
    i_ = stupidedi_rrr_rank1(R, i);

    uint64_t j_;
    j_ = stupidedi_bitstr_read_record(collapse, i_);

    return stupidedi_rrr_select1(Rinv, j_) + i - stupidedi_rrr_select1(R, i_);
    */
}

/* */
stupidedi_permutation_idx_t
stupidedi_permutation_inverse(const stupidedi_permutation_t* p, stupidedi_permutation_idx_t i)
{
    assert(p != NULL);
    assert(p->reverse != NULL);

    return (stupidedi_permutation_idx_t)stupidedi_bitstring_read_record(p->reverse, i);

    /*
    stupidedi_bit_idx_t i_;
    i_ = stupidedi_rrr_rank1(Rinv, i);

    uint64_t j_;
    j_ = invert(collapse)(i_);

    return stupidedi_rrr_select1(R, j_) + i - stupidedi_rrr_select1(Rinv, i_);
    */
}
#endif
