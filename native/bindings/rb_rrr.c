#include <ruby.h>
#include "bindings/rb_types.h"
#include "lib/rrr.h"

extern VALUE rb_cRRR;
extern VALUE rb_cBitVector;

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

const rb_data_type_t rb_rrr_builder_t = {
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "rrr_builder_t",
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)rrr_builder_free,
        .dsize = (dsize_t)rrr_builder_sizeof,
    },
};

/* TODO */
VALUE rb_rrr_builder_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_rrr_builder_t, ALLOC(rrr_builder_t));
}

/* call-seq:
 *  Builder.new(block_size, marker_size, total_size)
 *
 * Constructions a new RRR::Builder that incrementally encodes data as it's
 * fed by the `#append` method. Calling `#finish` will return the completed
 * `RRR` vector.
 */
VALUE rb_rrr_builder_initialize(VALUE self, VALUE _block_size, VALUE _marker_size, VALUE _size) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    long long block_size, marker_size, size;
    block_size  = NUM2LL(_block_size);
    marker_size = NUM2LL(_marker_size);
    size        = NUM2LL(_size);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    if (block_size < RRR_BLOCK_SIZE_MIN || RRR_BLOCK_SIZE_MAX < block_size)
        rb_raise(rb_eArgError, "block size is out of range: %lld", block_size);

    if (marker_size < RRR_MARKER_SIZE_MIN || RRR_MARKER_SIZE_MAX < marker_size)
        rb_raise(rb_eArgError, "marker size is out of range: %lld", marker_size);

    if (marker_size <= block_size)
        rb_raise(rb_eArgError, "marker size is not larger than block size: %lld <= %lld",
                marker_size, block_size);

    if (size < 0 || size > BIT_IDX_MAX)
        rb_raise(rb_eArgError, "size is out of range: %lld", size);

    rrr_builder_alloc(block_size, marker_size, (bit_idx_t)size, builder, NULL);
    return self;
}

/* call-seq:
 *  builder.append(width, value) #=> builder
 *
 * Appends `width` bits of data from the integer `value`. Note `value` must fit
 * in `width` bits or less; e.g. the maximum 5-bit value is `2**5 - 1`.
 *
 * The number of bits that can be written in total is `builder.size`; exceeding
 * this will raise an exception.
 */
VALUE rb_rrr_builder_append(VALUE self, VALUE _width, VALUE _value) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    long long width; uint64_t value;
    width = NUM2LL(_width);
    value = NUM2ULL(_value);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    if (width < 0 || width > 64)
        rb_raise(rb_eArgError, "width is out of range: %lld", width);

    if (value > (width < 64 ? (1ull << width) - 1 : -1))
        rb_raise(rb_eArgError, "value %llu exceeds given width %lld", value, width);

    if (rrr_builder_written(builder) + width > rrr_builder_size(builder))
        rb_raise(rb_eRuntimeError, "writing %lld bits would exceed size of %u (%u already written)",
                width, rrr_builder_size(builder), rrr_builder_written(builder));

    /* TODO: ensure write doesn't exceed size */

    rrr_builder_append(builder, width, value);
    return self;
}

/* call-seq:
 *  builder.finish #=> #<Stupidedi::Native::RRR:...>
 *
 * When exactly `builder.size` bits have been written, `#finish` will return the
 * complete `RRR`. Note calling `#finish` more than once will return the
 * same object as the first call.
 */
VALUE rb_rrr_builder_finish(VALUE self) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    if (rrr_builder_written(builder) < rrr_builder_size(builder))
        rb_raise(rb_eRuntimeError, "all %u bits must be written, only %u so far",
                rrr_builder_size(builder), rrr_builder_written(builder));

    VALUE _rrr;
    /* Instance variable is not accessible via Object#instance_variables or
     * Object#instance_variable_get, because it isn't prefixed with @. */
    _rrr = rb_iv_get(self, "rrr");

    if (_rrr != Qnil)
        return _rrr;

    /* This will NOT allocate a new RRR each time, it will return the same one
     * on each call. If more than one Ruby object shares this struct, we will
     * likely have a double-free error. So we ensure only one Ruby object can
     * point to this rrr_t, and return the same object each time `#finish` is
     * called. */
    rrr_t* rrr;
    rrr = rrr_builder_finish(builder);

    _rrr = TypedData_Wrap_Struct(rb_cRRR/*,CLASS_OF(self)*/, &rb_rrr_t, rrr);

    rb_iv_set(self, "rrr", _rrr);
    return _rrr;
}

/* call-seq:
 *  builder.written     #=> int
 *
 * Returns number of bits written, so far, to this builder.
 */
VALUE rb_rrr_builder_written(VALUE self) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    return ULONG2NUM(rrr_builder_written(builder));
}

/* call-seq:
 *  builder.inspect     #=> string
 */
VALUE rb_rrr_builder_inspect(VALUE self) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    VALUE str = rb_str_new2("#<");
    rb_str_append(str, rb_class_path(rb_obj_class(self)));
    rb_str_cat2(str, ":...>");
    return str;
}

/* call-seq:
 *  builder.size        #=> int
 *
 * Returns the number of bits of the RRR vector being built. Exactly this many
 * bits must be written before calling `#finish` -- no more, no less.
 */
VALUE rb_rrr_builder_size(VALUE self) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    return ULONG2NUM(rrr_builder_size(builder));
}

/* call-seq:
 *  builder.memsize_bits    #=> int
 *
 * Returns the number of bits consumed in memory by this builder and the RRR
 * vector being built.
 */
VALUE rb_rrr_builder_memsize_bits(VALUE self) {
    rrr_builder_t* builder;
    TypedData_Get_Struct(self, rrr_builder_t, &rb_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    return ULONG2NUM(rrr_builder_size_bits(builder));
}

VALUE rb_rrr_alloc(VALUE class) {
    return TypedData_Wrap_Struct(class, &rb_rrr_t, ALLOC(rrr_t));
}

/* call-seq:
 *  RRR.new(bitvector, block_size, marker_size)
 *
 * Constructs an RRR vector by encoding the given `BitVector` into blocks of
 * `block_size` bits each. Larger block sizes generally result in higher ratios
 * of compression.
 *
 * To make `#rank` and `#select` operations time-effecient, a marker is recorded
 * every `marker_size` bits. This value must be no smaller than `block_size`.
 */
VALUE rb_rrr_initialize(VALUE self, VALUE _bits, VALUE _block_size, VALUE _marker_size) {
    bit_vector_t* bits;
    TypedData_Get_Struct(_bits, bit_vector_t, &rb_bit_vector_t, bits);

    if (bits == NULL)
        rb_raise(rb_eRuntimeError, "bit vector is not allocated");

    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long block_size, marker_size;
    block_size  = NUM2LL(_block_size);
    marker_size = NUM2LL(_marker_size);

    if (block_size < RRR_BLOCK_SIZE_MIN || RRR_BLOCK_SIZE_MAX < block_size)
        rb_raise(rb_eArgError, "block size is out of range: %lld", block_size);

    if (marker_size < RRR_MARKER_SIZE_MIN || RRR_MARKER_SIZE_MAX < marker_size)
        rb_raise(rb_eArgError, "marker size is out of range: %lld", marker_size);

    if (marker_size <= block_size)
        rb_raise(rb_eArgError, "marker size is not larger than block size: %lld <= %lld",
                marker_size, block_size);

    rrr_alloc(bits, block_size, marker_size, rrr);

    return self;
}

/* call-seq:
 *  rrr[i]              #=> 0 or 1
 *
 * Returns the ith bit of the bit vector represented by this RRR vector.
 */
VALUE rb_rrr_access(VALUE self, VALUE _i) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long i;
    i = NUM2LL(_i);

    if (i < 0 || i > BIT_IDX_MAX)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (i >= rrr->size)
        return Qnil;

    return UINT2NUM(rrr_access(rrr, (bit_idx_t)i));
}

/* call-seq:
 *  rrr.rank(0, i)      #=> 0..rrr.size
 *  rrr.rank(1, i)      #=> 0..rrr.size
 *
 * Returns the number of 0-bits (when c=0) or 1-bits (when c=1) that occur in
 * the first i bits of the bit vector represented by this RRR vector. For
 * example, rrr.rank(1, 10) will return the number 1-bits that occur in the
 * first 10 bits.
 */
VALUE rb_rrr_rank(VALUE self, VALUE _c, VALUE _i) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long c, i;
    c = NUM2LL(_c);
    i = NUM2LL(_i);

    if (c != 0 && c != 1)
        rb_raise(rb_eArgError, "first argument must be 0 or 1");

    if (i < 0 || i > BIT_IDX_MAX)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    return ULONG2NUM(c == 0 ? rrr_rank0(rrr, (bit_idx_t)i) : rrr_rank1(rrr, (bit_idx_t)i));
}

/* call-seq:
 *  rrr.select(0, i)    #=> 0..rrr.size or nil
 *  rrr.select(1, i)    #=> 0..rrr.size or nil
 *
 * Returns the length of the shortest prefix containing i 0-bits (when c=0) or
 * 1-bits (when c=1). If there are fewer than i occurrences, the `nil` is
 * returned.  By definition, assuming the result is not `nil`, then `rank(c,
 * select(c, i)) = i`.
 */
VALUE rb_rrr_select(VALUE self, VALUE _c, VALUE _r) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

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

/* call-seq:
 *  rrr.size            #=> int
 *
 * Returns the number of bits in the vector represented by this RRR vector.
 */
VALUE rb_rrr_size(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    return ULONG2NUM(rrr_size(rrr));
}

/* call-seq:
 *  rrr.memsize_bits    #=> int
 *
 * Returns the number of bits consumed in memory by this RRR vector. Note this
 * is not the length of the vector, because RRR is a compressed representation
 * of a bit vector.
 */
VALUE rb_rrr_memsize_bits(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    return ULONG2NUM(rrr_size_bits(rrr));
}

/* call-seq:
 *  rrr.to_bit_vector   #=> #<Stupidedi::Native::BitVector:0x..>
 *
 * Decodes entire RRR vector into the bit vector it represents. This should be
 * used cautiously because all operations on `BitVector`s can already be
 * performed efficiently on `RRR` vectors without first needing to decode the
 * entire vector.
 */
VALUE rb_rrr_to_bit_vector(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    bit_vector_t* bits;
    bits = rrr_to_bit_vector(rrr);

    return TypedData_Wrap_Struct(rb_cBitVector, &rb_bit_vector_t, bits);
}

/* call-seq:
 *  rrr.inspect         #=> string
 */
VALUE rb_rrr_inspect(VALUE self) {
    rrr_t* rrr;
    TypedData_Get_Struct(self, rrr_t, &rb_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    char* tmp;
    tmp = rrr_to_string(rrr);

    VALUE str;
    str = rb_sprintf("#<%"PRIsVALUE":%p %s>",
            rb_class_path(rb_obj_class(self)),
            (void*)self,
            tmp);

    free(tmp);
    return str;
}
