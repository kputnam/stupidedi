#ifndef STUPIDEDI_RINGBUF_H_
#define STUPIDEDI_RINGBUF_H_

#include <stdint.h>
#include <stddef.h>
#include "packed.h"

typedef enum write_mode {
    OVERWRITE,
    EXPAND,
    FAIL
} write_mode;

typedef struct stupidedi_ringbuf_t stupidedi_ringbuf_t;

/*****************************************************************************/

stupidedi_ringbuf_t*
stupidedi_ringbuf_alloc(void);

stupidedi_ringbuf_t*
stupidedi_ringbuf_free(stupidedi_ringbuf_t*);

stupidedi_ringbuf_t*
stupidedi_ringbuf_new(size_t capacity, size_t width, write_mode);

stupidedi_ringbuf_t*
stupidedi_ringbuf_init(stupidedi_ringbuf_t*, size_t, size_t, write_mode);

stupidedi_ringbuf_t*
stupidedi_ringbuf_deinit(stupidedi_ringbuf_t*);

stupidedi_ringbuf_t*
stupidedi_ringbuf_copy(const stupidedi_ringbuf_t*, stupidedi_ringbuf_t*);

stupidedi_ringbuf_t*
stupidedi_ringbuf_resize(stupidedi_ringbuf_t*, size_t capacity);

/*****************************************************************************/

size_t
stupidedi_ringbuf_sizeof(const stupidedi_ringbuf_t*);

size_t
stupidedi_ringbuf_length(const stupidedi_ringbuf_t*);

size_t
stupidedi_ringbuf_capacity(const stupidedi_ringbuf_t*);

uint64_t*
stupidedi_ringbuf_to_array(const stupidedi_ringbuf_t*);

char*
stupidedi_ringbuf_to_string(const stupidedi_ringbuf_t*);

/*****************************************************************************/

stupidedi_ringbuf_t*
stupidedi_ringbuf_clear(stupidedi_ringbuf_t*);

bool
stupidedi_ringbuf_empty(stupidedi_ringbuf_t*);

uint64_t
stupidedi_ringbuf_peek(stupidedi_ringbuf_t*, size_t);

uint64_t
stupidedi_ringbuf_dequeue(stupidedi_ringbuf_t*);

size_t
stupidedi_ringbuf_enqueue(stupidedi_ringbuf_t*, uint64_t value);

#endif
