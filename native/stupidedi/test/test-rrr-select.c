#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitstr.h"

/* Naive O(n) reference matching select0/1's documented contract: the length
 * of the shortest prefix containing r 0-bits (or 1-bits), i.e. one past the
 * r-th occurrence's position, or SIZE_MAX if there's no such prefix. */
static size_t
naive_select(const stupidedi_bitstr_t* b, int bit, size_t r)
{
    size_t count = 0;
    for (size_t k = 0; k < stupidedi_bitstr_length(b); ++k)
    {
        if ((int)stupidedi_bitstr_read(b, k, 1) == bit)
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
    stupidedi_bitstr_t *b;
    stupidedi_rrr_t *rrr;

    size_t length, width;
    width  = 8;
    length = 8;

    uint64_t value = 0xaaaaaaaaaaaaaaaa;
    value         &= (1ULL << width) - 1;

    b = stupidedi_bitstr_new(length * width);
    for (size_t k = 1; k + width <= stupidedi_bitstr_length(b); k += width)
        stupidedi_bitstr_write(b, k, width, value);

    rrr = stupidedi_rrr_new(b, 5, 8);
    size_t total_rank = stupidedi_rrr_rank1(rrr, stupidedi_rrr_length(rrr));

    for (size_t k = 0; k < total_rank + 4; ++k)
    {
        size_t expect, got;
        expect = naive_select(b, 1, k);
        got    = stupidedi_rrr_select1(rrr, k);
        (expect == got) ?
            printf("select1(%zu)=%zu\n", k, got) :
            printf("select1(%zu): expect=%zu got=%zu ***MISMATCH***\n", k, expect, got);
    }

    printf("\n");
    for (size_t k = 0; k < stupidedi_rrr_length(rrr) - total_rank + 4; ++k)
    {
        size_t expect, got;
        expect = naive_select(b, 0, k);
        got    = stupidedi_rrr_select0(rrr, k);
        (expect == got) ?
            printf("select0(%zu)=%zu\n", k, got) :
            printf("select0(%zu): expect=%zu got=%zu ***MISMATCH***\n", k, expect, got);
    }

    printf("%s\n\n", stupidedi_bitstr_to_string(b));

    stupidedi_rrr_free(rrr);
    stupidedi_bitstr_free(b);
}
