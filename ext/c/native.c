#include <ruby.h>
#include "lib/rrr.h"
#include "lib/bit_vector.h"
#include "lib/interval_tree.h"
#include "lib/wavelet_tree.h"

typedef void (*dfree_t)(void*);
typedef size_t (*dsize_t)(const void*);

static const rb_data_type_t rb_bit_vector_t = {
    .data = NULL,
    .wrap_struct_name = "bit_vector_t",
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)bit_vector_free,
        .dsize = (dsize_t)bit_vector_sizeof
    },
};

static const rb_data_type_t rb_rrr_t = {
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "rrr_t",
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)rrr_free,
        .dsize = (dsize_t)rrr_sizeof,
    },
};

static const rb_data_type_t rb_wavelet_tree_t = {
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "wavelet_tree_t",
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)wavelet_tree_free,
        .dsize = (dsize_t)wavelet_tree_sizeof,
    },
};

static VALUE rb_bit_vector_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_bit_vector_t, ALLOC(bit_vector_t));
}

/*
 *
 */
static VALUE rb_bit_vector_initialize(int argc, VALUE* argv, VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    rb_check_arity(argc, 1, 2);
    long long length, width;

    length = NUM2LL(argv[0]);
    if (length < BIT_IDX_MIN || BIT_IDX_MAX < length)
        rb_raise(rb_eArgError, "length is out of range: %llu", length);

    if (argc == 1)
        bit_vector_alloc((bit_idx_t)length, bits);
    else {
        width = NUM2LL(argv[1]);
        if (width <= 0 || 64 < width)
            rb_raise(rb_eArgError, "width is out of range: %llu", width);

        bit_vector_alloc_record((bit_idx_t)length, (uint16_t)width, bits);
    }

    return self;
}

static VALUE rb_bit_vector_get(int argc, VALUE* argv, VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    /* User needs to provide a width if it's not part of the bit_vector */
    rb_check_arity(argc, bits->width?1:2, bits->width?1:2);
    long long i, width;

    i = NUM2LL(argv[0]);
    if (i < BIT_IDX_MIN || BIT_IDX_MAX < i)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (bits->width)
        /* Width is implied */
        return (i * bits->width >= bits->nbits) ? Qnil :
            ULL2NUM(bit_vector_read_record(bits, (bit_idx_t)i));

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    return (width + i >= bits->nbits) ? Qnil :
        ULL2NUM(bit_vector_read(bits, (bit_idx_t)i, (uint8_t)width));
}

static VALUE rb_bit_vector_set(int argc, VALUE* argv, VALUE self) {
    long long i, width;
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    /* User needs to provide a width if it's not part of the bit_vector */
    rb_check_arity(argc, bits->width?2:3, bits->width?2:3);

    i = NUM2LL(argv[0]);
    if (i < BIT_IDX_MIN || BIT_IDX_MAX < i)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (bits->width)
        /* Width is implied */
        return (i * bits->width >= bits->nbits) ? Qnil :
            ULL2NUM(bit_vector_write_record(bits, (bit_idx_t)i, NUM2ULL(argv[1])));

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    return (width + i >= bits->nbits) ? Qnil :
        ULL2NUM(bit_vector_write(bits, (bit_idx_t)i, (uint8_t)width, NUM2ULL(argv[2])));
}

static VALUE rb_bit_vector_width(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);
    return bits->width ? ULONG2NUM(bits->width) : Qnil;
}

static VALUE rb_bit_vector_size(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);
    return ULONG2NUM(bit_vector_size(bits));
}

static VALUE rb_bit_vector_memsize_bits(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);
    return ULONG2NUM(bit_vector_size_bits(bits));
}

/******************************************************************************/

static VALUE rb_rrr_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_rrr_t, ALLOC(rrr_t));
}

static VALUE rb_rrr_initialize(VALUE self, VALUE _bits, VALUE _block_nbits, VALUE _marker_nbits) {
    bit_vector_t* bits;
    TypedData_Get_Struct(_bits, bit_vector_t, &rb_bit_vector_t, bits);

    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    long long block_nbits, marker_nbits;
    block_nbits  = NUM2LL(_block_nbits);
    marker_nbits = NUM2LL(_marker_nbits);

    if (block_nbits < RRR_BLOCK_NBITS_MIN || block_nbits > RRR_BLOCK_NBITS_MAX)
        rb_raise(rb_eArgError, "block size is out of range: %llu", block_nbits);

    if (marker_nbits < RRR_MARKER_NBITS_MIN || RRR_MARKER_NBITS_MAX < marker_nbits)
        rb_raise(rb_eArgError, "marker size is out of range: %llu", marker_nbits);

    if (marker_nbits <= block_nbits)
        rb_raise(rb_eArgError, "marker size is not larger than block size: %llu <= %llu",
                marker_nbits, block_nbits);

    rrr_alloc(bits, block_nbits, marker_nbits, rrr);

    return self;
}

static VALUE rb_rrr_access(VALUE self, VALUE _i) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    long long i;
    i = NUM2LL(_i);

    if (i < 0 || i > BIT_IDX_MAX)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (i >= rrr->nbits)
        return Qnil;

    return UINT2NUM(rrr_access(rrr, (bit_idx_t)i));
}

static VALUE rb_rrr_rank(VALUE self, VALUE _c, VALUE _i) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    long long c, i;
    c = NUM2LL(_c);
    i = NUM2LL(_i);

    if (c != 0 && c != 1)
        rb_raise(rb_eArgError, "first argument must be 0 or 1");

    if (i < 0 || i > BIT_IDX_MAX)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    return ULONG2NUM(c == 0 ? rrr_rank0(rrr, (bit_idx_t)i) : rrr_rank1(rrr, (bit_idx_t)i));
}

static VALUE rb_rrr_select(VALUE self, VALUE _c, VALUE _r) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    long long c, r;
    c = NUM2LL(_c);
    r = NUM2LL(_r);

    if (c != 0 && c != 1)
        rb_raise(rb_eArgError, "first argument must be 0 or 1");

    if (r < 0 || r > BIT_IDX_MAX)
        rb_raise(rb_eArgError, "rank out of range: %lld", r);

    bit_idx_t s = c == 0 ?
        rrr_select0(rrr, (bit_idx_t)r) :
        rrr_select1(rrr, (bit_idx_t)r);

    return s < r ? Qnil : ULONG2NUM(s);
}

static VALUE rb_rrr_size(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);
    return ULONG2NUM(rrr_size(rrr));
}

static VALUE rb_rrr_memsize_bits(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);
    return ULONG2NUM(rrr_size_bits(rrr));
}

/******************************************************************************/

static VALUE rb_wavelet_tree_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_wavelet_tree_t, ALLOC(wavelet_tree_t));
}

static VALUE rb_wavelet_tree_initialize(VALUE self, VALUE _bits) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);

    bit_vector_t* bits;
    TypedData_Get_Struct(_bits, bit_vector_t, &rb_bit_vector_t, bits);

    wavelet_tree_alloc(bits, tree);

    return self;
}

static VALUE rb_wavelet_tree_access(VALUE self, VALUE _i) {
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

static VALUE rb_wavelet_tree_rank(VALUE self, VALUE _c, VALUE _i) {
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

static VALUE rb_wavelet_tree_select(VALUE self, VALUE _c, VALUE _r) {
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

static VALUE rb_wavelet_tree_size(VALUE self, VALUE _c, VALUE _r) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);
    return ULONG2NUM(wavelet_tree_size(tree));
}

static VALUE rb_wavelet_tree_memsize_bits(VALUE self, VALUE _c, VALUE _r) {
    wavelet_tree_t* tree;
    TypedData_Get_Struct(self, wavelet_tree_t, &rb_wavelet_tree_t, tree);
    return ULONG2NUM(wavelet_tree_size_bits(tree));
}

void Init_native(void) {
    VALUE rb_mNative = rb_define_module_under(rb_define_module("Stupidedi"), "Native");

    VALUE rb_cBitVector = rb_define_class_under(rb_mNative, "BitVector", rb_cData);
    rb_define_alloc_func(rb_cBitVector,             rb_bit_vector_alloc);
    rb_define_method(rb_cBitVector, "initialize",   rb_bit_vector_initialize,   -1);
    rb_define_method(rb_cBitVector, "[]",           rb_bit_vector_get,          -1);
    rb_define_method(rb_cBitVector, "[]=",          rb_bit_vector_set,          -1);
    rb_define_method(rb_cBitVector, "width",        rb_bit_vector_width,        0);
    rb_define_method(rb_cBitVector, "size",         rb_bit_vector_size,         0);
    rb_define_method(rb_cBitVector, "memsize_bits", rb_bit_vector_memsize_bits, 0);

    VALUE rb_cRRR = rb_define_class_under(rb_mNative, "RRR", rb_cData);
    rb_define_alloc_func(rb_cRRR,               rb_rrr_alloc);
    rb_define_method(rb_cRRR, "initialize",     rb_rrr_initialize,      3);
    rb_define_method(rb_cRRR, "[]",             rb_rrr_access,          1);
    rb_define_method(rb_cRRR, "rank",           rb_rrr_rank,            2);
    rb_define_method(rb_cRRR, "select",         rb_rrr_select,          2);
    rb_define_method(rb_cRRR, "size",           rb_rrr_size,            0);
    rb_define_method(rb_cRRR, "memsize_bits",   rb_rrr_memsize_bits,    0);

    VALUE rb_cWaveletTree = rb_define_class_under(rb_mNative, "WaveletTree", rb_cData);
    rb_define_alloc_func(rb_cWaveletTree,               rb_wavelet_tree_alloc);
    rb_define_method(rb_cWaveletTree, "initialize",     rb_wavelet_tree_initialize,     1);
    rb_define_method(rb_cWaveletTree, "[]",             rb_wavelet_tree_access,         1);
    rb_define_method(rb_cWaveletTree, "rank",           rb_wavelet_tree_rank,           3);
    rb_define_method(rb_cWaveletTree, "select",         rb_wavelet_tree_select,         3);
    rb_define_method(rb_cWaveletTree, "size",           rb_wavelet_tree_size,           0);
    rb_define_method(rb_cWaveletTree, "memsize_bits",   rb_wavelet_tree_memsize_bits,   0);
}
