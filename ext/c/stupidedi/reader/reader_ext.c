#include "extconf.h"
#include "ruby.h"
#include "ruby/encoding.h"
#include "codepoints.h"
#include <stdbool.h>

extern VALUE rb_str_length(VALUE str);

#define LIKELY(x)   (x)
#define UNLIKELY(x) (x)

#ifdef __GNUC__
#if __GNUC__ >= 3
#undef LIKELY
#undef UNLIKELY
#define LIKELY(x)   (__builtin_expect(!!(x), 1))
#define UNLIKELY(x) (__builtin_expect(!!(x), 0))
#endif
#endif

static int ENCIDX_CP850 = -1;
static int ENCIDX_CP852 = -1;
static int ENCIDX_CP855 = -1;
static int ENCIDX_IBM037 = -1;
static int ENCIDX_IBM437 = -1;
static int ENCIDX_IBM737 = -1;
static int ENCIDX_IBM775 = -1;
static int ENCIDX_IBM852 = -1;
static int ENCIDX_IBM855 = -1;
static int ENCIDX_IBM857 = -1;
static int ENCIDX_IBM860 = -1;
static int ENCIDX_IBM861 = -1;
static int ENCIDX_IBM862 = -1;
static int ENCIDX_IBM863 = -1;
static int ENCIDX_IBM864 = -1;
static int ENCIDX_IBM865 = -1;
static int ENCIDX_IBM866 = -1;
static int ENCIDX_IBM869 = -1;
static int ENCIDX_ISO_8859_1 = -1;
static int ENCIDX_ISO_8859_10 = -1;
static int ENCIDX_ISO_8859_11 = -1;
static int ENCIDX_ISO_8859_13 = -1;
static int ENCIDX_ISO_8859_14 = -1;
static int ENCIDX_ISO_8859_15 = -1;
static int ENCIDX_ISO_8859_16 = -1;
static int ENCIDX_ISO_8859_2 = -1;
static int ENCIDX_ISO_8859_3 = -1;
static int ENCIDX_ISO_8859_4 = -1;
static int ENCIDX_ISO_8859_5 = -1;
static int ENCIDX_ISO_8859_6 = -1;
static int ENCIDX_ISO_8859_7 = -1;
static int ENCIDX_ISO_8859_8 = -1;
static int ENCIDX_ISO_8859_9 = -1;
static int ENCIDX_TIS_620 = -1;
static int ENCIDX_US_ASCII = -1;
static int ENCIDX_UTF_16 = -1;
static int ENCIDX_UTF_16BE = -1;
static int ENCIDX_UTF_16LE = -1;
static int ENCIDX_UTF_32 = -1;
static int ENCIDX_UTF_32BE = -1;
static int ENCIDX_UTF_32LE = -1;
static int ENCIDX_UTF_8 = -1;
static int ENCIDX_Windows_1250 = -1;
static int ENCIDX_Windows_1251 = -1;
static int ENCIDX_Windows_1252 = -1;
static int ENCIDX_Windows_1253 = -1;
static int ENCIDX_Windows_1254 = -1;
static int ENCIDX_Windows_1255 = -1;
static int ENCIDX_Windows_1256 = -1;
static int ENCIDX_Windows_1257 = -1;
static int ENCIDX_Windows_1258 = -1;

static unsigned char encset[32];

static inline bool
bitmask_test(unsigned char *bitmask, int bitidx, int bitmask_size) {
    if (bitidx < 0 || bitidx >= 8*bitmask_size)
        return false;

    int  n = bitmask_size - 1 - bitidx / 8;
    int  m = bitidx % 8;
    char c = *(bitmask + n);
    return (c >> m) & 0x1;
}

static void
bitmask_set(unsigned char *bitmask, int bitidx, int bitmask_size) {
    if (bitidx < 0 || bitidx >= 8*bitmask_size)
        return;

    int  n = bitmask_size - 1 - bitidx / 8;
    int  m = bitidx % 8;
    bitmask[n] |= (1 << m);
}

static bool
update_encidx(int encidx) {
    const char *encname;

    /* We've already assigned the encidx to an ENCIDX_xx global */
    if (bitmask_test(encset, encidx, 32))
        return false;

    /* Otherwise, match the "NAME" to the ENCIDX_NAME constant */
    encname = rb_enc_name(rb_enc_from_index(encidx));

#define TESTENC(name, id) if (0 == strncmp(name,encname,64)) {\
  ENCIDX_##id = encidx;\
  bitmask_set(encset, encidx, 32); \
  return true; \
}

    TESTENC("CP850",            CP850)  // US-ASCII+ https://en.wikipedia.org/wiki/Code_page_850
    TESTENC("CP852",            CP852)  // CP850+ https://en.wikipedia.org/wiki/Code_page_852
    TESTENC("CP855",            CP855)  // CP850+ https://en.wikipedia.org/wiki/Code_page_855

    TESTENC("IBM037",           IBM037) // EBCDIC https://en.wikipedia.org/wiki/Code_page_037
    TESTENC("IBM437",           IBM437) // ASCII+ https://en.wikipedia.org/wiki/Code_page_437
    TESTENC("IBM737",           IBM737) // IBM437+ https://en.wikipedia.org/wiki/Code_page_737
    TESTENC("IBM775",           IBM775) // IBM437+ https://en.wikipedia.org/wiki/Code_page_775
    TESTENC("IBM852",           IBM852) // IBM437+ https://en.wikipedia.org/wiki/Code_page_852
    TESTENC("IBM855",           IBM855) // IBM437+ https://en.wikipedia.org/wiki/Code_page_855
    TESTENC("IBM857",           IBM857) // IBM437+ https://en.wikipedia.org/wiki/Code_page_857
    TESTENC("IBM860",           IBM860) // IBM437+ https://en.wikipedia.org/wiki/Code_page_860
    TESTENC("IBM861",           IBM861) // IBM437+ https://en.wikipedia.org/wiki/Code_page_861
    TESTENC("IBM862",           IBM862) // IBM437+ https://en.wikipedia.org/wiki/Code_page_862
    TESTENC("IBM863",           IBM863) // IBM437+ https://en.wikipedia.org/wiki/Code_page_863
    TESTENC("IBM864",           IBM864) // IBM437+? https://en.wikipedia.org/wiki/Code_page_864
    TESTENC("IBM865",           IBM865) // IBM437+ https://en.wikipedia.org/wiki/Code_page_865
    TESTENC("IBM866",           IBM866) // IBM437+ https://en.wikipedia.org/wiki/Code_page_866
    TESTENC("IBM869",           IBM869) // IBM437+ https://en.wikipedia.org/wiki/Code_page_869

    TESTENC("ISO-8859-1",       ISO_8859_1)
    TESTENC("ISO-8859-2",       ISO_8859_2)
    TESTENC("ISO-8859-3",       ISO_8859_3)
    TESTENC("ISO-8859-4",       ISO_8859_4)
    TESTENC("ISO-8859-5",       ISO_8859_5)
    TESTENC("ISO-8859-6",       ISO_8859_6)
    TESTENC("ISO-8859-7",       ISO_8859_7)
    TESTENC("ISO-8859-8",       ISO_8859_8)
    TESTENC("ISO-8859-9",       ISO_8859_9)
    TESTENC("ISO-8859-10",      ISO_8859_10)
    TESTENC("ISO-8859-11",      ISO_8859_11)
    TESTENC("ISO-8859-13",      ISO_8859_13)
    TESTENC("ISO-8859-14",      ISO_8859_14)
    TESTENC("ISO-8859-15",      ISO_8859_15)
    TESTENC("ISO-8859-16",      ISO_8859_16)
    TESTENC("TIS-620",          TIS_620) // https://en.wikipedia.org/wiki/ISO/IEC_8859-11

    TESTENC("US-ASCII",         US_ASCII)

    TESTENC("UTF-8",            UTF_8)
    TESTENC("UTF-16",           UTF_16)
    TESTENC("UTF-16BE",         UTF_16BE)
    TESTENC("UTF-16LE",         UTF_16LE)
    TESTENC("UTF-32",           UTF_32)
    TESTENC("UTF-32BE",         UTF_32BE)
    TESTENC("UTF-32LE",         UTF_32LE)

    TESTENC("Windows-1250",     Windows_1250)
    TESTENC("Windows-1251",     Windows_1251)
    TESTENC("Windows-1252",     Windows_1252)
    TESTENC("Windows-1253",     Windows_1253)
    TESTENC("Windows-1254",     Windows_1254)
    TESTENC("Windows-1255",     Windows_1255)
    TESTENC("Windows-1256",     Windows_1256)
    TESTENC("Windows-1257",     Windows_1257)
    TESTENC("Windows-1258",     Windows_1258)

    return false;
}


/*
 * This performs a binary search on sorted disjoint intervals (sorted by each
 * interval's min). First it finds the largest min that's no larger than the
 * point; then it checks that point doesn't exceed that interval's max.
 *
 * Most queries will require descending all the way to a leaf, even if the
 * matching interval is further up the tree. That is because once a `min` is
 * found that is less than the point, we need to find the next smallest `min`.
 * Doing so amounts to descending to the leftmost leaf of the right subtree
 * of the current `min`.
 *
 * This means for around 700 intervals (the number of codepoint ranges that
 * cover Unicode graphical characters), about 10 iterations are required.
 *
 * TODO: Using an optimal binary tree might reduce the number of iterations,
 * but would increase the complexity -- using a contiguous region of memory
 * like an array provides good data locality, but some scheme would be needed
 * to represent a non-complete binary tree. The best approach might be to
 * allocate a contiguous block of memory and then use a linked representation.
 * But reducing most queries from 10 iterations to 1-2 might not improve much?
 */
static inline int
has_matching_interval(const unsigned int point,
                      const unsigned int *min,
                      const unsigned int *max,
                      const unsigned int size)
{
    int k, l, r, z;
    l = 0;
    r = size - 1;
    z = -1;

    for (l = 0, r = size - 1, z = -1;
         k = (l + r) / 2, l <= r;) {
        if (UNLIKELY(point > min[k]))
            l = (z = k) + 1;  // descend right
        else if (point < min[k])
            r = k - 1;        // descend left
        else
            break;
    }

    if (point < min[k])
        k = z;

    if (k >= 0 && point <= max[k])
        return true;

    return false;
}

// https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt

static inline bool
is_whitespace(const unsigned int c, const int encidx)
{
    if (encidx == ENCIDX_US_ASCII)
        return (c >= 0x08 && c <= 0x0d) || c == 0x20;
    else if (encidx == ENCIDX_UTF_8)
        return has_matching_interval(c,
            ucs_codepoints_whitespace_min,
            ucs_codepoints_whitespace_max,
            ucs_codepoints_whitespace_count);
    else if (encidx == ENCIDX_ISO_8859_1  ||
             encidx == ENCIDX_ISO_8859_2  ||
             encidx == ENCIDX_ISO_8859_3  ||
             encidx == ENCIDX_ISO_8859_4  ||
             encidx == ENCIDX_ISO_8859_5  ||
             encidx == ENCIDX_ISO_8859_6  ||
             encidx == ENCIDX_ISO_8859_7  ||
             encidx == ENCIDX_ISO_8859_8  ||
             encidx == ENCIDX_ISO_8859_9  ||
             encidx == ENCIDX_ISO_8859_10 ||
             encidx == ENCIDX_ISO_8859_11 ||
             encidx == ENCIDX_ISO_8859_13 ||
             encidx == ENCIDX_ISO_8859_14 ||
             encidx == ENCIDX_ISO_8859_15 ||
             encidx == ENCIDX_ISO_8859_16)
        return (c >= 0x08 && c <= 0x0d) || c == 0x20 || c == 0xa0;

    /* If nothing matched, it could be the first time we've seen this encoding
     * and we haven't assigned ENCIDX_XX yet. If so, update and retry */
    if (update_encidx(encidx))
        return is_whitespace(c, encidx);

    rb_raise(rb_eEncCompatError, "unsupported encoding: %s",
        rb_enc_name(rb_enc_from_index(encidx)));
}

/*
 * Letters, punctuation, symbols, ... have a visual representation
 *
 * Not control character   (e.g., <= 0x1f in US-ASCII)
 * Not undefined character (e.g.,  > 0x7f in US-ASCII)
 */
static bool
is_graphic(const unsigned int c, const int encidx)
{
    // https://en.wikipedia.org/wiki/Graphic_character
    // https://en.wikipedia.org/wiki/ISO/IEC_8859#Table

    if (encidx == ENCIDX_UTF_8)
        return has_matching_interval(c,
            ucs_codepoints_graphic_min,
            ucs_codepoints_graphic_max,
            ucs_codepoints_graphic_count);

    if (encidx == ENCIDX_US_ASCII)
        return (c >= 0x20 && c <= 0x7f);

    if (encidx == ENCIDX_ISO_8859_1  ||
        encidx == ENCIDX_ISO_8859_2  ||
        encidx == ENCIDX_ISO_8859_3  ||
        encidx == ENCIDX_ISO_8859_4  ||
        encidx == ENCIDX_ISO_8859_5  ||
        encidx == ENCIDX_ISO_8859_6  ||
        encidx == ENCIDX_ISO_8859_7  ||
        encidx == ENCIDX_ISO_8859_8  ||
        encidx == ENCIDX_ISO_8859_9  ||
        encidx == ENCIDX_ISO_8859_10 ||
        encidx == ENCIDX_ISO_8859_11 ||
        encidx == ENCIDX_ISO_8859_13 ||
        encidx == ENCIDX_ISO_8859_14 ||
        encidx == ENCIDX_ISO_8859_15 ||
        encidx == ENCIDX_ISO_8859_16)
        if (c >= 0x20 && c <= 0x7f)
            return true;

    if      (encidx == ENCIDX_ISO_8859_1)  return bitmask_test(iso_8859_graphic[0],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_2)  return bitmask_test(iso_8859_graphic[1],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_3)  return bitmask_test(iso_8859_graphic[2],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_4)  return bitmask_test(iso_8859_graphic[3],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_5)  return bitmask_test(iso_8859_graphic[4],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_6)  return bitmask_test(iso_8859_graphic[5],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_7)  return bitmask_test(iso_8859_graphic[6],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_8)  return bitmask_test(iso_8859_graphic[7],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_9)  return bitmask_test(iso_8859_graphic[8],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_10) return bitmask_test(iso_8859_graphic[9],  c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_11) return bitmask_test(iso_8859_graphic[10], c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_13) return bitmask_test(iso_8859_graphic[12], c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_14) return bitmask_test(iso_8859_graphic[13], c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_15) return bitmask_test(iso_8859_graphic[14], c-0xa0, 12);
    else if (encidx == ENCIDX_ISO_8859_16) return bitmask_test(iso_8859_graphic[15], c-0xa0, 12);

    /* If nothing matched, it could be the first time we've seen this encoding
     * and we haven't assigned ENCIDX_XX yet. If so, update and retry */
    if (update_encidx(encidx))
        return is_graphic(c, encidx);

    rb_raise(rb_eEncCompatError, "unsupported encoding: %s",
        rb_enc_name(rb_enc_from_index(encidx)));
}

static inline bool
single_byte_optimizable(VALUE str, rb_encoding *enc)
{
    if (ENC_CODERANGE(str) == ENC_CODERANGE_7BIT)
        return true;

    if (rb_enc_mbmaxlen(enc) == 1)
        return true;

    return false;
}

/*
 * call-seq:
 *   substr_eq?(s1, n1, s2, n2, length) -> bool
 *
 * Returns true if the substring of s1[n1, length] is equal to the
 * substring s2[n2, length]. This is more efficient than doing
 * `s1[...] == s2[...]` because it doesn't allocate a new String for
 * each substring before performing the comparison.
 *
 *   substr_eq?("abc ", 0, "xyz abc", 4, 2)  #=> true
 *   substr_eq?(" abc", 1, "xyz abc", 3, 2)  #=> true
 *   substr_eq?(" abc", 1, "xyz a_c", 3, 2)  #=> false
 */
static VALUE
rb_substr_eq_p(VALUE self, VALUE str1, VALUE _index1, VALUE str2, VALUE _index2, VALUE _length) {
    Check_Type(str1,    T_STRING);
    Check_Type(str2,    T_STRING);
    Check_Type(_index1, T_FIXNUM);
    Check_Type(_index2, T_FIXNUM);
    Check_Type(_length, T_FIXNUM);

    long len, idx1, idx2;
    len  = NUM2LONG(_length);
    idx1 = NUM2LONG(_index1);
    idx2 = NUM2LONG(_index2);

    if (UNLIKELY(len  < 0)) rb_raise(rb_eArgError, "length cannot be negative");
    if (UNLIKELY(idx1 < 0)) rb_raise(rb_eArgError, "index1 cannot be negative");
    if (UNLIKELY(idx2 < 0)) rb_raise(rb_eArgError, "index2 cannot be negative");

    if (UNLIKELY(ENCODING_GET(str1) != ENCODING_GET(str2)))
        rb_raise(rb_eEncCompatError, "incompatible character encodings: %s and %s",
            rb_enc_name(rb_enc_get(str1)),
            rb_enc_name(rb_enc_get(str2)));

    if (idx1 + len > rb_str_strlen(str1)) return Qnil;
    if (idx2 + len > rb_str_strlen(str2)) return Qnil;

    /* Number of bytes in str[idx, len], calculated by rb_str_subpos */
    long len1, len2;
    len1 = len;
    len2 = len;

    const char *ptr1, *ptr2;
    ptr1 = rb_str_subpos(str1, idx1, &len1);
    ptr2 = rb_str_subpos(str2, idx2, &len2);

    if (ptr1 == NULL || ptr2 == NULL) return Qnil;
    if (len1 != len2 || len1 < len)   return Qnil;
    return (memcmp(ptr1, ptr2, len) == 0) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   graphic_character?(s, index) -> bool or nil
 *
 * Returns true if the character s[index] is a graphic character
 *
 *   graphic_character?("x\t", 0) #=> true
 *   graphic_character?("x\t", 1) #=> false
 */
static VALUE
rb_graphic_p(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0],    T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE str;
    int encidx, len_;
    long len, idx;
    char *ptr, *end;
    rb_encoding *enc;
    unsigned int chr;

    str = argv[0];
    ptr = RSTRING_PTR(str);
    end = RSTRING_END(str);
    encidx = ENCODING_GET(str);
    idx = (argc == 1) ? 0 : FIX2LONG(argv[1]);
    len = 1;

    // Skip ahead to idx
    ptr = rb_str_subpos(str, idx, &len);

    if (!ptr || !len || ptr >= end)
        return Qnil;

    enc  = rb_enc_from_index(encidx);
    len_ = 1;
    chr  = rb_enc_codepoint_len(ptr, end, &len_, enc);

    if (!len_)
        return Qnil;

    return is_graphic(chr, encidx) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   whitespace?(s, index) -> bool or nil
 *
 * Returns true if the character s[index] is a graphic character
 *
 *   whitespace?("x\t", 0) #=> true
 *   whitespace?("x\t", 1) #=> false
 */
static VALUE
rb_whitespace_p(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0],    T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE str;
    int encidx, len_;
    long len, idx;
    char *ptr, *end;
    rb_encoding *enc;
    unsigned int chr;

    str = argv[0];
    ptr = RSTRING_PTR(str);
    end = RSTRING_END(str);
    encidx = ENCODING_GET(str);
    idx = (argc == 1) ? 0 : FIX2LONG(argv[1]);
    len = 1;

    // Skip ahead to idx
    ptr = rb_str_subpos(str, idx, &len);

    if (!ptr || !len || ptr >= end)
        return Qnil;

    enc  = rb_enc_from_index(encidx);
    len_ = 1;
    chr  = rb_enc_codepoint_len(ptr, end, &len_, enc);

    if (!len_)
        return Qnil;

    return is_whitespace(chr, encidx) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   min_graphic_index(string, index=0) -> int
 *
 * Description
 *
 *   min_graphic_index("\r\nabc ")     #=> 2
 *   min_graphic_index("\r\nabc ", 2)  #=> 2
 *   min_graphic_index("\r\nabc ", 5)  #=> 5
 */
static VALUE
rb_min_graphic_index(int argc, const VALUE *argv, VALUE self) {
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE str;
    int encidx;
    long idx;
    char *ptr, *end;
    rb_encoding *enc;

    str = argv[0];
    end = RSTRING_END(str);
    ptr = RSTRING_PTR(str);
    idx = (argc == 1) ? 0 : FIX2LONG(argv[1]);

    encidx = ENCODING_GET(str);
    enc = rb_enc_from_index(encidx);

    if (idx < 0)  rb_raise(rb_eArgError, "index cannot be negative");
    if (!ptr)     return INT2FIX(0);

    if (single_byte_optimizable(str, enc)) {
        ptr += idx;

        if (ptr >= end)
            return LONG2NUM(RSTRING_LEN(str));

        while (ptr < end && !is_graphic(*ptr, encidx))
            ptr ++;

        return LONG2NUM(ptr - RSTRING_PTR(str));
    }

    int len;
    long len_, count;
    unsigned int c;

    len_  = 1;
    count = 0;
    ptr   = rb_str_subpos(str, idx, &len_);

    if (!ptr || ptr >= end)
        return rb_str_length(str);

    while (ptr < end
      && (c = rb_enc_codepoint_len(ptr, end, &len, enc)) != 0
      && !is_graphic(c, encidx)) {
        ptr   += len;
        count ++;
    }

    return LONG2NUM(count);
}

/*
 * call-seq:
 *   min_nonspace_index(string, index=0) -> int
 *
 * Description
 *
 *   min_nonspace_index(" abc ")     #=> 1
 *   min_nonspace_index(" abc ", 2)  #=> 2
 *   min_nonspace_index(" abc ", 4)  #=> 5
 *
 *   s[min_nonspace_index(s)..-1]    == s.lstrip
 *   s[min_nonspace_index(s, n)..-1] == s[n..-1].lstrip
 */
static VALUE
rb_min_nonspace_index(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE str;
    int encidx;
    long idx;
    char *ptr, *end;
    rb_encoding *enc;

    str = argv[0];
    end = RSTRING_END(str);
    ptr = RSTRING_PTR(str);
    idx = (argc == 1) ? 0 : FIX2LONG(argv[1]);

    encidx = ENCODING_GET(str);
    enc = rb_enc_from_index(encidx);

    if (idx < 0)  rb_raise(rb_eArgError, "index cannot be negative");
    if (!ptr)     return INT2FIX(0);

    if (single_byte_optimizable(str, enc)) {
        ptr += idx;

        if (ptr >= end)
            return LONG2NUM(RSTRING_LEN(str));

        while (ptr < end && is_whitespace(*ptr, encidx))
            ptr ++;

        return LONG2NUM(ptr - RSTRING_PTR(str));
    }

    int len;
    long len_, count;
    unsigned int c;

    len_  = 1;
    count = 0;
    ptr   = rb_str_subpos(str, idx, &len_);

    if (!ptr || ptr >= end)
        return rb_str_length(str);

    while (ptr < end
      && (c = rb_enc_codepoint_len(ptr, end, &len, enc)) != 0
      && is_whitespace(c, encidx)) {
        ptr   += len;
        count ++;
    }

    return LONG2NUM(count);
}

/*
 * call-seq:
 *   max_nonspace_index(string, index=0) -> int
 *
 * Description
 *
 *   max_nonspace_index(" abc ")     #=> 3
 *   max_nonspace_index(" abc ", 2)  #=> 2
 *   max_nonspace_index(" abc ", 0)  #=> 0
 *
 *   s[0, max_nonspace_index(s)]    == s.rstrip
 *   s[0, max_nonspace_index(s, n)] == s[0..n].rstrip
 */
static VALUE
rb_max_nonspace_index() {
    return Qnil;
}


void Init_native_ext(void) {
    for (int n = 0; n < 32; n++)
        encset[n] = 0;

    VALUE rb_mStupidedi = rb_define_module("Stupidedi");
    VALUE rb_mReader    = rb_define_module_under(rb_mStupidedi, "Reader");
    VALUE rb_m          = rb_define_module_under(rb_mReader,    "NativeExt");

    rb_define_singleton_method(rb_m, "substr_eq?",          rb_substr_eq_p,          5);
    rb_define_singleton_method(rb_m, "graphic?",            rb_graphic_p,           -1);
    rb_define_singleton_method(rb_m, "whitespace?",         rb_whitespace_p,        -1);
    rb_define_singleton_method(rb_m, "min_graphic_index",   rb_min_graphic_index,   -1);
    rb_define_singleton_method(rb_m, "min_nonspace_index",  rb_min_nonspace_index,  -1);
    rb_define_singleton_method(rb_m, "max_nonspace_index",  rb_max_nonspace_index,  -1);
}
