#include <ruby.h>
#include <assert.h>
#include "stupidedi/bindings/rb_types.h"
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/packed.h"

typedef struct {
    int is_packed;
    union {
        stupidedi_bitstr_t* bitstr;
        stupidedi_packed_t* packed;
    } data;
} rb_bitmap_wrapper_t;

static void
rb_bitmap_free(rb_bitmap_wrapper_t* wrapper)
{
    if (wrapper == NULL)
        return;
    if (wrapper->is_packed)
        stupidedi_packed_free(wrapper->data.packed);
    else
        stupidedi_bitstr_free(wrapper->data.bitstr);
    free(wrapper);
}

static size_t
rb_bitmap_sizeof(const rb_bitmap_wrapper_t* wrapper)
{
    if (wrapper == NULL)
        return sizeof(rb_bitmap_wrapper_t);
    if (wrapper->is_packed)
        return sizeof(rb_bitmap_wrapper_t) + stupidedi_packed_sizeof(wrapper->data.packed);
    return sizeof(rb_bitmap_wrapper_t) + stupidedi_bitstr_sizeof(wrapper->data.bitstr);
}

const rb_data_type_t rb_stupidedi_bitmap_t =
{
    .data = NULL,
    .wrap_struct_name = "stupidedi_bitmap_t",
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .function =
    {
        .dmark = NULL,
        .dfree = (dfree_t)rb_bitmap_free,
        .dsize = (dsize_t)rb_bitmap_sizeof
    },
};

VALUE rb_bitmap_alloc(VALUE _class)
{
    rb_bitmap_wrapper_t* wrapper = ALLOC(rb_bitmap_wrapper_t);
    wrapper->is_packed = 0;
    wrapper->data.bitstr = NULL;
    return TypedData_Wrap_Struct(_class, &rb_stupidedi_bitmap_t, wrapper);
}

VALUE rb_bitmap_initialize(int argc, VALUE* argv, VALUE self)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);

    rb_check_arity(argc, 1, 2);
    long long length, width;

    length = NUM2LL(argv[0]);
    if (length < 0)
        rb_raise(rb_eArgError, "length must be non-negative");

    if (argc == 1)
    {
        wrapper->is_packed = 0;
        wrapper->data.bitstr = stupidedi_bitstr_new((size_t)length);
    }
    else
    {
        width = NUM2LL(argv[1]);
        if (width < 1 || 64 < width)
            rb_raise(rb_eArgError, "width must be between 1 and 64");

        wrapper->is_packed = 1;
        wrapper->data.packed = stupidedi_packed_new((size_t)length, (size_t)width);
    }

    return self;
}

VALUE rb_bitmap_get(int argc, VALUE* argv, VALUE self)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);

    rb_check_arity(argc, wrapper->is_packed ? 1 : 2, wrapper->is_packed ? 1 : 2);
    long long i, width;

    i = NUM2LL(argv[0]);
    if (i < 0)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (wrapper->is_packed)
    {
        if (i >= (long long)stupidedi_packed_length(wrapper->data.packed))
            return Qnil;
        return ULL2NUM(stupidedi_packed_read(wrapper->data.packed, (size_t)i));
    }

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    if (i + width > (long long)stupidedi_bitstr_length(wrapper->data.bitstr))
        return Qnil;

    return ULL2NUM(stupidedi_bitstr_read(wrapper->data.bitstr, (size_t)i, (uint8_t)width));
}

VALUE rb_bitmap_set(int argc, VALUE* argv, VALUE self)
{
    long long i, width;
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);

    rb_check_arity(argc, wrapper->is_packed ? 2 : 3, wrapper->is_packed ? 2 : 3);

    i = NUM2LL(argv[0]);
    if (i < 0)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (wrapper->is_packed)
    {
        if (i >= (long long)stupidedi_packed_length(wrapper->data.packed))
            return Qnil;
        stupidedi_packed_write(wrapper->data.packed, (size_t)i, NUM2ULL(argv[1]));
        return ULL2NUM(NUM2ULL(argv[1]));
    }

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    if (i + width > (long long)stupidedi_bitstr_length(wrapper->data.bitstr))
        return Qnil;

    stupidedi_bitstr_write(wrapper->data.bitstr, (size_t)i, (uint8_t)width, NUM2ULL(argv[2]));
    return ULL2NUM(NUM2ULL(argv[2]));
}

VALUE rb_bitmap_width(VALUE self)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);
    return wrapper->is_packed ? ULONG2NUM(stupidedi_packed_width(wrapper->data.packed)) : Qnil;
}

VALUE rb_bitmap_size(VALUE self)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);
    if (wrapper->is_packed)
        return ULONG2NUM(stupidedi_packed_length(wrapper->data.packed) * stupidedi_packed_width(wrapper->data.packed));
    return ULONG2NUM(stupidedi_bitstr_length(wrapper->data.bitstr));
}

VALUE rb_bitmap_memsize_bits(VALUE self)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);
    if (wrapper->is_packed)
        return ULONG2NUM(stupidedi_packed_sizeof(wrapper->data.packed) * 8);
    return ULONG2NUM(stupidedi_bitstr_sizeof(wrapper->data.bitstr) * 8);
}

VALUE rb_bitmap_inspect(VALUE self)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(self, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    assert(wrapper != NULL);

    char* tmp;
    if (wrapper->is_packed)
        tmp = stupidedi_packed_to_string(wrapper->data.packed);
    else
        tmp = stupidedi_bitstr_to_string(wrapper->data.bitstr);

    VALUE _str;
    _str = rb_sprintf(wrapper->is_packed ?
                "#<%"PRIsVALUE":%p [%s]>" :
                "#<%"PRIsVALUE":%p %s>",
            rb_class_path(rb_obj_class(self)),
            (void*)self,
            tmp);

    free(tmp);
    return _str;
}
