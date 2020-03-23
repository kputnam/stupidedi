#include <ruby.h>
#include "stupidedi/bindings/rb_types.h"
#include "stupidedi/include/interval.h"

VALUE rb_cRRR;
VALUE rb_cBitVector;

extern VALUE rb_bitmap_alloc(VALUE class);
extern VALUE rb_bitmap_initialize(int argc, VALUE* argv, VALUE self);
extern VALUE rb_bitmap_get(int argc, VALUE* argv, VALUE self);
extern VALUE rb_bitmap_set(int argc, VALUE* argv, VALUE self);
extern VALUE rb_bitmap_width(VALUE self);
extern VALUE rb_bitmap_size(VALUE self);
extern VALUE rb_bitmap_memsize_bits(VALUE self);
extern VALUE rb_bitmap_inspect(VALUE self);

extern VALUE rb_rrr_builder_alloc(VALUE class);
extern VALUE rb_rrr_builder_initialize(VALUE self, VALUE _block_nbits, VALUE _marker_nbits, VALUE _size);
extern VALUE rb_rrr_builder_append(VALUE self, VALUE _width, VALUE _value);
extern VALUE rb_rrr_builder_build(VALUE self);
extern VALUE rb_rrr_builder_written(VALUE self);
extern VALUE rb_rrr_builder_size(VALUE self);
extern VALUE rb_rrr_builder_memsize_bits(VALUE self);
extern VALUE rb_rrr_builder_inspect(VALUE self);

extern VALUE rb_rrr_alloc(VALUE class);
extern VALUE rb_rrr_initialize(VALUE self, VALUE _bits, VALUE _block_nbits, VALUE _marker_nbits);
extern VALUE rb_rrr_access(VALUE self, VALUE _i);
extern VALUE rb_rrr_rank(VALUE self, VALUE _c, VALUE _i);
extern VALUE rb_rrr_select(VALUE self, VALUE _c, VALUE _r);
extern VALUE rb_rrr_size(VALUE self);
extern VALUE rb_rrr_memsize_bits(VALUE self);
extern VALUE rb_rrr_to_bitmap(VALUE self);
extern VALUE rb_rrr_inspect(VALUE self);

extern VALUE rb_wavelet_tree_alloc(VALUE class);
extern VALUE rb_wavelet_tree_initialize(VALUE self, VALUE _bits);
extern VALUE rb_wavelet_tree_access(VALUE self, VALUE _i);
extern VALUE rb_wavelet_tree_rank(VALUE self, VALUE _c, VALUE _i);
extern VALUE rb_wavelet_tree_select(VALUE self, VALUE _c, VALUE _r);
extern VALUE rb_wavelet_tree_size(VALUE self);
extern VALUE rb_wavelet_tree_memsize_bits(VALUE self);
extern VALUE rb_wavelet_tree_inspect(VALUE self);

extern VALUE rb_string_substr_eq_p(VALUE self, VALUE _str1, VALUE _ind1, VALUE _str2, VALUE _idx2, VALUE _length);
extern VALUE rb_string_graphic_p(int argc, VALUE* argv, VALUE class);
extern VALUE rb_string_whitespace_p(int argc, VALUE* argv, VALUE class);
extern VALUE rb_string_min_graphic_index(int argc, VALUE* argv, VALUE class);
extern VALUE rb_string_min_nongraphic_index(int argc, VALUE* argv, VALUE class);
extern VALUE rb_string_min_nonspace_index(int argc, VALUE* argv, VALUE class);
extern VALUE rb_string_max_nonspace_index(int argc, VALUE* argv, VALUE class);

void Init_native(void)
{
    VALUE rb_mNative = rb_define_module_under(rb_define_module("Stupidedi"), "Native");

    rb_cBitVector = rb_define_class_under(rb_mNative, "Bitmap", rb_cData);
    //rb_undef_alloc_func(rb_cBitVector);
    rb_define_alloc_func(rb_cBitVector,             rb_bitmap_alloc);
    rb_define_method(rb_cBitVector, "initialize",   rb_bitmap_initialize,   -1);
    rb_define_method(rb_cBitVector, "[]",           rb_bitmap_get,          -1);
    rb_define_method(rb_cBitVector, "[]=",          rb_bitmap_set,          -1);
    rb_define_method(rb_cBitVector, "width",        rb_bitmap_width,        0);
    rb_define_method(rb_cBitVector, "size",         rb_bitmap_size,         0);
    rb_define_method(rb_cBitVector, "memsize_bits", rb_bitmap_memsize_bits, 0);
    rb_define_method(rb_cBitVector, "inspect",      rb_bitmap_inspect,      0);

    rb_cRRR = rb_define_class_under(rb_mNative, "RRR", rb_cData);
    //rb_undef_alloc_func(rb_cRRR);
    rb_define_alloc_func(rb_cRRR,               rb_rrr_alloc);
    rb_define_method(rb_cRRR, "initialize",     rb_rrr_initialize,      3);
    rb_define_method(rb_cRRR, "[]",             rb_rrr_access,          1);
    rb_define_method(rb_cRRR, "rank",           rb_rrr_rank,            2);
    rb_define_method(rb_cRRR, "select",         rb_rrr_select,          2);
    rb_define_method(rb_cRRR, "size",           rb_rrr_size,            0);
    rb_define_method(rb_cRRR, "memsize_bits",   rb_rrr_memsize_bits,    0);
    rb_define_method(rb_cRRR, "to_bitmap",      rb_rrr_to_bitmap,       0);
    rb_define_method(rb_cRRR, "inspect",        rb_rrr_inspect,         0);

    VALUE rb_cRRRBuilder = rb_define_class_under(rb_cRRR, "Builder", rb_cData);
    //rb_undef_alloc_func(rb_cRRRBuilder);
    rb_define_alloc_func(rb_cRRRBuilder,                rb_rrr_builder_alloc);
    rb_define_method(rb_cRRRBuilder, "initialize",      rb_rrr_builder_initialize,   3);
    rb_define_method(rb_cRRRBuilder, "append",          rb_rrr_builder_append,       2);
    rb_define_method(rb_cRRRBuilder, "build",           rb_rrr_builder_build,        0);
    rb_define_method(rb_cRRRBuilder, "size",            rb_rrr_builder_size,         0);
    rb_define_method(rb_cRRRBuilder, "written",         rb_rrr_builder_written,      0);
    rb_define_method(rb_cRRRBuilder, "memsize_bits",    rb_rrr_builder_memsize_bits, 0);
    rb_define_method(rb_cRRRBuilder, "inspect",         rb_rrr_builder_inspect,      0);

    VALUE rb_cWaveletTree = rb_define_class_under(rb_mNative, "WaveletTree", rb_cData);
    //rb_undef_alloc_func(rb_cWaveletTree);
    rb_define_alloc_func(rb_cWaveletTree,               rb_wavelet_tree_alloc);
    rb_define_method(rb_cWaveletTree, "initialize",     rb_wavelet_tree_initialize,     1);
    rb_define_method(rb_cWaveletTree, "[]",             rb_wavelet_tree_access,         1);
    rb_define_method(rb_cWaveletTree, "rank",           rb_wavelet_tree_rank,           3);
    rb_define_method(rb_cWaveletTree, "select",         rb_wavelet_tree_select,         3);
    rb_define_method(rb_cWaveletTree, "size",           rb_wavelet_tree_size,           0);
    rb_define_method(rb_cWaveletTree, "memsize_bits",   rb_wavelet_tree_memsize_bits,   0);
    rb_define_method(rb_cWaveletTree, "inspect",        rb_wavelet_tree_inspect,        0);

    VALUE rb_cString = rb_define_class_under(rb_mNative, "String", rb_cObject);
    rb_undef_alloc_func(rb_cString);
    rb_define_singleton_method(rb_cString, "substr_eq?",            rb_string_substr_eq_p,          5);
    rb_define_singleton_method(rb_cString, "graphic?",              rb_string_graphic_p,    -       1);
    rb_define_singleton_method(rb_cString, "whitespace?",           rb_string_whitespace_p, -       1);
    rb_define_singleton_method(rb_cString, "min_graphic_index",     rb_string_min_graphic_index,   -1);
    rb_define_singleton_method(rb_cString, "min_nongraphic_index",  rb_string_min_nongraphic_index,-1);
    rb_define_singleton_method(rb_cString, "min_nonspace_index",    rb_string_min_nonspace_index,  -1);
    rb_define_singleton_method(rb_cString, "max_nonspace_index",    rb_string_max_nonspace_index,  -1);
}
