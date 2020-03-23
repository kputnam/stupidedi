#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitmap.h"

int main(int argc, char **argv) {
    uint8_t width = 6;
    uint16_t size = 15;

    stupidedi_bitmap_t bits;
    stupidedi_bitmap_alloc_record(size, width, &bits);
    for (int k = 0; k < size; k += 2) {
        stupidedi_bitmap_write_record(&bits, k+0, 0xaa & ((1 << width) - 1));
        if (k + 1 < size) stupidedi_bitmap_write_record(&bits, k+1, 0x00);
    }

    /* NOTE: Should free the pointer returned by stupidedi_bitmap_to_string. */
    printf("%s\n\n", stupidedi_bitmap_to_string(&bits));

    stupidedi_rrr_builder_t builder;
    stupidedi_rrr_builder_alloc(15, 64, width * size, &builder, NULL);

    for (int k = 0; k < size; k += 2) {
        stupidedi_rrr_builder_append(&builder, width, 0xaa & ((1 << width) - 1));
        if (k + 1 < size) stupidedi_rrr_builder_append(&builder, width, 0x00);
    }

    stupidedi_rrr_t* rrr;
    rrr = stupidedi_rrr_builder_build(&builder);

    /* NOTE: Should free the pointer returned by stupidedi_rrr_to_string. */
    printf("%s\n\n", stupidedi_rrr_to_string(rrr));

    for (uint32_t k = 0; k < bits.size; k += 1) {
        uint8_t r = stupidedi_rrr_access(rrr, k);
        uint8_t b = stupidedi_bitmap_read(&bits, k, 1);

        (r == b) ? printf("%u", r) : printf("*");
        if (((k + 1) % width) == 0 && k + 1 < bits.size)
            printf(",");
    }

    printf("\n");
}
