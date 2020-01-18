#include <stdbool.h>
#include <stdint.h>

#ifndef STUPIDEDI_BIT_VECTOR_H_
#define STUPIDEDI_BIT_VECTOR_H_

/* A bit vector that supports fixed and variable width read/write */
struct bit_vector_t {
    uint64_t *data; /* Sequence of bits */
    uint32_t size;  /* Total number of bits */
    uint16_t record_nbits;
};

typedef struct bit_vector_t bit_vector_t;
typedef uint32_t bit_idx_t;

void bit_vector_free(bit_vector_t* bits);

/* These operations are for random reading/writing */
bit_vector_t* bit_vector_alloc(uint32_t);
void bit_vector_resize(bit_vector_t*, uint32_t);
void bit_vector_set(bit_vector_t*, bit_idx_t);
bool bit_vector_test(bit_vector_t*, bit_idx_t);
void bit_vector_clear(bit_vector_t*, bit_idx_t);
uint64_t bit_vector_read(bit_vector_t*, bit_idx_t, uint8_t);
bit_idx_t bit_vector_write(bit_vector_t*, bit_idx_t, uint8_t, uint64_t);

/* These operations are for reading/writing fixed-width records */
bit_vector_t* bit_vector_alloc_record(uint32_t, uint16_t);
void bit_vector_resize_record(bit_vector_t*, uint32_t);
uint64_t bit_vector_read_record(bit_vector_t*, bit_idx_t);
uint32_t bit_vector_write_record(bit_vector_t*, bit_idx_t, uint64_t);

#endif
