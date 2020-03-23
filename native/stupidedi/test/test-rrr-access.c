#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitmap.h"

int main(int argc, char **argv) {
    stupidedi_bitmap_t bits;
    stupidedi_rrr_t rrr;

    uint8_t width = 8;
    uint16_t size = 57;

    stupidedi_bitmap_alloc_record(size, width, &bits);
    for (int k = 0; k + 1 < size; k += 2)
        stupidedi_bitmap_write_record(&bits, k, 0xaa & ((1ULL << width) - 1));

    stupidedi_rrr_alloc(&bits, 9, 10, &rrr);
    for (uint32_t k = 0; k < bits.size; ++k) {
        uint8_t r = stupidedi_rrr_access(&rrr, k);
        uint8_t b = stupidedi_bitmap_read(&bits, k, 1);

        //assert(r == b);
        (r == b) ? printf("%u", r) : printf("*");

        if (((k + 1) % width) == 0)
            printf(",");
    }

    printf("\n");
}
