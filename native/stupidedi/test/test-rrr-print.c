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

    uint8_t width   = 8;
    uint16_t length = 57;

    stupidedi_bitstr_init(length*width, &b);
    for (size_t k = 0; k + width <= stupidedi_bitstr_length(&b); k += width)
        stupidedi_bitstr_write(&b, k, width, (0xaa & ((1ULL << width) - 1)));

    printf("%s\n\n", stupidedi_bitstr_to_string(&b));

    stupidedi_rrr_init(&b, 9, 10, &rrr);
    printf("%s\n", stupidedi_rrr_to_string(&rrr));
    printf("%s\n", stupidedi_bitstr_to_string(stupidedi_rrr_to_bitstr(&rrr, NULL)));

    printf("\n");
}
