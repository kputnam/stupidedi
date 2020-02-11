#include <ruby.h>
#include "lib/rrr.h"

const rb_data_type_t rb_rrr_t = {
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "rrr_t",
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)rrr_free,
        .dsize = (dsize_t)rrr_sizeof,
    },
};

VALUE rb_rrr_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_rrr_t, ALLOC(rrr_t));
}

VALUE rb_rrr_initialize(VALUE self, VALUE _bits, VALUE _block_nbits, VALUE _marker_nbits) {
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

VALUE rb_rrr_access(VALUE self, VALUE _i) {
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

VALUE rb_rrr_rank(VALUE self, VALUE _c, VALUE _i) {
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

VALUE rb_rrr_select(VALUE self, VALUE _c, VALUE _r) {
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

VALUE rb_rrr_size(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);
    return ULONG2NUM(rrr_size(rrr));
}

VALUE rb_rrr_memsize_bits(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);
    return ULONG2NUM(rrr_size_bits(rrr));
}
