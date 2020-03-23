#include <ruby.h>
#include <ruby/encoding.h>
#include <stdbool.h>
#include "stupidedi/include/codepoints.h"
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/bitmap.h"
#include "stupidedi/include/interval.h"

extern VALUE rb_str_length(VALUE _str);

/*
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
*/
static int ENCIDX_US_ASCII = -1;
static int ENCIDX_ISO_8859_1 = -1;
static int ENCIDX_ISO_8859_2 = -1;
static int ENCIDX_ISO_8859_3 = -1;
static int ENCIDX_ISO_8859_4 = -1;
static int ENCIDX_ISO_8859_5 = -1;
static int ENCIDX_ISO_8859_6 = -1;
static int ENCIDX_ISO_8859_7 = -1;
static int ENCIDX_ISO_8859_8 = -1;
static int ENCIDX_ISO_8859_9 = -1;
static int ENCIDX_ISO_8859_10 = -1;
static int ENCIDX_ISO_8859_11 = -1;
static int ENCIDX_ISO_8859_13 = -1;
static int ENCIDX_ISO_8859_14 = -1;
static int ENCIDX_ISO_8859_15 = -1;
static int ENCIDX_ISO_8859_16 = -1;
/*
static int ENCIDX_TIS_620 = -1;
static int ENCIDX_UTF_16 = -1;
static int ENCIDX_UTF_16BE = -1;
static int ENCIDX_UTF_16LE = -1;
static int ENCIDX_UTF_32 = -1;
static int ENCIDX_UTF_32BE = -1;
static int ENCIDX_UTF_32LE = -1;
*/
static int ENCIDX_UTF_8 = -1;
/*
static int ENCIDX_Windows_1250 = -1;
static int ENCIDX_Windows_1251 = -1;
static int ENCIDX_Windows_1252 = -1;
static int ENCIDX_Windows_1253 = -1;
static int ENCIDX_Windows_1254 = -1;
static int ENCIDX_Windows_1255 = -1;
static int ENCIDX_Windows_1256 = -1;
static int ENCIDX_Windows_1257 = -1;
static int ENCIDX_Windows_1258 = -1;
*/

/* This keeps track of which which encidx values we've seen. */
static stupidedi_bitmap_t known_encodings =
{
  .size = 256,
  .data = (uint64_t[]){0x0000000000000000ULL,0x0000000000000000ULL,
                       0x0000000000000000ULL,0x0000000000000000ULL}
};

/*
 * Ideally we could write a switch(encidx) { ... } statement to handle each
 * character encoding, but Ruby's public API doesn't export the encidx constants
 * for each encoding.
 *
 * It does let us lookup the name for a given encidx, but testing the encoding
 * name (encname == "US-ASCII") against multiple possible matches is expensive.
 * Especially when the test is repeated for every input character, to determine
 * if it's whitespace or a non-graphical character.
 *
 * We could enumerate all encodings in Init_native and assigned all ENCIDX_xx
 * constants at once, but many encodings are marked "autoload" and enumerating
 * them that way would eagerly load many encodings that won't actually be used.
 * It also may be possible encodings could be added later at runtime, after this
 * extension is loaded, so we'd miss those.
 *
 * This scheme only requires comparing the encoding name against known encodings
 * on the first time we see this particular encidx; from then on, we can just
 * compare the integer encidx with ENCIDX_xx.
 */

#define TESTENC(name, id) \
if (strncmp(name, encname, 64) == 0) { \
  ENCIDX_##id = encidx; \
  stupidedi_bitmap_set(&known_encodings, encidx); \
  return true; \
}

static bool
update_encdb(int encidx)
{
    const char *encname;

    /* We've already assigned the encidx to an ENCIDX_xx global */
    if ((encidx > 0 && (unsigned)encidx >= known_encodings.size) || stupidedi_bitmap_test(&known_encodings, encidx))
        return false;

    /* Otherwise, match the "NAME" to the ENCIDX_NAME constant */
    encname = rb_enc_name(rb_enc_from_index(encidx));

    TESTENC("US-ASCII",     US_ASCII)
    /*
    TESTENC("CP850",        CP850)  // US-ASCII+ https://en.wikipedia.org/wiki/Code_page_850
    TESTENC("CP852",        CP852)  // CP850+ https://en.wikipedia.org/wiki/Code_page_852
    TESTENC("CP855",        CP855)  // CP850+ https://en.wikipedia.org/wiki/Code_page_855
    TESTENC("IBM037",       IBM037) // EBCDIC https://en.wikipedia.org/wiki/Code_page_037
    TESTENC("IBM437",       IBM437) // ASCII+ https://en.wikipedia.org/wiki/Code_page_437
    TESTENC("IBM737",       IBM737) // IBM437+ https://en.wikipedia.org/wiki/Code_page_737
    TESTENC("IBM775",       IBM775) // IBM437+ https://en.wikipedia.org/wiki/Code_page_775
    TESTENC("IBM852",       IBM852) // IBM437+ https://en.wikipedia.org/wiki/Code_page_852
    TESTENC("IBM855",       IBM855) // IBM437+ https://en.wikipedia.org/wiki/Code_page_855
    TESTENC("IBM857",       IBM857) // IBM437+ https://en.wikipedia.org/wiki/Code_page_857
    TESTENC("IBM860",       IBM860) // IBM437+ https://en.wikipedia.org/wiki/Code_page_860
    TESTENC("IBM861",       IBM861) // IBM437+ https://en.wikipedia.org/wiki/Code_page_861
    TESTENC("IBM862",       IBM862) // IBM437+ https://en.wikipedia.org/wiki/Code_page_862
    TESTENC("IBM863",       IBM863) // IBM437+ https://en.wikipedia.org/wiki/Code_page_863
    TESTENC("IBM864",       IBM864) // IBM437+? https://en.wikipedia.org/wiki/Code_page_864
    TESTENC("IBM865",       IBM865) // IBM437+ https://en.wikipedia.org/wiki/Code_page_865
    TESTENC("IBM866",       IBM866) // IBM437+ https://en.wikipedia.org/wiki/Code_page_866
    TESTENC("IBM869",       IBM869) // IBM437+ https://en.wikipedia.org/wiki/Code_page_869
    */
    TESTENC("ISO-8859-1",   ISO_8859_1)
    TESTENC("ISO-8859-2",   ISO_8859_2)
    TESTENC("ISO-8859-3",   ISO_8859_3)
    TESTENC("ISO-8859-4",   ISO_8859_4)
    TESTENC("ISO-8859-5",   ISO_8859_5)
    TESTENC("ISO-8859-6",   ISO_8859_6)
    TESTENC("ISO-8859-7",   ISO_8859_7)
    TESTENC("ISO-8859-8",   ISO_8859_8)
    TESTENC("ISO-8859-9",   ISO_8859_9)
    TESTENC("ISO-8859-10",  ISO_8859_10)
    TESTENC("ISO-8859-11",  ISO_8859_11)
    TESTENC("ISO-8859-13",  ISO_8859_13)
    TESTENC("ISO-8859-14",  ISO_8859_14)
    TESTENC("ISO-8859-15",  ISO_8859_15)
    TESTENC("ISO-8859-16",  ISO_8859_16)
    /*
    TESTENC("TIS-620",      TIS_620) // https://en.wikipedia.org/wiki/ISO/IEC_8859-11
    */
    TESTENC("UTF-8",        UTF_8)
    /*
    TESTENC("UTF-16",       UTF_16)
    TESTENC("UTF-16BE",     UTF_16BE)
    TESTENC("UTF-16LE",     UTF_16LE)
    TESTENC("UTF-32",       UTF_32)
    TESTENC("UTF-32BE",     UTF_32BE)
    TESTENC("UTF-32LE",     UTF_32LE)
    TESTENC("Windows-1250", Windows_1250)
    TESTENC("Windows-1251", Windows_1251)
    TESTENC("Windows-1252", Windows_1252)
    TESTENC("Windows-1253", Windows_1253)
    TESTENC("Windows-1254", Windows_1254)
    TESTENC("Windows-1255", Windows_1255)
    TESTENC("Windows-1256", Windows_1256)
    TESTENC("Windows-1257", Windows_1257)
    TESTENC("Windows-1258", Windows_1258)
    */

    return false;
}

bool
is_whitespace(const unsigned int c, const int encidx)
{
    if (encidx == ENCIDX_US_ASCII)
        return (0x08 <= c && c <= 0x0d) || c == 0x20;

    else if (encidx == ENCIDX_UTF_8)
        return stupidedi_interval_list_test(c, &ucs_codepoints_whitespace);

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
        return (0x08 <= c && c <= 0x0d) || c == 0x20 || c == 0xa0;

    /* If nothing matched, it could be the first time we've seen this encoding
     * and we haven't assigned ENCIDX_XX yet. If so, update and retry */
    if (update_encdb(encidx))
        return is_whitespace(c, encidx);

    rb_raise(rb_eEncCompatError, "unsupported encoding: %s",
        rb_enc_name(rb_enc_from_index(encidx)));
}


/*
 * Letters, punctuation, symbols, ... have a visual representation
 */
bool
is_graphic(const unsigned int c, const int encidx)
{
    // https://en.wikipedia.org/wiki/Graphic_character
    // https://en.wikipedia.org/wiki/ISO/IEC_8859#Table

    if (encidx == ENCIDX_UTF_8)
        return stupidedi_interval_list_test(c, &ucs_codepoints_graphic);

    if (encidx == ENCIDX_US_ASCII)
        return (0x20 <= c && c < 0x7f);

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
        if (c < 0xa0)
            return (0x20 <= c && c < 0x7f);

    if      (encidx == ENCIDX_ISO_8859_1)  return stupidedi_bitmap_test(iso_8859_graphic + 0,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_2)  return stupidedi_bitmap_test(iso_8859_graphic + 1,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_3)  return stupidedi_bitmap_test(iso_8859_graphic + 2,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_4)  return stupidedi_bitmap_test(iso_8859_graphic + 3,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_5)  return stupidedi_bitmap_test(iso_8859_graphic + 4,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_6)  return stupidedi_bitmap_test(iso_8859_graphic + 5,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_7)  return stupidedi_bitmap_test(iso_8859_graphic + 6,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_8)  return stupidedi_bitmap_test(iso_8859_graphic + 7,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_9)  return stupidedi_bitmap_test(iso_8859_graphic + 8,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_10) return stupidedi_bitmap_test(iso_8859_graphic + 9,  c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_11) return stupidedi_bitmap_test(iso_8859_graphic + 10, c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_13) return stupidedi_bitmap_test(iso_8859_graphic + 12, c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_14) return stupidedi_bitmap_test(iso_8859_graphic + 13, c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_15) return stupidedi_bitmap_test(iso_8859_graphic + 14, c-0xa0);
    else if (encidx == ENCIDX_ISO_8859_16) return stupidedi_bitmap_test(iso_8859_graphic + 15, c-0xa0);

    /* If nothing matched, it could be the first time we've seen this encoding
     * and we haven't assigned ENCIDX_XX yet. If so, update and retry */
    if (update_encdb(encidx))
        return is_graphic(c, encidx);

    rb_raise(rb_eEncCompatError, "unsupported encoding: %s",
        rb_enc_name(rb_enc_from_index(encidx)));
}

/* True if each character in the string is a single byte */
static inline bool
single_byte_optimizable(VALUE _str, rb_encoding *enc)
{
    return ENC_CODERANGE(_str) == ENC_CODERANGE_7BIT
        || rb_enc_mbmaxlen(enc) == 1;
}


/*
 * call-seq:
 *   substr_eq?(str1, idx1, str2, idx2, length) -> bool
 *
 * Returns true if the substring str1[idx1, length] is equal to the substring
 * str2[idx2, length]. This is more efficient than doing `str1[...] == str2[...]`
 * because it doesn't allocate a new String for each substring before performing
 * the comparison.
 *
 *   substr_eq?("abc ", 0, "xyz abc", 4, 2)  #=> true
 *   substr_eq?(" abc", 1, "xyz abc", 3, 2)  #=> true
 *   substr_eq?(" abc", 1, "xyz a_c", 3, 2)  #=> false
 */
VALUE
rb_string_substr_eq_p(VALUE self, VALUE str1, VALUE _idx1, VALUE str2, VALUE _idx2, VALUE _length)
{
    Check_Type(str1,    T_STRING);
    Check_Type(str2,    T_STRING);
    Check_Type(_idx1,   T_FIXNUM);
    Check_Type(_idx2,   T_FIXNUM);
    Check_Type(_length, T_FIXNUM);

    long len, idx1, idx2;
    len  = NUM2LONG(_length);
    idx1 = NUM2LONG(_idx1);
    idx2 = NUM2LONG(_idx2);

    if (UNLIKELY(len  < 0)) rb_raise(rb_eArgError, "length cannot be negative");
    if (UNLIKELY(idx1 < 0)) rb_raise(rb_eArgError, "index1 cannot be negative");
    if (UNLIKELY(idx2 < 0)) rb_raise(rb_eArgError, "index2 cannot be negative");

    if (UNLIKELY(ENCODING_GET(str1) != ENCODING_GET(str2)))
        rb_raise(rb_eEncCompatError, "incompatible character encodings: %s and %s",
            rb_enc_name(rb_enc_get(str1)),
            rb_enc_name(rb_enc_get(str2)));

    if (rb_str_strlen(str1) < idx1 + len) return Qnil;
    if (rb_str_strlen(str2) < idx2 + len) return Qnil;

    long len1, len2;
    len1 = len;
    len2 = len;

    /* Request len _characters_ _str[idx,len]. Then len1, len2 will be number of _bytes_ */
    const char *ptr1, *ptr2;
    ptr1 = rb_str_subpos(str1, idx1, &len1);
    ptr2 = rb_str_subpos(str2, idx2, &len2);

    /* Number of bytes in str1[idx1,len] isn't equal to str2[idx2,len] */
    if (len1 != len2 || len1 < len)   return Qnil;
    if (ptr1 == NULL || ptr2 == NULL) return Qnil;
    return (memcmp(ptr1, ptr2, len) == 0) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   graphic_character?(s, idx) -> bool or nil
 *
 * Returns true if the character s[idx] is a graphic character
 *
 *   graphic_character?("x\t", 0) #=> true
 *   graphic_character?("x\t", 1) #=> false
 */
VALUE
rb_string_graphic_p(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    long len, idx;
    len = 1;
    idx = argc < 2 ? 0 : FIX2LONG(argv[1]);

    VALUE _str = argv[0];
    char *ptr, *end;
    end = RSTRING_END(_str);
    ptr = rb_str_subpos(_str, idx, &len); /* address of _str[idx], len is .bytesize */

    int encidx, len_;
    encidx = ENCODING_GET(_str);

    rb_encoding *enc;
    unsigned int chr;

    if (ptr == NULL || len == 0)
        return Qnil;

    len_ = 1;
    enc  = rb_enc_from_index(encidx);
    chr  = rb_enc_codepoint_len(ptr, end, &len_, enc);

    if (len_ == 0)
        return Qnil;

    return is_graphic(chr, encidx) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   whitespace?(s, idx) -> bool or nil
 *
 * Returns true if the character s[idx] is a graphic character
 *
 *   whitespace?("x\t", 0) #=> true
 *   whitespace?("x\t", 1) #=> false
 */
VALUE
rb_string_whitespace_p(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    long len, idx;
    len = 1;
    idx = argc < 2 ? 0 : FIX2LONG(argv[1]);

    VALUE _str = argv[0];
    char *ptr, *end;
    end = RSTRING_END(_str);
    ptr = rb_str_subpos(_str, idx, &len); /* address of _str[idx], len is .bytesize */

    int encidx, len_;
    encidx = ENCODING_GET(_str);

    rb_encoding *enc;
    unsigned int chr;

    if (ptr == NULL || len == 0)
        return Qnil;

    len_ = 1;
    enc  = rb_enc_from_index(encidx);
    chr  = rb_enc_codepoint_len(ptr, end, &len_, enc);

    if (len_ == 0)
        return Qnil;

    return is_whitespace(chr, encidx) ? Qtrue : Qfalse;
}

/*
 * call-seq:
 *   min_graphic_idx(string, idx=0) -> int
 *
 * Returns the smallest idx (starting from the given idx) that is a graphic
 * character. If no graphic characters occur after the given idx, then the
 * string length is returned.
 *
 *   min_graphic_idx("\r\nabc ")     #=> 2
 *   min_graphic_idx("\r\nabc ", 2)  #=> 2
 *   min_graphic_idx("\r\nabc ", 5)  #=> 5
 *   min_graphic_idx("\r\n")         #=> 2
 */
VALUE
rb_string_min_graphic_idx(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc >= 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE _str;
    _str = argv[0];

    char *ptr, *end;
    end = RSTRING_END(_str);
    ptr = RSTRING_PTR(_str);

    long idx;
    idx = argc < 2 ? 0 : FIX2LONG(argv[1]);

    int encidx;
    encidx = ENCODING_GET(_str);

    rb_encoding *enc;
    enc = rb_enc_from_index(encidx);

    if (idx < 0)     rb_raise(rb_eArgError, "index cannot be negative");
    if (ptr == NULL) return INT2FIX(0);

    if (single_byte_optimizable(_str, enc))
    {
        ptr += idx; /* address of _str[idx] */

        if (end <= ptr)
            return LONG2NUM(RSTRING_LEN(_str));

        while (ptr < end && !is_graphic(*ptr, encidx))
            ptr ++;

        return LONG2NUM(ptr - RSTRING_PTR(_str));
    }
    else
    {
      long len_, count;
      len_  = 1;
      count = 0;

      /* address of _str[idx], len is .bytesize */
      ptr = rb_str_subpos(_str, idx, &len_);
      if (ptr == NULL) return rb_str_length(_str);

      unsigned int c;
      int len;

      while (ptr < end)
      {
        c = rb_enc_codepoint_len(ptr, end, &len, enc);

        if (is_graphic(c, encidx))
            break;

        ptr   += len;
        count ++;
      }

      return LONG2NUM(idx + count);
    }
}

/*
 * call-seq:
 *   min_nongraphic_idx(string, idx=0) -> int
 *
 * Returns the smallest index (starting from the given index) that is not a
 * graphic character. If no non-graphic characters occur after the given index,
 * then the string length is returned.
 *
 *   min_nongraphic_idx("\r\nabc ")     #=> 2
 *   min_nongraphic_idx("\r\nabc ", 2)  #=> 2
 *   min_nongraphic_idx("\r\nabc ", 5)  #=> 5
 *   min_nongraphic_idx("\r\n")         #=> 2
 */
VALUE
rb_string_min_nongraphic_idx(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc >= 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE _str;
    _str = argv[0];

    char *ptr, *end;
    end = RSTRING_END(_str);
    ptr = RSTRING_PTR(_str);

    long idx;
    idx = argc < 2 ? 0 : FIX2LONG(argv[1]);

    int encidx;
    encidx = ENCODING_GET(_str);

    rb_encoding *enc;
    enc = rb_enc_from_index(encidx);

    if (idx < 0)      rb_raise(rb_eArgError, "index cannot be negative");
    if (ptr == NULL)  return INT2FIX(0);

    if (single_byte_optimizable(_str, enc))
    {
        ptr += idx; /* address of _str[idx] */

        if (end <= ptr)
            return LONG2NUM(RSTRING_LEN(_str));

        while (ptr < end && is_graphic(*ptr, encidx))
            ptr ++;

        return LONG2NUM(ptr - RSTRING_PTR(_str));
    }
    else
    {
      long len_, count;
      len_  = 1;
      count = 0;

      /* address of _str[idx], len is .bytesize */
      ptr = rb_str_subpos(_str, idx, &len_);
      if (ptr == NULL) return rb_str_length(_str);

      unsigned int c;
      int len;

      while (ptr < end)
      {
        c = rb_enc_codepoint_len(ptr, end, &len, enc);

        if (!is_graphic(c, encidx))
            break;

        ptr   += len;
        count ++;
      }

      return LONG2NUM(idx + count);
    }
}

/*
 * call-seq:
 *   min_nonspace_idx(string, idx=0) -> int
 *
 * Returns the smallest index (starting from the given index) that is not
 * whitespace. If non-whitespace does not occur before the given index, then
 * the length of the string is returned.
 *
 *   s[min_nonspace_idx(s)..-1]    == s.lstrip
 *   s[min_nonspace_idx(s, n)..-1] == s[n..-1].lstrip
 *
 *   min_nonspace_idx(" abc ")     #=> 1
 *   min_nonspace_idx(" abc ", 2)  #=> 2
 *   min_nonspace_idx(" abc ", 4)  #=> 5
 *   min_nonspace_idx("\r\n ")     #=> 4
 */
VALUE
rb_string_min_nonspace_idx(int argc, const VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc >= 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE _str;
    _str = argv[0];

    char *ptr, *end;
    end = RSTRING_END(_str);
    ptr = RSTRING_PTR(_str);

    long idx;
    idx = argc < 2 ? 0 : FIX2LONG(argv[1]);

    int encidx;
    encidx = ENCODING_GET(_str);

    rb_encoding *enc;
    enc = rb_enc_from_index(encidx);

    if (idx < 0)     rb_raise(rb_eArgError, "index cannot be negative");
    if (ptr == NULL) return INT2FIX(0);

    if (single_byte_optimizable(_str, enc))
    {
        ptr += idx; /* address of _str[idx] */

        if (end <= ptr)
            return LONG2NUM(RSTRING_LEN(_str));

        while (ptr < end && is_whitespace(*ptr, encidx))
            ptr ++;

        return LONG2NUM(ptr - RSTRING_PTR(_str));
    }
    else
    {
      long len_, count;
      len_  = 1;
      count = 0;

      /* address of _str[idx], len is .bytesize */
      ptr = rb_str_subpos(_str, idx, &len_);
      if (ptr == NULL) return rb_str_length(_str);

      unsigned int c;
      int len;

      while (ptr < end)
      {
        c = rb_enc_codepoint_len(ptr, end, &len, enc);

        if (!is_whitespace(c, encidx))
            break;

        ptr   += len;
        count ++;
      }

      return LONG2NUM(idx + count);
    }
}

/*
 * call-seq:
 *   max_nonspace_idx(string, idx=0) -> int
 *
 * Returns the largest index (starting from the given index) that is not
 * whitespace. If non-whitespace does not occur before the given index, then
 * the starting position is returned.
 *
 *   s[0, max_nonspace_idx(s)]    == s.rstrip
 *   s[0, max_nonspace_idx(s, n)] == s[0..n].rstrip
 *
 *   max_nonspace_idx(" abc ")     #=> 3
 *   max_nonspace_idx(" abc ", 2)  #=> 2
 *   max_nonspace_idx(" abc ", 0)  #=> 0
 *   max_nonspace_idx(" abc ", 0)  #=> 0
 */
VALUE
rb_string_max_nonspace_idx(int argc, VALUE *argv, VALUE self)
{
    rb_check_arity(argc, 1, 2);

    Check_Type(argv[0], T_STRING);
    if (argc == 2)
        Check_Type(argv[1], T_FIXNUM);

    VALUE _str;
    _str = argv[0];

    char *start, *end, *ptr;
    start = RSTRING_PTR(_str);
    end   = RSTRING_END(_str);

    long idx;
    idx = argc < 2 ? rb_str_strlen(_str) : FIX2LONG(argv[1]);

    int encidx;
    encidx = ENCODING_GET(_str);

    rb_encoding *enc;
    enc = rb_enc_from_index(encidx);

    if (idx < 0)        rb_raise(rb_eArgError, "index cannot be negative");
    if (start == NULL)  return INT2FIX(0);

    if (single_byte_optimizable(_str, enc))
    {
        ptr = start + idx; /* address of _str[idx] */

        if (end <= ptr)
            ptr = end - 1; /* start at the last character */

        while (start <= ptr && is_whitespace(*ptr, encidx))
            ptr --;

        return LONG2NUM(ptr - start);
    }
    else
    {
      long len, count;
      len   = 1;
      count = 0;

        /* address of _str[idx], len is .bytesize */
      ptr = rb_str_subpos(_str, idx, &len);
      if (ptr == NULL) return rb_str_length(_str);

      while (ptr != NULL && ptr < end)
      {
        unsigned int c = rb_enc_codepoint(ptr, end, enc);

        if (!is_whitespace(c, encidx))
            break;

        ptr = rb_enc_prev_char(start, ptr, end, enc);
        count ++;
      }

      return LONG2NUM(idx - count);
    }
}
