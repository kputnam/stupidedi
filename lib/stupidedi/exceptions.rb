module Stupidedi
  module Exceptions
    autoload :StupidediError,         "stupidedi/exceptions/stupidedi_error"
    autoload :AmbiguousGrammarError,  "stupidedi/exceptions/ambiguous_grammar_error"
    autoload :InvalidSchemaError,     "stupidedi/exceptions/invalid_schema_error"
    autoload :ParseError,             "stupidedi/exceptions/parse_error"
    autoload :TokenizeError,          "stupidedi/exceptions/tokenize_error"
    autoload :ZipperError,            "stupidedi/exceptions/zipper_error"
  end
end
