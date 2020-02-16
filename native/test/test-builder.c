#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "rrr.h"
#include "bit_vector.h"

int main(int argc, char **argv) {
    uint8_t width = 6;
    uint16_t size = 15;

    bit_vector_t bits;
    bit_vector_alloc_record(size, width, &bits);
    for (int k = 0; k < size; k += 2) {
        bit_vector_write_record(&bits, k+0, 0xaa & ((1 << width) - 1));
        if (k + 1 < size) bit_vector_write_record(&bits, k+1, 0x00);
    }
    bit_vector_print(&bits); printf("\n\n");

    rrr_builder_t builder;
    rrr_builder_alloc(15, 64, width*size, &builder, NULL);
    for (int k = 0; k < size; k += 2) {
        rrr_builder_append(&builder, width, 0xaa & ((1 << width) - 1));
        if (k + 1 < size) rrr_builder_append(&builder, width, 0x00);
    }

    rrr_t* rrr;
    rrr = rrr_builder_finish(&builder);
    rrr_print(rrr); printf("\n\n");

    for (uint32_t k = 0; k < bits.size; k += 1) {
        uint8_t r = rrr_access(rrr, k);
        uint8_t b = bit_vector_read(&bits, k, 1);

        (r == b) ? printf("%u", r) : printf("*");
        if (((k + 1) % width) == 0 && k + 1 < bits.size)
            printf(",");
    }

    printf("\n");
}
