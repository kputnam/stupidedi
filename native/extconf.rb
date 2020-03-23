require "mkmf"

$warnflags.gsub!(/-Wdeclaration-after-statement/, "")

srcdir    = File.join(File.dirname(__FILE__), "stupidedi")
$srcs     = Dir["#{srcdir}/*.c",
                "#{srcdir}/lib/**/*.c",
                "#{srcdir}/bindings/**/*.c"]

$CFLAGS   << " -std=c99 -Wpedantic -Werror=implicit-function-declaration"
$VPATH    << ":#{srcdir}:#{srcdir}/lib:#{srcdir}/bindings"
$INCFLAGS << " -I."

extension_name = "stupidedi/native/native"
dir_config      extension_name
create_makefile extension_name
