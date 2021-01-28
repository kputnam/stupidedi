#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/packed.h"

#define BINARY_FMT "%c%c%c%c%c%c%c%c"
#define BINARY(byte) \
    (byte & 0x80 ? '1' : '0'), \
    (byte & 0x40 ? '1' : '0'), \
    (byte & 0x20 ? '1' : '0'), \
    (byte & 0x10 ? '1' : '0'), \
    (byte & 0x08 ? '1' : '0'), \
    (byte & 0x04 ? '1' : '0'), \
    (byte & 0x02 ? '1' : '0'), \
    (byte & 0x01 ? '1' : '0')

/*****************************************************************************/

stupidedi_packed_t*
stupidedi_packed_from_array32(size_t length, uint32_t* src)
{
    stupidedi_packed_t* a;
    a = stupidedi_packed_new(length, 32);

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(a, k, src[k]);

    return a;
}

stupidedi_packed_t*
stupidedi_packed_from_array64(size_t length, uint64_t* src)
{
    stupidedi_packed_t* a;
    a = stupidedi_packed_new(length, 64);

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(a, k, src[k]);

    return a;
}

/*****************************************************************************/

int
main(int argc, char **argv)
{
    stupidedi_packed_t *v;
    v = stupidedi_packed_from_array32(8, (uint32_t[]) {
         /* 0  3  5  6  2  4  1  7 */
            1, 1, 1, 1, 2, 2, 3, 3 });
         /* 0  1  2  3  4  5  6  7 */

    /*v = stupidedi_packed_from_array32(71, (uint32_t[]) {
            1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 6, 7, 8, 13, 14, 14, 15, 16, 21, 22,
            22, 22, 23, 23, 24, 33, 35, 41, 42, 43, 50, 51, 53, 71, 72, 73, 97,
            110, 110, 141, 143, 153, 175, 197, 236, 252, 289, 331, 333, 336, 336,
            356, 391, 395, 413, 418, 428, 454, 462, 468, 472, 542, 610, 629, 660,
            748, 824, 1206, 1599, 1766, 3742 });*/

    stupidedi_huffman_t *codec;
    codec = stupidedi_huffman_new(16, v, PACKED);

    for (size_t i1 = 0; i1 < stupidedi_packed_length(v); ++i1)
    {
        uint8_t l1;
        uint64_t w;
        l1 = stupidedi_huffman_encode(codec, i1, &w);

        uint8_t l2;
        size_t i2;
        l2 = stupidedi_huffman_decode(codec, w, l1, &i2);

        printf("encode(%lu) = [%02u] "BINARY_FMT" "BINARY_FMT" "BINARY_FMT" "BINARY_FMT"\n",
                i1, l1, BINARY(w>>24), BINARY(w>>16), BINARY(w>>8), BINARY(w));

        printf("     decode([%02u] "BINARY_FMT" "BINARY_FMT" "BINARY_FMT" "BINARY_FMT") = %lu [%02u]\n\n",
                l1, BINARY(w>>24), BINARY(w>>16), BINARY(w>>8), BINARY(w), i2, l2);
    }

    return 0;
}
