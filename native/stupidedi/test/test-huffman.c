#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/packed.h"

int
main(int argc, char **argv)
{
    stupidedi_packed_t *v;
    v = stupidedi_packed_from_array16(71, (uint16_t[]) {
            1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 6, 7, 8, 13, 14, 14, 15, 16, 21, 22,
            22, 22, 23, 23, 24, 33, 35, 41, 42, 43, 50, 51, 53, 71, 72, 73, 97,
            110, 110, 141, 143, 153, 175, 197, 236, 252, 289, 331, 333, 336, 336,
            356, 391, 395, 413, 418, 428, 454, 462, 468, 472, 542, 610, 629, 660,
            748, 824, 1206, 1599, 1766, 3742 });

    char *s = stupidedi_packed_to_string(v);
    printf("%s\n", s); free(s);

    stupidedi_huffman_t *h;
    h = stupidedi_huffman_new(v);

    return 0;
}
