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
    value          = -1;
    value         &= (1ULL << width) - 1;

    /*
     *           4         6         8        12        13        16
     *         <-0       <-1       <-2       <-3       <-4       <-5    MARKERS
     *  ================================================================~~~~~~~~
     *  0101010100000000010101010000000001010101000000000101010100000000
     *  ............................................................
     *   <0 <1 <2 <3 <4 <5 <6 <7 <8 <9 <0 <1 <2  3  4  5  6  7  8  9  0
     *                                  1  1  1  1  1  1  1  1  1  1  2
     *
     *        <-0      <-1      <-2      <-3      <-4      <-5      <-6
     *          4        5        8       10       12       15       16
     */

    stupidedi_bitmap_alloc_record(size, width, &bits);
    for (int k = 0; k < size; k += 1)
        stupidedi_bitmap_write_record(&bits, k, value);

    stupidedi_rrr_alloc(&bits, 13, 88, &rrr);
    for (uint32_t k = 0; k <= bits.size + 3; k += 1) {
        if (k < bits.size)
            printf("%u: %llu rank₁(%u)=%u rank₀(%u)=%u\n",
                    k, stupidedi_bitmap_read(&bits, k, 1),
                    k, stupidedi_rrr_rank1(&rrr, k),
                    k, stupidedi_rrr_rank0(&rrr, k));
        else
            printf("%u: ? rank₁(%u)=%u rank₀(%u)=%u\n",
                    k,
                    k, stupidedi_rrr_rank1(&rrr, k),
                    k, stupidedi_rrr_rank0(&rrr, k));
    }

    printf("\n%s\n", stupidedi_bitmap_to_string(&bits));
    printf("\n%s\n", stupidedi_rrr_to_string(&rrr));

    /*
    class Array;def cumsum; s=0; self.map{|x| s+=x }; end;end
    xs = "01010101,00000000,01010101,00000000,01010101,00000000,01010101,00000000"
    bs = xs.gsub(",","").scan(/.{1,9}/)
    bx = bs.map{|b| Integer(b.reverse, 2) }

    # Classes, ranks
    cs = bs.map{|b| b.count("1") }
    rs = cs.cumsum

    # Widths
    ws = cs.map{|r| (r.zero? && 0) || Math.log2([0,9,36,84,126,84,36,9][r]).ceil }
    os = ws.cumsum

    # Markers
    mb = xs.gsub(",","").scan(/.{1,10}/)
    ms = mb.map{|b| b.count("1") }.cumsum
    */
}
