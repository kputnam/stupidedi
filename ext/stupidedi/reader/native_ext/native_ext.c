#include "extconf.h"
#include "ruby.h"
#include "ruby/encoding.h"

static inline int
single_byte_optimizable(VALUE str, rb_encoding *enc) {
    if (ENC_CODERANGE(str) == ENC_CODERANGE_7BIT)
        return 1;

    if (rb_enc_mbmaxlen(enc) == 1)
        return 1;

    return 0;
}

/*
 * call-seq:
 *    Stupidedi::Reader.substr_eql?("abc ", 0, "xyz abc", 4, 2)  #=> true
 *    Stupidedi::Reader.substr_eql?(" abc", 1, "xyz abc", 3, 2)  #=> true
 *    Stupidedi::Reader.substr_eql?(" abc", 1, "xyz a_c", 3, 2)  #=> false
 *
 * Returns true if the substring of s1[n1, length] is equal to the
 * substring s2[n2, length]. This is more efficient than doing
 * `s1[...] == s2[...]` because it doesn't allocate a new String for
 * each substring before performing the comparison.
 */
static VALUE
rb_substr_eql_p(VALUE self, VALUE str1, VALUE offset1, VALUE str2, VALUE offset2, VALUE length) {
    Check_Type(str1,    T_STRING);
    Check_Type(str2,    T_STRING);
    Check_Type(offset1, T_FIXNUM);
    Check_Type(offset2, T_FIXNUM);
    Check_Type(length,  T_FIXNUM);

    long len, beg1, beg2;
    len  = NUM2LONG(length);
    beg1 = NUM2LONG(offset1);
    beg2 = NUM2LONG(offset2);

    if (len  < 0)  rb_raise(rb_eArgError, "length cannot be negative");
    if (beg1 < 0) rb_raise(rb_eArgError, "offset1 cannot be negative");
    if (beg2 < 0) rb_raise(rb_eArgError, "offset2 cannot be negative");

    if (beg1 + len > rb_str_strlen(str1)) return Qnil;
    if (beg2 + len > rb_str_strlen(str2)) return Qnil;

    /* Number of bytes in str1[offset, length], calculated by rb_str_subpos */
    long len1, len2;
    len1 = len;
    len2 = len;

    const char *ptr1, *ptr2;
    ptr1 = rb_str_subpos(str1, beg1, &len1);
    ptr2 = rb_str_subpos(str2, beg2, &len2);

    if (ptr1 == NULL || ptr2 == NULL) return Qnil;
    if (len1 != len2 || len1 < len)   return Qnil;
    return (memcmp(ptr1, ptr2, len) == 0) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *    Stupidedi::Reader.lstrip_offset("abc   xyz   www", 0) #=> 0
 *    Stupidedi::Reader.lstrip_offset("abc   xyz   www", 3) #=> 6
 *    Stupidedi::Reader.lstrip_offset("abc   xyz   www", 6) #=> 6
 */
static VALUE
rb_lstrip_offset(VALUE self, VALUE str, VALUE offset) {
    Check_Type(str,    T_STRING);
    Check_Type(offset, T_FIXNUM);

    char *ptr, *start, *end;
    rb_encoding *enc;

    start = RSTRING_PTR(str);
    end   = RSTRING_END(str);
    enc   = rb_enc_from_index(ENCODING_GET(str));

    if (single_byte_optimizable(str, enc)) {
        ptr = start + FIX2LONG(offset);

        if (ptr >= end)
            return LONG2NUM(RSTRING_LEN(str));

        while (ptr < end && rb_isspace(*ptr))
            ptr ++;

        return LONG2NUM(ptr - start);
    }

    int len;
    long len_, count;
    unsigned int c;

    len_  = 1;
    count = 0;
    ptr   = rb_str_subpos(str, FIX2LONG(offset), &len_);

    if (!ptr || ptr >= end || ptr < start)
        return LONG2NUM(RSTRING_LEN(str));

    while (ptr < end && (c = rb_enc_codepoint_len(ptr, end, &len, enc)) != 0 && rb_isspace(c)) {
        ptr   += len;
        count ++;
    }

    return LONG2NUM(count);
}

/*
 * call-seq:
 *    Stupidedi::Reader.rstrip_offset("", 0) #=> 0
 *    Stupidedi::Reader.rstrip_offset("", 3) #=> 6
 *    Stupidedi::Reader.rstrip_offset("", 6) #=> 6
 */
static VALUE
rb_rstrip_offset(VALUE self, VALUE str, VALUE offset) {
    Check_Type(str,    T_STRING);
    Check_Type(offset, T_FIXNUM);

    char *ptr, *start, *end;
    rb_encoding *enc;

    start = RSTRING_PTR(str);
    end   = RSTRING_END(str);
    enc   = rb_enc_from_index(ENCODING_GET(str));

    if (single_byte_optimizable(str, enc)) {
        ptr = RSTRING_PTR(str) + FIX2LONG(offset);

        if (!start || ptr >= end || ptr < start)
            return LONG2NUM(0);

        while (start < ptr && rb_isspace(*ptr))
            ptr --;

        return LONG2NUM(ptr - start);
    }

    long len;
    len = 1;
    end = RSTRING_END(str);
    ptr = rb_str_subpos(str, FIX2LONG(offset), &len);

    if (!ptr || ptr >= end || ptr < start)
        return LONG2NUM(RSTRING_LEN(str));

    unsigned int c;
    long count;
    count = 0;

    while (ptr >= start && (c = rb_enc_codepoint(ptr, end, enc)) != 0 && rb_isspace(c)) {
        char *ptr_;
        if ((ptr_ = rb_enc_prev_char(start, ptr, end, enc)) == NULL) break;
        ptr   = ptr_;
        count ++;
    }

    return LONG2NUM(FIX2LONG(offset) - count);
}

static int
is_ctrl_char(const unsigned int c) {
    if ((c >= 32  && c <= 64 )  //  !\"\#$%&'()*+,-./0123456789:;<=>?@
     || (c >= 65  && c <= 97 )  // ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`
     || (c >= 97  && c <= 126)  // abcdefghijklmnopqrstuvwxyz{|}~
     || (c >= 161 && c <= 191)  // ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿
     || (c >= 192 && c <= 255)  // ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ
     || (c > 255))
        return 0;

    return 1;
}

static VALUE
rb_lstrip_control_characters_offset(VALUE self, VALUE str, VALUE offset) {
    Check_Type(str,    T_STRING);
    Check_Type(offset, T_FIXNUM);

    char *ptr, *start, *end;
    rb_encoding *enc;

    start = RSTRING_PTR(str);
    end   = RSTRING_END(str);
    enc   = rb_enc_from_index(ENCODING_GET(str));

    if (single_byte_optimizable(str, enc)) {
        ptr = start + FIX2LONG(offset);

        if (ptr >= end)
            return LONG2NUM(RSTRING_LEN(str));

        while (ptr < end && is_ctrl_char((unsigned int) *ptr))
            ptr ++;

        return LONG2NUM(ptr - start);
    }

    long len_, count;
    len_  = 1;
    count = 0;
    ptr = rb_str_subpos(str, FIX2LONG(offset), &len_);

    if (!ptr || ptr >= end || ptr < start)
        return Qnil;

    while (ptr < end) {
        int len;
        const unsigned int c = rb_enc_codepoint_len(ptr, end, &len, enc);

        if (c != 0 && !is_ctrl_char(c)) break;
        ptr   += len;
        count ++;
    }

    return LONG2NUM(FIX2LONG(offset) + count);
}

/*
 * call-seq:
 *    Stupidedi::Reader.is_control_character_at?("abc\n", 0)   #=> false
 *    Stupidedi::Reader.is_control_character_at?("abc\n", 3)   #=> true
 *
 * Returns true if the character at the given offset is a control character
 * according to the X12 specification. This is equivalent to checking if
 * `str[offset]` is a control character, but more efficient because it doesn't
 * allocate a new string for the single char at `str[offset]` before testing.
 */
static VALUE
rb_is_control_character_at_p(VALUE self, VALUE str, VALUE offset) {
    Check_Type(str,    T_STRING);
    Check_Type(offset, T_FIXNUM);

    long len;
    char *ptr;

    len = 1;
    ptr = rb_str_subpos(str, FIX2LONG(offset), &len);

    if (!ptr || !len) return Qnil;
    if (len > 1)    return Qfalse;  // There be a multi-byte character here

    if (is_ctrl_char(*ptr))
        return Qtrue;

    return Qfalse;
}

void Init_native_ext(void) {
    VALUE rb_mStupidedi = rb_define_module("Stupidedi");
    VALUE rb_mReader    = rb_define_module_under(rb_mStupidedi, "Reader");

    rb_define_singleton_method(rb_mReader, "substr_eql?",                       rb_substr_eql_p,                      5);
    rb_define_singleton_method(rb_mReader, "lstrip_offset",                     rb_lstrip_offset,                     2);
    rb_define_singleton_method(rb_mReader, "rstrip_offset",                     rb_rstrip_offset,                     2);
    rb_define_singleton_method(rb_mReader, "lstrip_control_characters_offset",  rb_lstrip_control_characters_offset,  2);
    rb_define_singleton_method(rb_mReader, "is_control_character_at?",          rb_is_control_character_at_p,         2);
}
