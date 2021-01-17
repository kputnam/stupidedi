#ifndef STUPIDEDI_BITSTR_H_
#define STUPIDEDI_BITSTR_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

typedef struct stupidedi_bitstr_t stupidedi_bitstr_t;

/*****************************************************************************/

stupidedi_bitstr_t*
stupidedi_bitstr_alloc(void);

stupidedi_bitstr_t*
stupidedi_bitstr_dealloc(stupidedi_bitstr_t*);

stupidedi_bitstr_t*
stupidedi_bitstr_new(size_t);

stupidedi_bitstr_t*
stupidedi_bitstr_init(stupidedi_bitstr_t*, size_t);

stupidedi_bitstr_t*
stupidedi_bitstr_deinit(stupidedi_bitstr_t*);

stupidedi_bitstr_t*
stupidedi_bitstr_copy(const stupidedi_bitstr_t*, stupidedi_bitstr_t*);

stupidedi_bitstr_t*
stupidedi_bitstr_resize(stupidedi_bitstr_t*, size_t);

/*****************************************************************************/

size_t
stupidedi_bitstr_sizeof(const stupidedi_bitstr_t*);

size_t
stupidedi_bitstr_length(const stupidedi_bitstr_t*);

char*
stupidedi_bitstr_to_string(const stupidedi_bitstr_t*);

stupidedi_bitstr_t*
stupidedi_bitstr_reverse(stupidedi_bitstr_t*);

/*****************************************************************************/

void
stupidedi_bitstr_set(const stupidedi_bitstr_t*, size_t);

bool
stupidedi_bitstr_test(const stupidedi_bitstr_t*, size_t);

void
stupidedi_bitstr_clear(const stupidedi_bitstr_t*, size_t);

uint64_t
stupidedi_bitstr_read(const stupidedi_bitstr_t*, size_t, uint8_t width);

size_t
stupidedi_bitstr_write(const stupidedi_bitstr_t*, size_t, uint8_t width, uint64_t value);

#endif
