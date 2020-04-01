#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/packed.h"

stupidedi_packed_t*
stupidedi_packed_alloc(size_t length, size_t width)
{
    return stupidedi_packed_init(malloc(sizeof(stupidedi_packed_t)), length, width);
}

stupidedi_packed_t*
stupidedi_packed_dealloc(stupidedi_packed_t* a)
{
    if (a != NULL)
        free(stupidedi_packed_deinit(a));
    return NULL;
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
    a->data   = stupidedi_bitstr_alloc(width * length);

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
        dst = malloc(sizeof(stupidedi_packed_t));
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

char*
stupidedi_packed_to_string(const stupidedi_packed_t* a)
{
    if (a == NULL)
        return strdup("NULL");

    assert(a->data != NULL);
    assert(a->width != 0);

    char* str;
    str = malloc(a->data->length + a->length + 1);

    int64_t n;
    n = -1;

    for (size_t k = 0; k < a->length; ++k)
    {
        uint64_t item;
        item = stupidedi_packed_read(a, k);

        for(uint8_t i = a->width-1; i; --i)
            str[++n] = (item & (1 << i)) == 0 ? '0' : '1';

        str[++n] = ',';
    }

    str[a->data->length + a->length] = '\0';
    return str;
}

stupidedi_bitstr_t*
stupidedi_packed_as_bitstr(const stupidedi_packed_t* a, stupidedi_bitstr_t* b)
{
    assert(a != NULL);
    assert(a->data != NULL);

    if (b != NULL)
    {
        b->data   = a->data->data;
        b->length = a->length * a->width;
        return b;
    }

    return a->data;
}

stupidedi_packed_t*
stupidedi_bitstr_as_packed(stupidedi_bitstr_t* b, size_t width, stupidedi_packed_t* a)
{
    assert(b != NULL);
    assert(b->data != NULL);
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
