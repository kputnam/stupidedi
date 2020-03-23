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
    printf("%s\n\n", stupidedi_bitmap_to_string_record(&bits));

    stupidedi_rrr_alloc(&bits, 9, 10, &rrr);
    printf("%s\n", stupidedi_rrr_to_string(&rrr));
    printf("%s\n", stupidedi_bitmap_to_string(stupidedi_rrr_to_bitmap(&rrr)));

    printf("\n");
}
