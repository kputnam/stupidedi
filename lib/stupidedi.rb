require "bigdecimal"
require "time"
require "date"

require "blankslate"   if RUBY_VERSION < "1.9"
require "called_from"  if RUBY_VERSION < "1.9"

# Monkey patches

#require "ruby/exception"
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

module Stupidedi
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

  autoload :Sets,             "stupidedi/sets"
  autoload :Either,           "stupidedi/either"
  autoload :TailCall,         "stupidedi/tail_call"
  autoload :ThreadLocalVar,   "stupidedi/thread_local"
  autoload :ThreadLocalHash,  "stupidedi/thread_local"
end
