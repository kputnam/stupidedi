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

static int compare_at(void*, const void*, const void*);

/*****************************************************************************/

stupidedi_packed_t*
stupidedi_packed_alloc(void)
{
    return malloc(sizeof(stupidedi_packed_t));
}

stupidedi_packed_t*
stupidedi_packed_free(stupidedi_packed_t* a)
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
        a->data = stupidedi_bitstr_free(a->data);

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
    dst->data   = NULL; /* TODO: free old bitstr? */
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

size_t*
stupidedi_packed_argsort(const stupidedi_packed_t* a)
{
    assert(a != NULL);
    return stupidedi_packed_argsort_range(a, 0, stupidedi_packed_length(a) - 1);
}

size_t*
stupidedi_packed_argsort_range(const stupidedi_packed_t* a, const size_t start, const size_t length)
{
    assert(a != NULL);
    assert(start < stupidedi_packed_length(a));
    assert(start + length <= stupidedi_packed_length(a));

    size_t *b;
    b = malloc(length * sizeof(size_t));

    for (size_t i = 0; i < length; ++i)
        b[i] = start + i;

    qsort_r(b, length, sizeof(size_t), (void*) a, &compare_at);

    for (size_t i = 0; i < length; ++i)
        b[i] -= start;

    return b;
}

static int
compare_at(void* a, const void* j, const void* k)
{
    stupidedi_packed_t* a_;
    size_t j_, k_;

    a_ = (stupidedi_packed_t *) a;
    j_ = *(size_t*) j;
    k_ = *(size_t*) k;

    return stupidedi_packed_read(a_, j_) - stupidedi_packed_read(a_, k_);
}
