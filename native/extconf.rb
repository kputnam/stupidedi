require "mkmf"

$warnflags.gsub!(/-Wdeclaration-after-statement/, "")

srcdir    = File.join(File.dirname(__FILE__), "stupidedi")
$srcs     = Dir["#{srcdir}/*.c",
                "#{srcdir}/lib/**/*.c",
                "#{srcdir}/bindings/**/*.c"]

# These bindings target the pre-b0aec7d2 bitmap.h/bitmap.c API, which was
# split into bitstr.h and packed.h. They haven't been ported to the current
# API yet, so exclude them until that's done.
$srcs -= Dir["#{srcdir}/bindings/{rb_bitmap,rb_rrr,rb_wavelet}.c"]

$CFLAGS   << " -std=c99 -Wpedantic -Werror=implicit-function-declaration"
$VPATH    << ":#{srcdir}:#{srcdir}/lib:#{srcdir}/bindings"
$INCFLAGS << " -I."

extension_name = "stupidedi/native/native"
dir_config      extension_name
create_makefile extension_name
