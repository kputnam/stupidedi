#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/packed.h"

typedef struct stupidedi_packed_t
{
    stupidedi_bitstr_t* data;
    uint8_t width;
    size_t length;
} stupidedi_packed_t;

/*****************************************************************************/

stupidedi_packed_t*
stupidedi_packed_alloc(void)
{
    return malloc(sizeof(stupidedi_packed_t));
}

stupidedi_packed_t*
stupidedi_packed_dealloc(stupidedi_packed_t* a)
{
    if (a != NULL)
        free(stupidedi_packed_deinit(a));
    return NULL;
}

stupidedi_packed_t*
stupidedi_packed_new(size_t length, size_t width)
{
    return stupidedi_packed_init(stupidedi_packed_alloc(), length, width);
}

stupidedi_packed_t*
stupidedi_packed_init(stupidedi_packed_t* a, size_t length, size_t width)
{
    assert(width >= STUPIDEDI_PACKED_WIDTH_MIN);
    assert(width <= STUPIDEDI_PACKED_WIDTH_MAX);
    assert(length > 0);
    assert(a != NULL);

    a->length = length;
    a->width  = width;
    a->data   = stupidedi_bitstr_new(width * length);

    return a;
}

stupidedi_packed_t*
stupidedi_packed_deinit(stupidedi_packed_t* a)
{
    if (a != NULL)
        a->data = stupidedi_bitstr_dealloc(a->data);

    return a;
}

stupidedi_packed_t*
stupidedi_packed_copy(const stupidedi_packed_t* src, stupidedi_packed_t* dst)
{
    if (src == dst)
        return dst;

    if (dst != NULL)
        stupidedi_packed_deinit(dst);
    else
    {
        dst = stupidedi_packed_alloc();
        assert(dst != NULL);
    }

    dst->width  = src->width;
    dst->length = src->length;
    dst->data   = NULL;
    stupidedi_bitstr_copy(src->data, dst->data);

    return dst;
}

stupidedi_packed_t*
stupidedi_packed_resize(stupidedi_packed_t* a, size_t length)
{
    assert(a != NULL);

    if (stupidedi_packed_length(a) == length)
        return a;

    a->length = length;
    a->data   = stupidedi_bitstr_resize(a->data, a->width * length);

    return a;
}

/*****************************************************************************/

stupidedi_packed_t*
stupidedi_packed_from_array8(size_t length, uint8_t* src)
{
    stupidedi_packed_t* a;
    a = stupidedi_packed_new(length, 8);

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(a, k, src[k]);

    return a;
}

stupidedi_packed_t*
stupidedi_packed_from_array16(size_t length, uint16_t* src)
{
    stupidedi_packed_t* a;
    a = stupidedi_packed_new(length, 16);

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(a, k, src[k]);

    return a;
}

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

size_t
stupidedi_packed_sizeof(const stupidedi_packed_t* a)
{
    return (a == NULL) ? 0 : sizeof(*a) + stupidedi_bitstr_sizeof(a->data);
}

size_t
stupidedi_packed_length(const stupidedi_packed_t* a)
{
    assert(a != NULL);
    return a->length;
}

uint8_t
stupidedi_packed_width(const stupidedi_packed_t* a)
{
    assert(a != NULL);
    return a->width;
}

char*
stupidedi_packed_to_string(const stupidedi_packed_t* a)
{
    if (a == NULL)
        return strdup("NULL");

    assert(a->data != NULL);
    assert(a->width != 0);

    char* str;
    str = malloc(stupidedi_bitstr_length(a->data) + a->length);

    int64_t n;
    n = -1;

    for (size_t k = 0; k < a->length; ++k)
    {
        uint64_t item;
        item = stupidedi_packed_read(a, k);

        for (uint8_t i = a->width; i--; )
            str[++n] = (item & (UINT64_C(1) << i)) == 0 ? '0' : '1';

        str[++n] = ',';
    }

    str[n] = '\0';
    return str;
}

stupidedi_bitstr_t*
stupidedi_packed_as_bitstr(const stupidedi_packed_t* a)
{
    assert(a != NULL);
    assert(a->data != NULL);

    return a->data;
}

stupidedi_packed_t*
stupidedi_bitstr_as_packed(stupidedi_bitstr_t* b, size_t width, stupidedi_packed_t* a)
{
    assert(b != NULL);
    //assert(b->data != NULL);
    assert(a != NULL);

    a->width  = width;
    a->length = (stupidedi_bitstr_length(b) + width - 1) / width;
    a->data   = b;
    return a;
}

/*****************************************************************************/

uint64_t
stupidedi_packed_read(const stupidedi_packed_t* a, size_t i)
{
    assert(a != NULL);
    assert(a->data != NULL);
    assert(a->width != 0);
    return stupidedi_bitstr_read(a->data, i * a->width, a->width);
}

size_t
stupidedi_packed_write(const stupidedi_packed_t* a, size_t i, uint64_t value)
{
    assert(a != NULL);
    assert(a->data != NULL);
    assert(a->width != 0);
    stupidedi_bitstr_write(a->data, i * a->width, a->width, value);
    return i + 1;
}

/*
stupidedi_packed_t*
stupidedi_packed_reverse(const stupidedi_packed_t* a, stupidedi_packed_t* b)
{
    assert(a != NULL);

    size_t length;
    length = stupidedi_packed_length(a);

    if (a == b)
    {
        for (size_t k = 0; k < (length + 1)/ 2 - 1; ++k)
        {
            uint64_t x, y;
            x = stupidedi_packed_read(b, k);
            y = stupidedi_packed_read(b, length - 1 - k);

            stupidedi_packed_write(b, k, y);
            stupidedi_packed_write(b, k, y);
        }
    }
    else
    {
        uint8_t  width;
        width  = stupidedi_packed_width(a);

        if (b == NULL)
            b = stupidedi_packed_alloc(length, width);

        assert(length == stupidedi_packed_length(b));
        assert(width  == stupidedi_packed_width(b));

        for (size_t k = 0; k < length; ++k)
            stupidedi_packed_write(b, length - 1 - k,
                    stupidedi_packed_read(a, k));
    }

    return b;
}
*/

static int
argsort_compare(void* a, const void* j, const void* k)
{
    stupidedi_packed_t* a_;
    size_t j_, k_;

    a_ = (stupidedi_packed_t *) a;
    j_ = *(size_t*) j;
    k_ = *(size_t*) k;

    return stupidedi_packed_read(a_, j_) - stupidedi_packed_read(a_, k_);
}

stupidedi_packed_t*
stupidedi_packed_argsort(const stupidedi_packed_t* a)
{
    size_t length;
    length = stupidedi_packed_length(a);

    size_t *i;
    i = malloc(length * sizeof(size_t));

    for (size_t k = 0; k < length; ++k)
        i[k] = k;

    qsort_r(i, length, sizeof(size_t), (void*) a, &argsort_compare);

    /* TODO: Less conversion back and forth between packed and unpacked arrays */

    stupidedi_packed_t *b;
    b = stupidedi_packed_new(length, nbits(length));

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(b, k, i[k]);

    free(i);

    return b;
}

stupidedi_packed_t*
stupidedi_packed_sort(const stupidedi_packed_t* a)
{
    /* TODO: Less conversion back and forth between packed and unpacked arrays */

    size_t length;
    length = stupidedi_packed_length(a);

    size_t *i;
    i = malloc(length * sizeof(size_t));

    for (size_t k = 0; k < length; ++k)
        i[k] = k;

    qsort_r(i, length, sizeof(size_t), (void*) a, &argsort_compare);

    /* TODO: Less conversion back and forth between packed and unpacked arrays */

    stupidedi_packed_t *b;
    b = stupidedi_packed_new(length, stupidedi_packed_width(a));

    for (size_t k = 0; k < length; ++k)
        stupidedi_packed_write(b, k, stupidedi_packed_read(a, i[k]));

    free(i);

    return b;
}
