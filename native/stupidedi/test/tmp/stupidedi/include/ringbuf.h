#ifndef STUPIDEDI_RINGBUF_H_
#define STUPIDEDI_RINGBUF_H_

#include <stdint.h>
#include <stddef.h>
#include "packed.h"

/* Mutable circular queue with a fixed capacity. Can also work as a traditional
 * queue that increases capacity as needed (though it does not shrink back down
 * once no longer full).
 *
 * Space complexity:  O(n)
 * Variable overhead: none
 * Constant overhead: 50 bytes */
typedef struct stupidedi_ringbuf_t stupidedi_ringbuf_t;

typedef enum write_mode {
    /* Terminate process with an error */
    FAIL,

    /* Grow size of the buffer */
    EXPAND,

    /* Delete "oldest" item */
    OVERWRITE
} write_mode;

/*****************************************************************************/

/* O(1) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_alloc(void);

/* O(1) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_free(stupidedi_ringbuf_t*);

/* TODO: O(n) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_new(size_t capacity, size_t width, write_mode);

/* TODO: O(n) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_init(stupidedi_ringbuf_t*, size_t, size_t, write_mode);

/* O(1) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_deinit(stupidedi_ringbuf_t*);

/* O(n) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_copy(const stupidedi_ringbuf_t*, stupidedi_ringbuf_t*);

/* O(n) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_resize(stupidedi_ringbuf_t*, size_t capacity);

/*****************************************************************************/

/* O(1) */
size_t
stupidedi_ringbuf_sizeof(const stupidedi_ringbuf_t*);

/* O(1) */
size_t
stupidedi_ringbuf_length(const stupidedi_ringbuf_t*);

/* O(1) */
size_t
stupidedi_ringbuf_capacity(const stupidedi_ringbuf_t*);

/* O(n) */
uint64_t*
stupidedi_ringbuf_to_array(const stupidedi_ringbuf_t*);

/* O(n) */
char*
stupidedi_ringbuf_to_string(const stupidedi_ringbuf_t*);

/*****************************************************************************/

/* O(1) */
stupidedi_ringbuf_t*
stupidedi_ringbuf_clear(stupidedi_ringbuf_t*);

/* O(1) */
bool
stupidedi_ringbuf_empty(stupidedi_ringbuf_t*);

/* O(1) */
uint64_t
stupidedi_ringbuf_peek(stupidedi_ringbuf_t*, size_t);

/* O(1) */
uint64_t
stupidedi_ringbuf_dequeue(stupidedi_ringbuf_t*);

/* O(1), but can be O(n) if write_mode is EXPAND */
size_t
stupidedi_ringbuf_enqueue(stupidedi_ringbuf_t*, uint64_t value);

#endif
