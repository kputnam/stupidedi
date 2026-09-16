#ifndef STUPIDEDI_INTMAP_H_
#define STUPIDEDI_INTMAP_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include "stupidedi/include/intmap.h"

typedef struct stupidedi_intmap_t stupidedi_intmap_t;

/*****************************************************************************/

stupidedi_intmap_t*
stupidedi_intmap_alloc(void);

stupidedi_intmap_t*
stupidedi_intmap_free(stupidedi_intmap_t*);

stupidedi_intmap_t*
stupidedi_intmap_new(size_t);

stupidedi_intmap_t*
stupidedi_intmap_init(stupidedi_intmap_t*, size_t);

stupidedi_intmap_t*
stupidedi_intmap_deinit(stupidedi_intmap_t*);

stupidedi_intmap_t*
stupidedi_intmap_copy(stupidedi_intmap_t*);

/*****************************************************************************/

size_t
stupidedi_intmap_sizeof(const stupidedi_intmap_t*);

size_t
stupidedi_intmap_length(const stupidedi_intmap_t*);

/*****************************************************************************/

uint64_t
stupidedi_intmap_read(const stupidedi_intmap_t*, size_t);

uint64_t
stupidedi_intmap_write(const stupidedi_intmap_t*, size_t, uint64_t);

size_t
stupidedi_intmap_nth_key(const stupidedi_intmap_t*, size_t);

#endif
