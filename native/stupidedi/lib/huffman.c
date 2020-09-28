#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "stupidedi/include/intmap.h"
#include "stupidedi/include/packed.h"
#include "stupidedi/include/huffman.h"

uint64_t* argsort(const uint64_t*, size_t);

stupidedi_huffman_t*
stupidedi_huffman_alloc(stupidedi_intmap_t* m)
{
    return stupidedi_huffman_init(malloc(sizeof(stupidedi_huffman_t)), m);
}

stupidedi_huffman_t*
stupidedi_huffman_dealloc(stupidedi_huffman_t* h)
{
    if (h != NULL)
        stupidedi_huffman_deinit(h);
    return NULL;
}

stupidedi_huffman_t*
stupidedi_huffman_init(stupidedi_huffman_t* h, stupidedi_intmap_t* m)
{
    /* Larmore, Lawrence L., and Daniel S. Hirschberg. “A Fast Algorithm for
     * Optimal Length-Limited Huffman Codes.” Journal of the ACM (JACM), vol.
     * 37, no. 3, 1990, pp. 464–473., doi:10.1145/79147.79150
     *
     * We can fit a 58-bit maximum length code along with its 6-bit length all
     * into a 64-bit word. Packing a variable-length code into a fixed-length
     * word might seem to defeat the purpose, but this is only to store the
     * code book, not the encoded sequence.
     *
     * Note UTF-8 contains 1,111,998 distinct valid codepoints which can be
     * enumerated in 21 bits, so we 
     */

    size_t nsymbols;
    nsymbols = stupidedi_intmap_length(m);

    /* SOLUTION(I, X):
     *      for all d
     *          L[d] <- sort({i | i ∈ I, width(i) = d} by weight(i))
     *
     *      S <- { }
     *
     *      while X > 0:
     *          if I == { }:
     *              return { }
     *
     *          m <- smallest 1-bit in X
     *          d <- the minimum such than L[d] is not empty
     *          r <- pow(2, d)
     *
     *          if r > m:
     *              return { }
     *
     *          elsif r == m:
     *              q <- delete smallest item from L[d]
     *              S <- insert q into S
     *              X <- X - m
     *
     *          P[d+1] <- PACKAGE(L[d])
     *          discard L[d]
     *          L[d+1] <- MERGE(P[d+1], L[d+1])
     *
     *      return S
     *
     * PACKAGE(L): -- O(n)
     *   for k = 0.. floor(|L| / 2):
     *       P[k] = combine(L[2k], L[2k+1])
     *   return P
     *
     * MERGE(P, L): -- O(n)
     *   merge sort
     */
}

stupidedi_huffman_t*
stupidedi_huffman_deinit(stupidedi_huffman_t* h)
{
    return h;
}

/*****************************************************************************/

size_t
stupidedi_huffman_sizeof(const stupidedi_huffman_t* h)
{
    return 0;
}

size_t
stupidedi_huffman_length(const stupidedi_huffman_t* h)
{
    assert(h != NULL);
    return 0;
}

char*
stupidedi_huffman_to_string(const stupidedi_huffman_t* h)
{
    if (h == NULL)
        return strdup("NULL");

    return NULL;
}

/*****************************************************************************/

void
stupidedi_huffman_encode(stupidedi_huffman_t*, uint64_t);

void
stupidedi_huffman_decode(stupidedi_huffman_t*, uint64_t);
