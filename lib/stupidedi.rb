require "bigdecimal"
require "time"
require "date"

require "blankslate"   if RUBY_VERSION <  "1.9"
require "called_from"  if RUBY_VERSION <  "1.9"

# Monkey patches
require "ruby/symbol"
require "ruby/object"
require "ruby/module"
require "ruby/array"
require "ruby/hash"
require "ruby/count"
require "ruby/string"
require "ruby/blank"
require "ruby/try"
require "ruby/to_d"

#require "ruby/exception"
#require "continuation" if RUBY_VERSION >= "1.9"

module Stupidedi
  autoload :Either,       "stupidedi/either"

  autoload :Builder,      "stupidedi/builder"
  autoload :Config,       "stupidedi/config"
  autoload :Dictionaries, "stupidedi/dictionaries"
  autoload :Editor,       "stupidedi/editor"
  autoload :Envelope,     "stupidedi/envelope"
  autoload :Exceptions,   "stupidedi/exceptions"
  autoload :Guides,       "stupidedi/guides"
  autoload :Reader,       "stupidedi/reader"
  autoload :Schema,       "stupidedi/schema"
  autoload :Values,       "stupidedi/values"
  autoload :Writer,       "stupidedi/writer"

  autoload :TailCall,         "util/tail_call"
  autoload :ThreadLocalVar,   "util/thread_local"
  autoload :ThreadLocalHash,  "util/thread_local"

  autoload :AbsoluteSet,        "util/absolute_set"
  autoload :AbstractSet,        "util/abstract_set"
  autoload :EmptySet,           "util/empty_set"
  autoload :RelativeComplement, "util/relative_complement"
  autoload :RelativeSet,        "util/relative_set"
  autoload :UniversalSet,       "util/universal_set"
end
