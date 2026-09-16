#include <ruby.h>
#include "stupidedi/bindings/rb_types.h"
#include "stupidedi/include/wavelet.h"

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

/* TODO */
VALUE rb_stupidedi_wavelet_alloc(VALUE class)
{
    return TypedData_Wrap_Struct(class, &rb_stupidedi_wavelet_t, ALLOC(stupidedi_wavelet_t));
}

/* TODO */
VALUE rb_stupidedi_wavelet_initialize(VALUE self, VALUE _bits)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    stupidedi_bitmap_t * bits;
    TypedData_Get_Struct(_bits, stupidedi_bitmap_t, &rb_stupidedi_bitmap_t, bits);

    stupidedi_wavelet_alloc(bits, tree);

    return self;
}

/* TODO */
VALUE rb_stupidedi_wavelet_access(VALUE self, VALUE _i)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    long long i;
    i = NUM2LL(_i);

    if (i < STUPIDEDI_WAVELET_IDX_MIN || i > STUPIDEDI_WAVELET_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", i);

    if (i >= (long long)stupidedi_wavelet_size(tree))
        return Qnil;

    return ULL2NUM(stupidedi_wavelet_access(tree, (stupidedi_wavelet_idx_t)i));
}

/* TODO */
VALUE rb_stupidedi_wavelet_rank(VALUE self, VALUE _c, VALUE _i)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    long long c, i;
    c = NUM2LL(_c);
    i = NUM2LL(_i);

    if (c < STUPIDEDI_WAVELET_SYMBOL_MAX || c > STUPIDEDI_WAVELET_SYMBOL_MAX)
        rb_raise(rb_eArgError, "character out of range: %lld", c);

    if (i < STUPIDEDI_WAVELET_IDX_MIN || i > STUPIDEDI_WAVELET_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", i);

    if (i > (long long)stupidedi_wavelet_size(tree))
        i = stupidedi_wavelet_size(tree);

    return ULONG2NUM(stupidedi_wavelet_rank(tree, (stupidedi_wavelet_symbol_t)c, (stupidedi_wavelet_idx_t)i));
}

/* TODO */
VALUE rb_stupidedi_wavelet_select(VALUE self, VALUE _c, VALUE _r)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);

    long long c, r;
    c = NUM2LL(_c);
    r = NUM2LL(_r);

    if (c < STUPIDEDI_WAVELET_SYMBOL_MAX || c > STUPIDEDI_WAVELET_SYMBOL_MAX)
        rb_raise(rb_eArgError, "character out of range: %lld", c);

    if (r < STUPIDEDI_WAVELET_IDX_MIN || r > STUPIDEDI_WAVELET_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", r);

    if (r >= (long long)stupidedi_wavelet_size(tree))
        return Qnil;

    return ULONG2NUM(stupidedi_wavelet_select(tree, (stupidedi_wavelet_symbol_t)c, (stupidedi_wavelet_idx_t)r));
}

/* TODO */
VALUE rb_stupidedi_wavelet_size(VALUE self, VALUE _c, VALUE _r)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);
    return ULONG2NUM(stupidedi_wavelet_size(tree));
}

/* TODO */
VALUE rb_stupidedi_wavelet_memsize_bits(VALUE self, VALUE _c, VALUE _r)
{
    stupidedi_wavelet_t* tree;
    TypedData_Get_Struct(self, stupidedi_wavelet_t, &rb_stupidedi_wavelet_t, tree);
    return ULONG2NUM(stupidedi_wavelet_sizeof_bits(tree));
}

/* TODO */
VALUE rb_stupidedi_wavelet_inspect(VALUE self)
{
    VALUE str = rb_str_new2("#<");
    rb_str_append(str, rb_class_path(rb_obj_class(self)));
    rb_str_cat2(str, ":...>");
    return str;
}
