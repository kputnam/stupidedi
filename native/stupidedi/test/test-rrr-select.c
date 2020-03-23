#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "stupidedi/include/rrr.h"
#include "stupidedi/include/bitmap.h"

int main(int argc, char **argv)
{
    stupidedi_bitmap_t bits;
    stupidedi_rrr_t rrr;

    uint8_t  width = 8;
    uint16_t size  = 8;

    uint64_t value = 0xaaaaaaaaaaaaaaaa;
    value         &= (1ULL << width) - 1;

    stupidedi_bitmap_alloc_record(size, width, &bits);
    for (int k = 1; k < size; k += 2)
        stupidedi_bitmap_write_record(&bits, k, value);

    stupidedi_rrr_alloc(&bits, 5, 8, &rrr);
    for (uint32_t k = 0; k < rrr.rank + 4; ++k)
            printf("select₁(%u)=%u\n", k, stupidedi_rrr_select1(&rrr, k));
    printf("\n\n");

    for (uint32_t k = 0; k < rrr.size - rrr.rank + 4; ++k)
            printf("select₀(%u)=%u\n", k, stupidedi_rrr_select0(&rrr, k));
    printf("%s\n\n", stupidedi_bitmap_to_string(&bits));

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

