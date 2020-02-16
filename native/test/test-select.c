#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "rrr.h"
#include "bit_vector.h"

int main(int argc, char **argv) {
    bit_vector_t bits;
    rrr_t rrr;

    uint8_t  width = 8;
    uint16_t size  = 8;
    uint64_t value = 0xaaaaaaaaaaaaaaaa & ((1ULL << width) - 1);

    bit_vector_alloc_record(size, width, &bits);
    for (int k = 0; k < size; k += 2)
        bit_vector_write_record(&bits, k, value);

    rrr_alloc(&bits, 5, 8, &rrr);
    for (uint32_t k = 0; k < bits.size + 4; k ++) {
        if (k < bits.size)
            printf("%u: %llu rank(%u)=%u select(%u)=%u\n",
                    k, bit_vector_read(&bits, k, 1),
                    k, rrr_rank1(&rrr, k),
                    rrr_rank1(&rrr, k), rrr_select1(&rrr, rrr_rank1(&rrr, k)));
        else
            printf("%u: ? rank(%u)=%u select(%u)=%u\n",
                    k, k, rrr_rank1(&rrr, k),
                    rrr_rank1(&rrr, k), rrr_select1(&rrr, rrr_rank1(&rrr, k)));
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

