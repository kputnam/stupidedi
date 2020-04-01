#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/wavelet.h"

int
main(int argc, char **argv)
{
    stupidedi_packed_t a;

    size_t length, width;
    length = 14;
    width  = ceil(log2(length * 2));

    stupidedi_packed_init(&a, 10, 3);
    stupidedi_packed_write(&a, 0, 1);
    stupidedi_packed_write(&a, 1, 0);
    stupidedi_packed_write(&a, 2, 3);
    stupidedi_packed_write(&a, 3, 2);
    stupidedi_packed_write(&a, 4, 5);
    stupidedi_packed_write(&a, 5, 3);
    stupidedi_packed_write(&a, 6, 4);
    stupidedi_packed_write(&a, 7, 0);
    stupidedi_packed_write(&a, 8, 3);
    stupidedi_packed_write(&a, 9, 1);

}
