require "bigdecimal"
require "time"
require "date"
require "continuation" if RUBY_VERSION >= "1.9"

# Monkey patches
require "ruby/tailcall"
require "ruby/symbol"
require "ruby/object"
require "ruby/module"
require "ruby/array"
require "ruby/exception"
require "ruby/enumerable"
require "ruby/string"
require "ruby/try"
require "ruby/to_d"

module Stupidedi
  autoload :Either,       "stupidedi/either"
  autoload :Input,        "stupidedi/input"
  autoload :Reader,       "stupidedi/reader"

  autoload :Builder,      "stupidedi/builder"
  autoload :Dictionaries, "stupidedi/dictionaries"
  autoload :Editor,       "stupidedi/editor"
  autoload :Envelope,     "stupidedi/envelope"
  autoload :Reader,       "stupidedi/reader"
  autoload :Schema,       "stupidedi/schema"
  autoload :Values,       "stupidedi/values"
  autoload :Writer,       "stupidedi/writer"
end
