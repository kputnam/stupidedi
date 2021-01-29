#ifndef STUPIDEDI_HUFFMAN_H_
#define STUPIDEDI_HUFFMAN_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/packed.h"

/* Represents a codebook that assigns a prefix-free variable-length codeword
 * to each symbol [0,σ-1). The numbering scheme is specifically designed for
 * compatibility with wavelet matrices.
 *
 * When the codebook itself is not compressed
 *   Space complexity:  O(σL)
 *   Variable overhead: O(σL)
 *   Constant overhead: 26 + MAX(24,40) + 5*33 = 231 bytes
 *
 * When the codebook itself is compressed
 *   Space complexity:  TODO
 *   Variable overhead: TODO
 *   Constant overhead: 26 + MAX(24,40) + 2*33 + 1*527 = 659 bytes */
typedef struct stupidedi_huffman_t stupidedi_huffman_t;

enum type { WAVELET, PACKED };

/*****************************************************************************/

stupidedi_huffman_t*
stupidedi_huffman_alloc(void);

stupidedi_huffman_t*
stupidedi_huffman_free(stupidedi_huffman_t*);

stupidedi_huffman_t*
stupidedi_huffman_new(uint8_t, stupidedi_packed_t*, enum type);

stupidedi_huffman_t*
stupidedi_huffman_init(stupidedi_huffman_t*, uint8_t, stupidedi_packed_t*, enum type);

stupidedi_huffman_t*
stupidedi_huffman_deinit(stupidedi_huffman_t*);

/*****************************************************************************/

size_t
stupidedi_huffman_sizeof(const stupidedi_huffman_t*);

size_t
stupidedi_huffman_count(const stupidedi_huffman_t*);

char*
stupidedi_huffman_to_string(const stupidedi_huffman_t*);

/*****************************************************************************/

uint8_t
stupidedi_huffman_max_codeword_length(const stupidedi_huffman_t*);

uint8_t
stupidedi_huffman_encode(const stupidedi_huffman_t*, size_t, uint64_t*);

uint8_t
stupidedi_huffman_decode(const stupidedi_huffman_t*, uint64_t, uint8_t, size_t*);

#endif
