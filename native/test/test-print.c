#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "rrr.h"
#include "bit_vector.h"

int main(int argc, char **argv) {
    bit_vector_t bits;
    rrr_t rrr;

    uint8_t width = 8;
    uint16_t size = 57;

    bit_vector_alloc_record(size, width, &bits);
    for (int k = 0; k + 1 < size; k += 2)
        bit_vector_write_record(&bits, k, 0xaa & ((1ULL << width) - 1));
    printf("%s\n\n", bit_vector_to_string_record(&bits));

    rrr_alloc(&bits, 9, 10, &rrr);
    printf("%s\n", rrr_to_string(&rrr));

    printf("\n");
}
