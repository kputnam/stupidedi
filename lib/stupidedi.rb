require "bigdecimal"
require "time"
require "date"
require "continuation" if RUBY_VERSION >= "1.9"
require "blankslate"   if RUBY_VERSION <  "1.9"

# Monkey patches
require "ruby/tailcall"
require "ruby/symbol"
require "ruby/object"
require "ruby/module"
require "ruby/array"
require "ruby/hash"
require "ruby/exception"
require "ruby/enumerable"
require "ruby/string"
require "ruby/blank"
require "ruby/try"
require "ruby/to_d"
require "ruby/threadlocal"

module Stupidedi
  autoload :Either,       "stupidedi/either"

  autoload :Builder,      "stupidedi/builder"
  autoload :Dictionaries, "stupidedi/dictionaries"
  autoload :Editor,       "stupidedi/editor"
  autoload :Envelope,     "stupidedi/envelope"
  autoload :Guides,       "stupidedi/guides"
  autoload :Reader,       "stupidedi/reader"
  autoload :Schema,       "stupidedi/schema"
  autoload :Values,       "stupidedi/values"
  autoload :Writer,       "stupidedi/writer"
end
