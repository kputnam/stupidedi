require "mkmf"

$warnflags.gsub!(/-Wdeclaration-after-statement/, "")
$CFLAGS << " -std=c99"

extension_name = "stupidedi/reader/native_ext"
dir_config      extension_name
create_makefile extension_name
