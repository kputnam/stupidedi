require "bigdecimal"
require "time"
require "date"
require "term/ansicolor" if $stdout.tty?

# Monkey patches

#equire "ruby/exception"
require "ruby/symbol"
require "ruby/object"
require "ruby/module"
require "ruby/array"
require "ruby/hash"
require "ruby/enumerable"
require "ruby/string"
require "ruby/blank"
require "ruby/try"
require "ruby/to_d"
require "ruby/instance_exec"

module Stupidedi
  autoload :Builder,      "stupidedi/builder"
  autoload :Config,       "stupidedi/config"
  autoload :Color,        "stupidedi/color"
  autoload :Versions,     "stupidedi/versions"
  autoload :Editor,       "stupidedi/editor"
  autoload :Exceptions,   "stupidedi/exceptions"
  autoload :Guides,       "stupidedi/guides"
  autoload :Reader,       "stupidedi/reader"
  autoload :Schema,       "stupidedi/schema"
  autoload :Values,       "stupidedi/values"
  autoload :Writer,       "stupidedi/writer"
  autoload :Zipper,       "stupidedi/zipper"

  autoload :Sets,             "stupidedi/sets"
  autoload :Either,           "stupidedi/either"
  autoload :Inspect,          "stupidedi/inspect"
  autoload :TailCall,         "stupidedi/tail_call"
  autoload :BlankSlate,       "stupidedi/blank_slate"
  autoload :ThreadLocalVar,   "stupidedi/thread_local"
  autoload :ThreadLocalHash,  "stupidedi/thread_local"

  # We can use a much faster implementation provided by the "called_from"
  # gem, but this only compiles against Ruby 1.8. Use this implementation
  # when its available, but fall back to the slow Kernel.caller method if
  # we have to
  if RUBY_VERSION < "1.9"
    require "called_from"
    def self.caller(depth = 2)
      ::Kernel.called_from(depth)
    end
  else
    def self.caller(depth = 2)
      ::Kernel.caller.at(depth).split(":")
    end
  end
end
