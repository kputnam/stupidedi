require "mkmf"

$warnflags.gsub!(/-Wdeclaration-after-statement/, "")

srcdir    = File.dirname(__FILE__)
$srcs     = Dir["#{srcdir}/*.c", "#{srcdir}/lib/**/*.c"]

$CFLAGS   << " -std=c99 -Wpedantic -Werror=implicit-function-declaration"
$VPATH    << " ${srcdir}/lib"
$INCFLAGS << " -I${srcdir}/lib"

extension_name = "stupidedi/native/native"
dir_config      extension_name
create_makefile extension_name
