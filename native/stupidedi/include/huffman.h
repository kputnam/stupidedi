#ifndef STUPIDEDI_HUFFMAN_H_
#define STUPIDEDI_HUFFMAN_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/intmap.h"

typedef struct stupidedi_huffman_t
{
} stupidedi_huffman_t;

/*****************************************************************************/

stupidedi_huffman_t*
stupidedi_huffman_alloc(stupidedi_intmap_t*);

stupidedi_huffman_t*
stupidedi_huffman_dealloc(stupidedi_huffman_t*);

stupidedi_huffman_t*
stupidedi_huffman_init(stupidedi_huffman_t*, stupidedi_intmap_t*);

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

void
stupidedi_huffman_encode(stupidedi_huffman_t*, uint64_t);

void
stupidedi_huffman_decode(stupidedi_huffman_t*, uint64_t);

#endif
