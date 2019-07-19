#include "ruby.h"
#include "extconf.h"

VALUE rb_strncmp(VALUE self, VALUE str1, VALUE offset1, VALUE str2, VALUE offset2, VALUE length) {
  // rb_raise(rb_eArgError, "message %s", "argument");

  if (!FIXNUM_P(length))  rb_raise(rb_eTypeError, "length must be an Integer");
  if (!FIXNUM_P(offset1)) rb_raise(rb_eTypeError, "offset1 must be an Integer");
  if (!FIXNUM_P(offset2)) rb_raise(rb_eTypeError, "offset1 must be an Integer");

  long len  = NUM2LONG(length);
  long beg1 = NUM2LONG(offset1);
  long beg2 = NUM2LONG(offset2);

  if (len < 0)  rb_raise(rb_eArgError, "length cannot be negative");
  if (beg1 < 0) rb_raise(rb_eArgError, "offset1 cannot be negative");
  if (beg2 < 0) rb_raise(rb_eArgError, "offset2 cannot be negative");

  if (beg1 + len > rb_str_strlen(str1)) return Qnil;
  if (beg2 + len > rb_str_strlen(str2)) return Qnil;

  char *ptr1 = rb_str_subpos(str1, beg1, &len);
  char *ptr2 = rb_str_subpos(str2, beg2, &len);

  if (ptr1 == 0 || ptr2 == 0) return Qnil;

  return (memcmp(ptr1, ptr2, len) == 0) ? Qtrue : Qfalse;
}

void Init_strncmp()
{
  // VALUE rb_cString = rb_define_class("String", rb_cObject);
  rb_define_singleton_method(rb_cString, "strncmp", rb_strncmp, 5);
}
