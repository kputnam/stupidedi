#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <math.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/wavelet.h"

/* Naive O(n) reference matching select(S,r,c)'s documented contract: the
 * length of the shortest prefix containing r occurrences of c (i.e. one
 * past the r-th occurrence's position), or n if there is no such prefix. */
static size_t
naive_select(const stupidedi_packed_t* a, uint64_t c, size_t r)
{
    size_t count = 0;
    for (size_t k = 0; k < stupidedi_packed_length(a); ++k)
    {
        if (stupidedi_packed_read(a, k) == c)
        {
            ++count;
            if (count == r)
                return k + 1;
        }
    }
    return SIZE_MAX;
}

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
    stupidedi_wavelet_t *w;
    w = stupidedi_wavelet_new(a, NULL);
    printf("OK\n");

    for (uint64_t c = 0; c <= 5; ++c)
    {
        printf("\n%llu ==============================================\n", (unsigned long long)c);

        for (size_t r = 1; r <= stupidedi_packed_length(a); ++r)
        {
            size_t expect, got;
            expect = naive_select(a, c, r);
            got    = stupidedi_wavelet_select(w, r, c);

            (expect == got) ?
                printf("select(%llu, %zu) = %zu\n", (unsigned long long)c, r, got) :
                printf("select(%llu, %zu): expect=%zu got=%zu ***MISMATCH***\n", (unsigned long long)c, r, expect, got);
        }
    }

    printf("\n");

    stupidedi_wavelet_free(w);
    stupidedi_packed_free(a);
}
