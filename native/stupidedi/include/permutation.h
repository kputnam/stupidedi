#if FALSE
#ifndef STUPIDEDI_PERMUTATION_H_
#define STUPIDEDI_PERMUTATION_H_

#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/wavelet.h"

typedef struct stupidedi_permutation_t
{
    /* see: J. Ian Munro, Rajeev Raman, Venkatesh Raman, and S. Srinivasa Rao.
     * Succinct representations of permutations. In Proceedings of the 30th
     * International Colloquium on Automata, Languages and Programming (ICALP),
     * volume 2719 of Lecture Notes in Computer Science (LNCS), pages 345–356.
     * Springer-Verlag, 2003.
     *
     * see: Jeremy Barbay, Gonzalo Navarro. Compressed Representations of
     * Permutations, and Applications. In Proc 26th STACS, pages 111-122, 2009.
     */
    stupidedi_bitstring_t* forward;
    stupidedi_bitstring_t* reverse;
} stupidedi_permutation_t;

typedef uint32_t stupidedi_permutation_idx_t;

/* */
stupidedi_permutation_t*
stupidedi_permutation_alloc(stupidedi_bitstring_t*, stupidedi_permutation_t*);

/* */
void
stupidedi_permutation_free(stupidedi_permutation_t*);

/* */
size_t
stupidedi_permutation_sizeof(const stupidedi_permutation_t*);

/* */
uint64_t
stupidedi_permutation_sizeof_bits(const stupidedi_permutation_t*);

/* */
uint32_t
stupidedi_permutation_size(const stupidedi_permutation_t*);

/* */
char*
stupidedi_permutation_to_string(const stupidedi_permutation_t*);

/* */
stupidedi_bitstring_t*
stupidedi_permutation_to_bitstring(const stupidedi_permutation_t*);

/* */
stupidedi_permutation_idx_t
stupidedi_permutation_apply(const stupidedi_permutation_t*, stupidedi_permutation_idx_t i);

/* */
stupidedi_permutation_idx_t
stupidedi_permutation_inverse(const stupidedi_permutation_t*, stupidedi_permutation_idx_t i);

#endif
#endif
