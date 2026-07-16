#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"

int
main(int argc, char **argv)
{
    stupidedi_bitstr_t *b;
    stupidedi_rrr_t *rrr;

    size_t length, width;
    width  = 8;
    length = 57;

    b = stupidedi_bitstr_new(length * width);
    for (size_t k = 0; k + width <= stupidedi_bitstr_length(b); k += width)
        stupidedi_bitstr_write(b, k, width, (0xaa & ((1ULL << width) - 1)));

    printf("%s\n\n", stupidedi_bitstr_to_string(b));

    rrr = stupidedi_rrr_new(b, 9, 10);
    printf("%s\n", stupidedi_rrr_to_string(rrr));

    stupidedi_bitstr_t *b2 = stupidedi_rrr_to_bitstr(rrr, NULL);
    printf("%s\n", stupidedi_bitstr_to_string(b2));

    printf("\n");

    stupidedi_bitstr_free(b2);
    stupidedi_rrr_free(rrr);
    stupidedi_bitstr_free(b);
}
