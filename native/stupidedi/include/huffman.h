#ifndef STUPIDEDI_HUFFMAN_H_
#define STUPIDEDI_HUFFMAN_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/packed.h"

enum type { WAVELET, PACKED };

typedef struct stupidedi_huffman_t stupidedi_huffman_t;

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
stupidedi_huffman_length(const stupidedi_huffman_t*);

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
