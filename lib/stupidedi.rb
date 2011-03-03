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

module Stupidedi
  autoload :Either,       "stupidedi/either"
  autoload :Input,        "stupidedi/input"
  autoload :Reader,       "stupidedi/reader"

  autoload :Interchange,  "stupidedi/interchange"
  autoload :FiftyTen,     "stupidedi/5010"
  autoload :FortyTen,     "stupidedi/4010"
  autoload :Values,       "stupidedi/values"
end
