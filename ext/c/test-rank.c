#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#include "rrr.h"
#include "bit_vector.h"

int main(int argc, char **argv) {
    bit_vector_t bits;
    rrr_t rrr;

    uint8_t  width = 8;
    uint16_t lenth = 8;
    uint64_t value = 0xaaaaaaaaaaaaaaaa & ((1ULL << width) - 1);

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

    bit_vector_alloc_record(lenth, width, &bits);
    for (int k = 0; k < lenth; k += 2)
        bit_vector_write_record(&bits, k, 0xaa);

    rrr_alloc(&bits, 5, 8, &rrr);

    /*
    printf("rank1(%u) = %u\n", 4, rrr_rank1(&rrr, 4));
    printf("rank1(%u) = %u\n", 6, rrr_rank1(&rrr, 6));
    printf("rank1(%u) = %u\n", 8, rrr_rank1(&rrr, 8));
    */

    for (uint32_t k = 0; k <= bits.nbits + 3; k += 1) {
        if (k < bits.nbits)
            printf("%u: %llu rank(%u)=%u\n",
                    k, bit_vector_read(&bits, k, 1),
                    k, rrr_rank1(&rrr, k));
        else
            printf("%u: ? rank(%u)=%u\n", k, k, rrr_rank1(&rrr, k));
    }

    printf("\n\n"); bit_vector_print(&bits); printf("\n");

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
