#ifndef STUPIDEDI_BIT_VECTOR_H_
#define STUPIDEDI_BIT_VECTOR_H_

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

/* A bit vector that supports fixed and variable width read/write */
typedef struct bit_vector_t {
    uint64_t* data; /* sequence of bits */
    uint32_t size; /* total number of bits */
    uint16_t width;
} bit_vector_t;

#define BIT_VECTOR_WIDTH_MIN 1
#define BIT_VECTOR_WIDTH_MAX 64

typedef uint32_t bit_idx_t;
#define BIT_IDX_MIN 0
#define BIT_IDX_MAX UINT32_MAX

void bit_vector_free(bit_vector_t*);
void bit_vector_print(const bit_vector_t*);

bit_idx_t bit_vector_size(const bit_vector_t*);
size_t bit_vector_sizeof(const bit_vector_t*);
uint64_t bit_vector_size_bits(const bit_vector_t*);

/* These operations are for operating on variable-width records */
bit_vector_t* bit_vector_alloc(bit_idx_t, bit_vector_t*);
void bit_vector_resize(bit_vector_t*, bit_idx_t);
void bit_vector_set(const bit_vector_t*, bit_idx_t);
bool bit_vector_test(const bit_vector_t*, bit_idx_t);
void bit_vector_clear(const bit_vector_t*, bit_idx_t);
uint64_t bit_vector_read(const bit_vector_t*, bit_idx_t, uint8_t);
bit_idx_t bit_vector_write(const bit_vector_t*, bit_idx_t, uint8_t, uint64_t);

/* These operations are for operating on fixed-width records */
bit_vector_t* bit_vector_alloc_record(bit_idx_t, uint16_t, bit_vector_t*);
void bit_vector_resize_record(bit_vector_t*, bit_idx_t);
uint64_t bit_vector_read_record(const bit_vector_t*, bit_idx_t);
uint32_t bit_vector_write_record(const bit_vector_t*, bit_idx_t, uint64_t);

#endif
