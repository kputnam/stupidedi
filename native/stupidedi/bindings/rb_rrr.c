#include <ruby.h>
#include "stupidedi/bindings/rb_types.h"
#include "stupidedi/include/bitstr.h"
#include "stupidedi/include/rrr.h"

extern VALUE rb_cRRR;
extern VALUE rb_cBitVector;

typedef struct rb_bitmap_wrapper_t {
    int is_packed;
    union {
        stupidedi_bitstr_t* bitstr;
        stupidedi_packed_t* packed;
    } data;
} rb_bitmap_wrapper_t;

extern const rb_data_type_t rb_stupidedi_bitmap_t;

const rb_data_type_t rb_stupidedi_rrr_t =
{
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "stupidedi_rrr_t",
    .function =
    {
        .dmark = NULL,
        .dfree = (dfree_t)stupidedi_rrr_free,
        .dsize = (dsize_t)stupidedi_rrr_sizeof,
    },
};

const rb_data_type_t rb_stupidedi_rrr_builder_t =
{
    .data = NULL,
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .wrap_struct_name = "stupidedi_rrr_builder_t",
    .function =
    {
        .dmark = NULL,
        .dfree = (dfree_t)stupidedi_rrr_builder_free,
        .dsize = (dsize_t)stupidedi_rrr_builder_sizeof,
    },
};

/* TODO */
VALUE rb_rrr_builder_alloc(VALUE class)
{
    return TypedData_Wrap_Struct(class, &rb_stupidedi_rrr_builder_t, stupidedi_rrr_builder_alloc());
}

/* call-seq:
 *  Builder.new(block_size, marker_size, total_size)
 *
 * Constructions a new RRR::Builder that incrementally encodes data as it's
 * fed by the `#append` method. Calling `#finish` will return the completed
 * `RRR` vector.
 */
VALUE rb_rrr_builder_initialize(VALUE self, VALUE _block_size, VALUE _marker_size, VALUE _size)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

    long long block_size, marker_size, size;
    block_size  = NUM2LL(_block_size);
    marker_size = NUM2LL(_marker_size);
    size        = NUM2LL(_size);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    if (block_size < STUPIDEDI_RRR_BLOCK_SIZE_MIN || STUPIDEDI_RRR_BLOCK_SIZE_MAX < block_size)
        rb_raise(rb_eArgError, "block size is out of range: %lld", block_size);

    if (marker_size < STUPIDEDI_RRR_MARKER_SIZE_MIN || STUPIDEDI_RRR_MARKER_SIZE_MAX < marker_size)
        rb_raise(rb_eArgError, "marker size is out of range: %lld", marker_size);

    if (marker_size <= block_size)
        rb_raise(rb_eArgError, "marker size is not larger than block size: %lld <= %lld",
                marker_size, block_size);

    if (size < 0)
        rb_raise(rb_eArgError, "size is out of range: %lld", size);

    stupidedi_rrr_builder_init(builder, (uint8_t)block_size, (uint16_t)marker_size, (size_t)size);
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
VALUE rb_rrr_builder_append(VALUE self, VALUE _width, VALUE _value)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

    long long width; uint64_t value;
    width = NUM2LL(_width);
    value = NUM2ULL(_value);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    if (width < 0 || width > 64)
        rb_raise(rb_eArgError, "width is out of range: %lld", width);

    if (value > (width < 64 ? (1ull << width) - 1 : -1))
        rb_raise(rb_eArgError, "value %llu exceeds given width %lld", value, width);

    size_t written = stupidedi_rrr_builder_written(builder);
    size_t size = stupidedi_rrr_builder_length(builder);
    if (written + (size_t)width > size)
        rb_raise(rb_eRuntimeError, "writing %lld bits would exceed size of %zu (%zu already written)",
                width, size, written);

    stupidedi_rrr_builder_write(builder, (uint8_t)width, value);
    return self;
}

/* call-seq:
 *  builder.finish #=> #<Stupidedi::Native::RRR:...>
 *
 * When exactly `builder.size` bits have been written, `#finish` will return the
 * complete `RRR`. Note calling `#finish` more than once will return the
 * same object as the first call.
 */
VALUE rb_rrr_builder_finish(VALUE self)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    size_t written = stupidedi_rrr_builder_written(builder);
    size_t size = stupidedi_rrr_builder_length(builder);
    if (written < size)
        rb_raise(rb_eRuntimeError, "all %zu bits must be written, only %zu so far",
                size, written);

    VALUE _rrr;
    _rrr = rb_iv_get(self, "rrr");

    if (_rrr != Qnil)
        return _rrr;

    stupidedi_rrr_t* rrr = stupidedi_rrr_alloc();
    stupidedi_rrr_builder_to_rrr(builder, rrr);

    _rrr = TypedData_Wrap_Struct(rb_cRRR, &rb_stupidedi_rrr_t, rrr);

    rb_iv_set(self, "rrr", _rrr);
    return _rrr;
}

/* call-seq:
 *  builder.written     #=> int
 *
 * Returns number of bits written, so far, to this builder.
 */
VALUE rb_rrr_builder_written(VALUE self)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    return ULONG2NUM(stupidedi_rrr_builder_written(builder));
}

/* call-seq:
 *  builder.inspect     #=> string
 */
VALUE rb_rrr_builder_inspect(VALUE self)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

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
VALUE rb_rrr_builder_size(VALUE self)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    return ULONG2NUM(stupidedi_rrr_builder_length(builder));
}

VALUE rb_rrr_builder_memsize_bits(VALUE self)
{
    stupidedi_rrr_builder_t* builder;
    TypedData_Get_Struct(self, stupidedi_rrr_builder_t, &rb_stupidedi_rrr_builder_t, builder);

    if (builder == NULL)
        rb_raise(rb_eRuntimeError, "builder is not allocated");

    return ULONG2NUM(stupidedi_rrr_builder_sizeof(builder) * 8);
}

VALUE rb_rrr_alloc(VALUE class)
{
    return TypedData_Wrap_Struct(class, &rb_stupidedi_rrr_t, stupidedi_rrr_alloc());
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
VALUE rb_rrr_initialize(VALUE self, VALUE _bits, VALUE _block_size, VALUE _marker_size)
{
    rb_bitmap_wrapper_t* wrapper;
    TypedData_Get_Struct(_bits, rb_bitmap_wrapper_t, &rb_stupidedi_bitmap_t, wrapper);

    if (wrapper == NULL)
        rb_raise(rb_eRuntimeError, "bit vector is not allocated");

    if (wrapper->is_packed)
        rb_raise(rb_eTypeError, "bit vector must be a simple bitstring, not a packed array");

    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long block_size, marker_size;
    block_size  = NUM2LL(_block_size);
    marker_size = NUM2LL(_marker_size);

    if (block_size < STUPIDEDI_RRR_BLOCK_SIZE_MIN || STUPIDEDI_RRR_BLOCK_SIZE_MAX < block_size)
        rb_raise(rb_eArgError, "block size is out of range: %lld", block_size);

    if (marker_size < STUPIDEDI_RRR_MARKER_SIZE_MIN || STUPIDEDI_RRR_MARKER_SIZE_MAX < marker_size)
        rb_raise(rb_eArgError, "marker size is out of range: %lld", marker_size);

    if (marker_size <= block_size)
        rb_raise(rb_eArgError, "marker size is not larger than block size: %lld <= %lld",
                marker_size, block_size);

    stupidedi_rrr_init(rrr, wrapper->data.bitstr, (uint8_t)block_size, (uint16_t)marker_size);

    return self;
}

/* call-seq:
 *  rrr[i]              #=> 0 or 1
 *
 * Returns the ith bit of the bit vector represented by this RRR vector.
 */
VALUE rb_rrr_access(VALUE self, VALUE _i)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long i;
    i = NUM2LL(_i);

    if (i < 0)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    size_t len = stupidedi_rrr_length(rrr);
    if (i >= (long long)len)
        return Qnil;

    return UINT2NUM(stupidedi_rrr_access(rrr, (size_t)i));
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
VALUE rb_rrr_rank(VALUE self, VALUE _c, VALUE _i)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long c, i;
    c = NUM2LL(_c);
    i = NUM2LL(_i);

    if (c != 0 && c != 1)
        rb_raise(rb_eArgError, "first argument must be 0 or 1");

    if (i < 0)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    return ULONG2NUM(c == 0 ? stupidedi_rrr_rank0(rrr, (size_t)i) : stupidedi_rrr_rank1(rrr, (size_t)i));
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
VALUE rb_rrr_select(VALUE self, VALUE _c, VALUE _r)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    long long c, r;
    c = NUM2LL(_c);
    r = NUM2LL(_r);

    if (c != 0 && c != 1)
        rb_raise(rb_eArgError, "first argument must be 0 or 1");

    if (r < 0)
        rb_raise(rb_eArgError, "rank out of range: %lld", r);

    size_t s = c == 0 ?
        stupidedi_rrr_select0(rrr, (size_t)r) :
        stupidedi_rrr_select1(rrr, (size_t)r);

    return s == (size_t)-1 ? Qnil : ULONG2NUM(s);
}

/* call-seq:
 *  rrr.size            #=> int
 *
 * Returns the number of bits in the vector represented by this RRR vector.
 */
VALUE rb_rrr_size(VALUE self)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    return ULONG2NUM(stupidedi_rrr_length(rrr));
}

VALUE rb_rrr_memsize_bits(VALUE self)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    return ULONG2NUM(stupidedi_rrr_sizeof(rrr) * 8);
}

/* call-seq:
 *  rrr.to_bit_vector   #=> #<Stupidedi::Native::BitVector:0x..>
 *
 * Decodes entire RRR vector into the bit vector it represents. This should be
 * used cautiously because all operations on `BitVector`s can already be
 * performed efficiently on `RRR` vectors without first needing to decode the
 * entire vector.
 */
VALUE rb_rrr_to_bit_vector(VALUE self)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    stupidedi_bitstr_t* bitstr = stupidedi_bitstr_new(stupidedi_rrr_length(rrr));
    stupidedi_rrr_to_bitstr(rrr, bitstr);

    rb_bitmap_wrapper_t* wrapper = ALLOC(rb_bitmap_wrapper_t);
    wrapper->is_packed = 0;
    wrapper->data.bitstr = bitstr;

    return TypedData_Wrap_Struct(rb_cBitVector, &rb_stupidedi_bitmap_t, wrapper);
}

/* call-seq:
 *  rrr.inspect         #=> string
 */
VALUE rb_rrr_inspect(VALUE self)
{
    stupidedi_rrr_t* rrr;
    TypedData_Get_Struct(self, stupidedi_rrr_t, &rb_stupidedi_rrr_t, rrr);

    if (rrr == NULL)
        rb_raise(rb_eRuntimeError, "rrr vector is not allocated");

    char* tmp;
    tmp = stupidedi_rrr_to_string(rrr);

    VALUE str;
    str = rb_sprintf("#<%"PRIsVALUE":%p %s>",
            rb_class_path(rb_obj_class(self)),
            (void*)self,
            tmp);

    free(tmp);
    return str;
}
