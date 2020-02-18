#include <assert.h>
#include <string.h>
#include <ruby.h>
#include "bindings/rb_types.h"
#include "lib/bit_vector.h"

const rb_data_type_t rb_bit_vector_t = {
    .data = NULL,
    .wrap_struct_name = "bit_vector_t",
    .flags = RUBY_TYPED_FREE_IMMEDIATELY,
    .function = {
        .dmark = NULL,
        .dfree = (dfree_t)bit_vector_free,
        .dsize = (dsize_t)bit_vector_sizeof
    },
};

/* TODO */
VALUE rb_bit_vector_alloc(VALUE _class) {
    return TypedData_Wrap_Struct(_class, &rb_bit_vector_t, ALLOC(bit_vector_t));
}

/* TODO */
VALUE rb_bit_vector_initialize(int argc, VALUE* argv, VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);

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

/* TODO */
VALUE rb_bit_vector_get(int argc, VALUE* argv, VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);

    /* User needs to provide a width if it's not part of the bit_vector */
    rb_check_arity(argc, bits->width?1:2, bits->width?1:2);
    long long i, width;

    i = NUM2LL(argv[0]);
    if (i < BIT_IDX_MIN || BIT_IDX_MAX < i)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (bits->width)
        /* Width is implied */
        return (i * bits->width >= bits->size) ? Qnil :
            ULL2NUM(bit_vector_read_record(bits, (bit_idx_t)i));

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    return (width + i >= bits->size) ? Qnil :
        ULL2NUM(bit_vector_read(bits, (bit_idx_t)i, (uint8_t)width));
}

/* TODO */
VALUE rb_bit_vector_set(int argc, VALUE* argv, VALUE self) {
    long long i, width;
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);

    /* User needs to provide a width if it's not part of the bit_vector */
    rb_check_arity(argc, bits->width?2:3, bits->width?2:3);

    i = NUM2LL(argv[0]);
    if (i < BIT_IDX_MIN || BIT_IDX_MAX < i)
        rb_raise(rb_eArgError, "index out of range: %lld", i);

    if (bits->width)
        /* Width is implied */
        return (i * bits->width >= bits->size) ? Qnil :
            ULL2NUM(bit_vector_write_record(bits, (bit_idx_t)i, NUM2ULL(argv[1])));

    width = NUM2LL(argv[1]);
    if (width <= 0 || 64 < width)
        rb_raise(rb_eArgError, "width out of range: %lld", width);

    return (width + i >= bits->size) ? Qnil :
        ULL2NUM(bit_vector_write(bits, (bit_idx_t)i, (uint8_t)width, NUM2ULL(argv[2])));
}

/* TODO */
VALUE rb_bit_vector_width(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);
    return bits->width ? ULONG2NUM(bits->width) : Qnil;
}

/* TODO */
VALUE rb_bit_vector_size(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);
    return ULONG2NUM(bit_vector_size(bits));
}

/* TODO */
VALUE rb_bit_vector_memsize_bits(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);
    return ULONG2NUM(bit_vector_size_bits(bits));
}

/* TODO */
VALUE rb_bit_vector_inspect(VALUE self) {
    bit_vector_t* bits;
    TypedData_Get_Struct(self, bit_vector_t, &rb_bit_vector_t, bits);

    assert(bits != NULL);

    char* tmp;
    tmp = bits->width == 0 ?
        bit_vector_to_string(bits) : bit_vector_to_string_record(bits);

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
