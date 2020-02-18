#include <ruby.h>
#include "bindings/rb_types.h"
#include "lib/wavelet_tree.h"

const rb_data_type_t rb_wavelet_tree_t = {
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "wavelet_tree_t",
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)wavelet_tree_free,
        .dsize = (dsize_t)wavelet_tree_sizeof,
    },
};

/* TODO */
VALUE rb_wavelet_tree_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_wavelet_tree_t, ALLOC(wavelet_tree_t));
}

/* TODO */
VALUE rb_wavelet_tree_initialize(VALUE self, VALUE _bits) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);

    bit_vector_t* bits;
    TypedData_Get_Struct(_bits, bit_vector_t, &rb_bit_vector_t, bits);

    wavelet_tree_alloc(bits, tree);

    return self;
}

/* TODO */
VALUE rb_wavelet_tree_access(VALUE self, VALUE _i) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);

    long long i;
    i = NUM2LL(_i);

    if (i < WAVELET_TREE_IDX_MIN || i > WAVELET_TREE_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", i);

    if (i >= (long long)wavelet_tree_size(tree))
        return Qnil;

    return ULL2NUM(wavelet_tree_access(tree, (wavelet_tree_idx_t)i));
}

/* TODO */
VALUE rb_wavelet_tree_rank(VALUE self, VALUE _c, VALUE _i) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);

    long long c, i;
    c = NUM2LL(_c);
    i = NUM2LL(_i);

    if (c < WAVELET_TREE_SYM_MAX || c > WAVELET_TREE_SYM_MAX)
        rb_raise(rb_eArgError, "character out of range: %lld", c);

    if (i < WAVELET_TREE_IDX_MIN || i > WAVELET_TREE_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", i);

    if (i > (long long)wavelet_tree_size(tree))
        i = wavelet_tree_size(tree);

    return ULONG2NUM(wavelet_tree_rank(tree, (wavelet_tree_sym_t)c, (wavelet_tree_idx_t)i));
}

/* TODO */
VALUE rb_wavelet_tree_select(VALUE self, VALUE _c, VALUE _r) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);

    long long c, r;
    c = NUM2LL(_c);
    r = NUM2LL(_r);

    if (c < WAVELET_TREE_SYM_MAX || c > WAVELET_TREE_SYM_MAX)
        rb_raise(rb_eArgError, "character out of range: %lld", c);

    if (r < WAVELET_TREE_IDX_MIN || r > WAVELET_TREE_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", r);

    if (r >= (long long)wavelet_tree_size(tree))
        return Qnil;

    return ULONG2NUM(wavelet_tree_select(tree, (wavelet_tree_sym_t)c, (wavelet_tree_idx_t)r));
}

/* TODO */
VALUE rb_wavelet_tree_size(VALUE self, VALUE _c, VALUE _r) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);
    return ULONG2NUM(wavelet_tree_size(tree));
}

/* TODO */
VALUE rb_wavelet_tree_memsize_bits(VALUE self, VALUE _c, VALUE _r) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);
    return ULONG2NUM(wavelet_tree_size_bits(tree));
}

/* TODO */
VALUE rb_wavelet_tree_inspect(VALUE self) {
    VALUE str = rb_str_new2("#<");
    rb_str_append(str, rb_class_path(rb_obj_class(self)));
    rb_str_cat2(str, ":...>");
    return str;
}
