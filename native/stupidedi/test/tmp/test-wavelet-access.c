#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/wavelet.h"

int
main(int argc, char **argv)
{
    stupidedi_packed_t *a;

    a = stupidedi_packed_new(10, 3);
    stupidedi_packed_write(a, 0, 1);
    stupidedi_packed_write(a, 1, 0);
    stupidedi_packed_write(a, 2, 3);
    stupidedi_packed_write(a, 3, 2);
    stupidedi_packed_write(a, 4, 5);
    stupidedi_packed_write(a, 5, 3);
    stupidedi_packed_write(a, 6, 4);
    stupidedi_packed_write(a, 7, 0);
    stupidedi_packed_write(a, 8, 3);
    stupidedi_packed_write(a, 9, 1);

    /* NULL codec means fixed-width encoding, width inferred from `a` */
    stupidedi_wavelet_t* w;
    w = stupidedi_wavelet_new(a, NULL);
    printf("OK\n");

    for (size_t k = 0; k < stupidedi_packed_length(a); ++k)
    {
        uint64_t ab, aw;
        ab = stupidedi_packed_read(a, k);
        aw = stupidedi_wavelet_access(w, k);

        //assert(r == b);
        (aw == ab) ? printf("%llu,\n", aw) : printf("b:%llu w:%llu,\n", ab, aw);
    }

    printf("\n");

    stupidedi_wavelet_free(w);
    stupidedi_packed_free(a);
}
