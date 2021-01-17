#ifndef STUPIDEDI_RRR_H_
#define STUPIDEDI_RRR_H_

#include <stdint.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/packed.h"

#define STUPIDEDI_RRR_BLOCK_SIZE_MIN 2
#define STUPIDEDI_RRR_BLOCK_SIZE_MAX 64

#define STUPIDEDI_RRR_MARKER_SIZE_MIN 3
#define STUPIDEDI_RRR_MARKER_SIZE_MAX 2048

typedef struct stupidedi_rrr_t stupidedi_rrr_t;

/*****************************************************************************/

stupidedi_rrr_t*
stupidedi_rrr_alloc(void);

stupidedi_rrr_t*
stupidedi_rrr_dealloc(stupidedi_rrr_t*);

stupidedi_rrr_t*
stupidedi_rrr_new(const stupidedi_bitstr_t*, uint8_t block_size, uint16_t marker_size);

stupidedi_rrr_t*
stupidedi_rrr_init(stupidedi_rrr_t*, const stupidedi_bitstr_t*, uint8_t block_size, uint16_t marker_size);

stupidedi_rrr_t*
stupidedi_rrr_deinit(stupidedi_rrr_t*);

stupidedi_rrr_t*
stupidedi_rrr_copy(stupidedi_rrr_t*);

/*****************************************************************************/

size_t
stupidedi_rrr_sizeof(const stupidedi_rrr_t*);

size_t
stupidedi_rrr_length(const stupidedi_rrr_t*);

char*
stupidedi_rrr_to_string(const stupidedi_rrr_t*);

stupidedi_bitstr_t*
stupidedi_rrr_to_bitstr(const stupidedi_rrr_t*, stupidedi_bitstr_t*);

/*****************************************************************************/

uint8_t
stupidedi_rrr_access(const stupidedi_rrr_t*, size_t);

size_t
stupidedi_rrr_rank0(const stupidedi_rrr_t*, size_t i);

size_t
stupidedi_rrr_rank1(const stupidedi_rrr_t*, size_t i);

size_t
stupidedi_rrr_select0(const stupidedi_rrr_t*, size_t r);

size_t
stupidedi_rrr_select1(const stupidedi_rrr_t*, size_t r);

/* Return position of previous occurrence of 0-bit from position i. */
size_t
stupidedi_rrr_prev0(const stupidedi_rrr_t*, size_t i);

/* Return position of previous occurrence of 0-bit from position i. */
size_t
stupidedi_rrr_prev1(const stupidedi_rrr_t*, size_t i);

/* Return position of next occurrence of 1-bit from position i. */
size_t
stupidedi_rrr_next0(const stupidedi_rrr_t*, size_t i);

/* Return position of next occurrence of 1-bit position i. */
size_t
stupidedi_rrr_next1(const stupidedi_rrr_t*, size_t i);

/*****************************************************************************/

typedef struct stupidedi_rrr_builder_t
{
    stupidedi_rrr_t* rrr;
    uint8_t  offset_nbits_max, block_need;
    uint16_t marker_need;
    size_t written, class_at, offset_at, marker_at;
    uint64_t block;
    bool is_done;
} stupidedi_rrr_builder_t;

/*****************************************************************************/

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_alloc(void);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_new(uint8_t block_size, uint16_t marker_size, size_t length);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_init(stupidedi_rrr_builder_t*, uint8_t block_size, uint16_t marker_size, size_t length);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_deinit(stupidedi_rrr_builder_t*);

stupidedi_rrr_builder_t*
stupidedi_rrr_builder_dealloc(stupidedi_rrr_builder_t*);

/*****************************************************************************/

size_t
stupidedi_rrr_builder_sizeof(const stupidedi_rrr_builder_t*);

size_t
stupidedi_rrr_builder_length(const stupidedi_rrr_builder_t*);

/*****************************************************************************/

size_t
stupidedi_rrr_builder_written(const stupidedi_rrr_builder_t*);

size_t
stupidedi_rrr_builder_write(stupidedi_rrr_builder_t*, uint8_t width, uint64_t value);

stupidedi_rrr_t*
stupidedi_rrr_builder_to_rrr(stupidedi_rrr_builder_t*, stupidedi_rrr_t*);

#endif
