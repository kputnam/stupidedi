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
    length = 8;

    uint64_t value = 0xaaaaaaaaaaaaaaaa;
    value         &= (1ULL << width) - 1;

    stupidedi_bitstr_init(&b, length * width);
    for (size_t k = 1; k + width <= stupidedi_bitstr_length(&b); k += width)
        stupidedi_bitstr_write(&b, k, width, value);

    stupidedi_rrr_init(&rrr, &b, 5, 8);
    for (size_t k = 0; k < rrr.rank + 4; ++k)
            printf("select₁(%zu)=%zu\n", k, stupidedi_rrr_select1(&rrr, k));

    printf("\n");
    for (size_t k = 0; k < stupidedi_rrr_length(&rrr) - rrr.rank + 4; ++k)
            printf("select₀(%zu)=%zu\n", k, stupidedi_rrr_select0(&rrr, k));

    printf("%s\n\n", stupidedi_bitstr_to_string(&b));

    /*
     *                                                                        *
    xs = "00000000,01010101,00000000,01010101,00000000,01010101,00000000,01010101"
          =====......=====......======.....======......=====......=====......====
            0     1    2     3     4     5    6     7    8    9     10   11   12
        K   0     1    2     1     0     3    1     0    2    2     0    2    2
        R         0        4        4        8        8        12       12       16


    class Array;def cumsum; s=0; self.map{|x| s+=x }; end;end
    xs = "00000000,01010101,00000000,01010101,00000000,01010101,00000000,01010101"
    bs = xs.gsub(",","").scan(/.{1,5}/)
    bx = bs.map{|b| Integer(b.reverse, 2) }

    # Classes, ranks
    cs = bs.map{|b| b.count("1") }
    rs = cs.cumsum

    # Widths
    ws = cs.map{|r| (r.zero? && 0) || Math.log2([0,1+7,7+21,21+35,35+35,35+21,21+7,7+1][r]).ceil }
    os = ws.cumsum

    # Markers
    mb = xs.gsub(",","").scan(/.{1,8}/)
    ms = mb.map{|b| b.count("1") }.cumsum
    */
}

