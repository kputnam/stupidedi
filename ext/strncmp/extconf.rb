require "mkmf"
extension_name = "strncmp/strncmp"

create_header
dir_config      extension_name
create_makefile extension_name
