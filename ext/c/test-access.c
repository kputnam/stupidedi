#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#define ALLOC(type) ((type*)malloc(sizeof(type)))
#define ALLOC_N(type,n) ((type*)malloc(sizeof(type) * (size_t)(n)))
#define REALLOC_N(ptr,type,n) ((ptr)=(type*)realloc(ptr, sizeof(type) * (size_t)(n)))
#define FREE(ptr) free(ptr)

#include "rrr.h"
#include "bit_vector.h"

int main(int argc, char **argv) {
    bit_vector_t bits;
    rrr_t rrr;

    uint8_t width = 8;
    uint16_t lenth = 57;

    bit_vector_alloc_record(lenth, width, &bits);
    for (int k = 0; k < lenth; k += 2)
        bit_vector_write_record(&bits, k, 0xaa);

    rrr_alloc(&bits, 9, 10, &rrr);
    for (uint32_t k = 0; k < bits.nbits; k += 1) {
        uint8_t r = rrr_access(&rrr, k);
        uint8_t b = bit_vector_read(&bits, k, 1);

        //assert(r == b);
        (r == b) ? printf("%u", r) : printf("*");

        if (((k + 1) % width) == 0)
            printf(",");
    }

    printf("\n");
}
