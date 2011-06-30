module Stupidedi
  module Exceptions
    autoload :StupidediError,         "stupidedi/exceptions/stupidedi_error"
    autoload :InvalidElementError,    "stupidedi/exceptions/invalid_element_error"
    autoload :InvalidSchemaError,     "stupidedi/exceptions/invalid_schema_error"
    autoload :OutputError,            "stupidedi/exceptions/output_error"
    autoload :ParseError,             "stupidedi/exceptions/parse_error"
    autoload :TokenizeError,          "stupidedi/exceptions/tokenize_error"
    autoload :ZipperError,            "stupidedi/exceptions/zipper_error"
  end
end
