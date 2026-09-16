#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "stupidedi/include/huffman.h"
#include "stupidedi/include/packed.h"

static int failures = 0;

static stupidedi_packed_t*
freqs(size_t length, uint32_t* src)
{
    stupidedi_packed_t* a;
    a = stupidedi_packed_new(length, 32);

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(a, k, src[k]);

    return a;
}

/* Encodes every symbol 0..count-1, decodes the result, and checks the
 * round-trip recovers the original symbol and codeword length. */
static void
check_roundtrip(const char* label, uint8_t L, stupidedi_packed_t* f, enum type type)
{
    stupidedi_huffman_t* codec;
    codec = stupidedi_huffman_new(L, f, type);

    size_t count = stupidedi_packed_length(f);

    for (size_t i1 = 0; i1 < count; ++i1)
    {
        uint64_t w;
        uint8_t l1;
        l1 = stupidedi_huffman_encode(codec, i1, &w);

        size_t i2;
        uint8_t l2;
        l2 = stupidedi_huffman_decode(codec, w, l1, &i2);

        if (i1 != i2 || l1 != l2)
        {
            printf("%s: symbol %zu: encode->[len=%u,w=%llu] decode->[sym=%zu,len=%u] ***MISMATCH***\n",
                    label, i1, l1, (unsigned long long)w, i2, l2);
            ++failures;
        }
    }

    printf("%s: OK (%zu symbols, max codeword length %u)\n",
            label, count, stupidedi_huffman_max_codeword_length(codec));

    stupidedi_huffman_free(codec);
}

int
main(int argc, char **argv)
{
    /* Small, gently skewed alphabet; L generous relative to alphabet size. */
    {
        stupidedi_packed_t* f = freqs(8, (uint32_t[]) { 1, 1, 1, 1, 2, 2, 3, 3 });
        check_roundtrip("packed-small", 16, f, PACKED);
        stupidedi_packed_free(f);
    }
    {
        stupidedi_packed_t* f = freqs(8, (uint32_t[]) { 1, 1, 1, 1, 2, 2, 3, 3 });
        check_roundtrip("wavelet-small", 16, f, WAVELET);
        stupidedi_packed_free(f);
    }

    /* Larger alphabet, still generous L. */
    {
        uint32_t src[] = {
            1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 6, 7, 8, 13, 14, 14, 15, 16, 21, 22,
            22, 22, 23, 23, 24, 33, 35, 41, 42, 43, 50, 51, 53, 71, 72, 73, 97,
            110, 110, 141, 143, 153, 175, 197, 236, 252, 289, 331, 333, 336, 336,
            356, 391, 395, 413, 418, 428, 454, 462, 468, 472, 542, 610, 629, 660,
            748, 824, 1206, 1599, 1766, 3742 };
        stupidedi_packed_t* f = freqs(sizeof(src)/sizeof(*src), src);
        check_roundtrip("packed-large", 16, f, PACKED);
        stupidedi_packed_free(f);
    }
    {
        uint32_t src[] = {
            1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 6, 7, 8, 13, 14, 14, 15, 16, 21, 22,
            22, 22, 23, 23, 24, 33, 35, 41, 42, 43, 50, 51, 53, 71, 72, 73, 97,
            110, 110, 141, 143, 153, 175, 197, 236, 252, 289, 331, 333, 336, 336,
            356, 391, 395, 413, 418, 428, 454, 462, 468, 472, 542, 610, 629, 660,
            748, 824, 1206, 1599, 1766, 3742 };
        stupidedi_packed_t* f = freqs(sizeof(src)/sizeof(*src), src);
        check_roundtrip("wavelet-large", 16, f, WAVELET);
        stupidedi_packed_free(f);
    }

    /* Tight L = ceil(log2(count)), highly skewed: forces several codewords
     * to hit the length cap L exactly, exercising the boundary where a
     * previous bug undercounted symbols whose codeword length equalled L. */
    {
        stupidedi_packed_t* f = freqs(8, (uint32_t[]) { 1, 1, 1, 1, 1, 1, 1, 100 });
        check_roundtrip("packed-tight-L", 3, f, PACKED);
        stupidedi_packed_free(f);
    }
    {
        stupidedi_packed_t* f = freqs(8, (uint32_t[]) { 1, 1, 1, 1, 1, 1, 1, 100 });
        check_roundtrip("wavelet-tight-L", 3, f, WAVELET);
        stupidedi_packed_free(f);
    }

    printf("\n%s\n", failures == 0 ? "ALL OK" : "FAILURES");
    return failures == 0 ? 0 : 1;
}
