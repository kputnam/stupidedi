#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"

int
main(int argc, char **argv)
{
    stupidedi_bitstr_t b;
    stupidedi_rrr_t rrr;

    size_t length, width;
    width  = 8;
    length = 57;

    stupidedi_bitstr_init(&b, length * width);
    for (size_t k = 0; k < stupidedi_bitstr_length(&b); k += width)
        stupidedi_bitstr_write(&b, k, width, (0xaa & ((1ULL << width) - 1)));

    stupidedi_rrr_init(&rrr, &b, 9, 10);
    for (size_t k = 0; k < stupidedi_bitstr_length(&b); ++k)
    {
        bool x, y;
        x = (bool)stupidedi_rrr_access(&rrr, k);
        y = (bool)stupidedi_bitstr_read(&b, k, 1);

        //assert(r == b);
        (x == y) ? printf("%u", x) : printf("*");

        if (((k + 1) % width) == 0)
            printf(",");
    }

    printf("\n");
}
