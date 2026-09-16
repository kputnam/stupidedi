#include <ruby.h>
#include "stupidedi/bindings/rb_types.h"
#include "stupidedi/include/packed.h"
#include "stupidedi/include/wavelet.h"

typedef struct rb_bitmap_wrapper_t {
    int is_packed;
    union {
        stupidedi_bitstr_t* bitstr;
        stupidedi_packed_t* packed;
    } data;
} rb_bitmap_wrapper_t;

extern const rb_data_type_t rb_stupidedi_bitmap_t;

const rb_data_type_t rb_stupidedi_wavelet_t =
{
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "stupidedi_wavelet_t",
    .function =
    {
        .dmark = NULL,
        .dfree = (dfree_t)stupidedi_wavelet_free,
        .dsize = (dsize_t)stupidedi_wavelet_sizeof,
    },
};

VALUE rb_stupidedi_wavelet_alloc(VALUE class)
{
    return TypedData_Wrap_Struct(class, &rb_stupidedi_wavelet_t, stupidedi_wavelet_alloc());
}

VALUE rb_stupidedi_wavelet_initialize(VALUE self, VALUE _bits)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(_bits, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    if (wrapper == NULL)
        rb_raise(rb_eRuntimeError, "bit vector is not allocated");

    if (!wrapper->is_packed)
        rb_raise(rb_eTypeError, "bit vector must be a packed array, not a simple bitstring");

    stupidedi_wavelet_init(tree, wrapper->data.packed, NULL);

    return self;
}

VALUE rb_stupidedi_wavelet_access(VALUE self, VALUE _i)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    long long i;
    i = NUM2LL(_i);

    if (i < 0)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (i >= (long long)stupidedi_wavelet_length(tree))
        return Qnil;

    return ULL2NUM(stupidedi_wavelet_access(tree, (size_t)i));
}

VALUE rb_stupidedi_wavelet_rank(VALUE self, VALUE _c, VALUE _i)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    long long c, i;
    c = NUM2LL(_c);
    i = NUM2LL(_i);

    if (c < 0)
        rb_raise(rb_eArgError, "character out of range: %lld", c);

    if (i < 0)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    size_t len = stupidedi_wavelet_length(tree);
    if (i > (long long)len)
        i = len;

    return ULONG2NUM(stupidedi_wavelet_rank(tree, (uint64_t)c, (size_t)i));
}

VALUE rb_stupidedi_wavelet_select(VALUE self, VALUE _c, VALUE _r)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    long long c, r;
    c = NUM2LL(_c);
    r = NUM2LL(_r);

    if (c < 0)
        rb_raise(rb_eArgError, "character out of range: %lld", c);

    if (r < 0)
        rb_raise(rb_eArgError, "rank out of range: %lld", r);

    size_t result = stupidedi_wavelet_select(tree, (size_t)r, (uint64_t)c);
    if (result == (size_t)-1)
        return Qnil;

    return ULONG2NUM(result);
}

VALUE rb_stupidedi_wavelet_size(VALUE self)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);
    return ULONG2NUM(stupidedi_wavelet_length(tree));
}

VALUE rb_stupidedi_wavelet_memsize_bits(VALUE self)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);
    return ULONG2NUM(stupidedi_wavelet_sizeof(tree) * 8);
}

/* TODO */
VALUE rb_stupidedi_wavelet_inspect(VALUE self)
{
    VALUE str = rb_str_new2("#<");
    rb_str_append(str, rb_class_path(rb_obj_class(self)));
    rb_str_cat2(str, ":...>");
    return str;
}
