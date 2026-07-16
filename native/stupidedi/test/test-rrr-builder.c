#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"

int
main(int argc, char **argv)
{
    size_t length, width;
    width  = 6;
    length = 15;

    stupidedi_bitstr_t *b;
    b = stupidedi_bitstr_new(length * width);
    for (size_t k = 0; k + width <= stupidedi_bitstr_length(b); k += width)
        stupidedi_bitstr_write(b, k+0, width, (0xaa & ((1 << width) - 1)));

    printf("%s\n\n", stupidedi_bitstr_to_string(b));

    stupidedi_rrr_builder_t *rb;
    rb = stupidedi_rrr_builder_new(15, 64, length * width);

    for (size_t k = 0; k + width <= stupidedi_bitstr_length(b); k += width)
        stupidedi_rrr_builder_write(rb, width, (0xaa & ((1 << width) - 1)));

    stupidedi_rrr_t *rrr;
    rrr = stupidedi_rrr_alloc();
    stupidedi_rrr_builder_to_rrr(rb, rrr);

    printf("%s\n\n", stupidedi_rrr_to_string(rrr));

    for (size_t k = 0; k < stupidedi_bitstr_length(b); ++k)
    {
        uint8_t x = stupidedi_rrr_access(rrr, k);
        uint8_t y = stupidedi_bitstr_read(b, k, 1);

        (x == y) ? printf("%u", x) : printf("*");

        if (((k + 1) % width) == 0 && k + 1 < stupidedi_bitstr_length(b))
            printf(",");
    }

    printf("\n");

    stupidedi_rrr_free(rrr);
    stupidedi_rrr_builder_free(rb);
    stupidedi_bitstr_free(b);
}
