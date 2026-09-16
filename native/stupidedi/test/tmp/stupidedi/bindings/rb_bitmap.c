#include <ruby.h>
#include <assert.h>
#include "stupidedi/bindings/rb_types.h"
#include "stupidedi/include/bitmap.h"

const rb_data_type_t rb_stupidedi_bitmap_t =
{
    .data = NULL,
    .wrap_struct_name = "stupidedi_bitmap_t",
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .function =
    {
        .dmark = NULL,
        .dfree = (dfree_t)stupidedi_bitmap_free,
        .dsize = (dsize_t)stupidedi_bitmap_sizeof
    },
};

/* TODO */
VALUE rb_bitmap_alloc(VALUE _class)
{
    return TypedData_Wrap_Struct(_class, &rb_stupidedi_bitmap_t, ALLOC(stupidedi_bitmap_t));
}

/* TODO */
VALUE rb_bitmap_initialize(int argc, VALUE* argv, VALUE self)
{
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);

    rb_check_arity(argc, 1, 2);
    long long length, width;

    length = NUM2LL(argv[0]);
    if (length < STUPIDEDI_BIT_IDX_MIN || STUPIDEDI_BIT_IDX_MAX < length)
        rb_raise(rb_eArgError, "length is out of range: %llu", length);

    if (argc == 1)
        stupidedi_bitmap_alloc((stupidedi_bit_idx_t)length, bits);
    else
    {
        width = NUM2LL(argv[1]);
        if (width <= 0 || 64 < width)
            rb_raise(rb_eArgError, "width is out of range: %llu", width);

        stupidedi_bitmap_alloc_record((stupidedi_bit_idx_t)length, (uint16_t)width, bits);
    }

    return self;
}

/* TODO */
VALUE rb_bitmap_get(int argc, VALUE* argv, VALUE self)
{
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);

    /* User needs to provide a width if it's not part of the bitmap */
    rb_check_arity(argc, bits->width?1:2, bits->width?1:2);
    long long i, width;

    i = NUM2LL(argv[0]);
    if (i < STUPIDEDI_BIT_IDX_MIN || STUPIDEDI_BIT_IDX_MAX < i)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (bits->width)
        /* Width is implied */
        return (i * bits->width >= bits->size) ? Qnil :
            ULL2NUM(stupidedi_bitmap_read_record(bits, (stupidedi_bit_idx_t)i));

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    return (width + i >= bits->size) ? Qnil :
        ULL2NUM(stupidedi_bitmap_read(bits, (stupidedi_bit_idx_t)i, (uint8_t)width));
}

/* TODO */
VALUE rb_bitmap_set(int argc, VALUE* argv, VALUE self)
{
    long long i, width;
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);

    /* User needs to provide a width if it's not part of the bitmap */
    rb_check_arity(argc, bits->width?2:3, bits->width?2:3);

    i = NUM2LL(argv[0]);
    if (i < STUPIDEDI_BIT_IDX_MIN || STUPIDEDI_BIT_IDX_MAX < i)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (bits->width)
        /* Width is implied */
        return (i * bits->width >= bits->size) ? Qnil :
            ULL2NUM(stupidedi_bitmap_write_record(bits, (stupidedi_bit_idx_t)i, NUM2ULL(argv[1])));

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    return (width + i >= bits->size) ? Qnil :
        ULL2NUM(stupidedi_bitmap_write(bits, (stupidedi_bit_idx_t)i, (uint8_t)width, NUM2ULL(argv[2])));
}

/* TODO */
VALUE rb_bitmap_width(VALUE self)
{
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);
    return bits->width ? ULONG2NUM(bits->width) : Qnil;
}

/* TODO */
VALUE rb_bitmap_size(VALUE self)
{
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);
    return ULONG2NUM(stupidedi_bitmap_size(bits));
}

/* TODO */
VALUE rb_bitmap_memsize_bits(VALUE self)
{
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);
    return ULONG2NUM(stupidedi_bitmap_sizeof_bits(bits));
}

/* TODO */
VALUE rb_bitmap_inspect(VALUE self)
{
    stupidedi_bitmap_t* bits;
    TypedData_Get_Struct(self, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    assert(bits != NULL);

    char* tmp;
    tmp = bits->width == 0 ?
        stupidedi_bitmap_to_string(bits) : stupidedi_bitmap_to_string_record(bits);

    VALUE _str;
    _str = rb_sprintf(bits->width == 0 ?
                "#<%"PRIsVALUE":%p %s>" :
                "#<%"PRIsVALUE":%p [%s]>",
            rb_class_path(rb_obj_class(self)),
            (void*)self,
            tmp);

    free(tmp);
    return _str;
}
