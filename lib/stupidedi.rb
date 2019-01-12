# frozen_string_literal: true
require "bigdecimal"
require "time"
require "date"
require "set"

begin
  require "term/ansicolor" if $stdout.tty?
rescue LoadError
  warn "terminal color disabled. gem install term-ansicolor to enable"
end

$:.unshift(File.expand_path("..", __FILE__))

require "ruby/symbol"
require "ruby/object"
require "ruby/module"
require "ruby/array"
require "ruby/hash"
require "ruby/string"
require "ruby/blank"
require "ruby/to_d"
require "ruby/to_date"
require "ruby/to_time"
require "ruby/try"
require "ruby/instance_exec"

module Stupidedi
  # @todo deprecated
  autoload :Builder,          "stupidedi/builder"
  autoload :Contrib,          "stupidedi/contrib"
  autoload :Guides,           "stupidedi/guides"

  autoload :Color,            "stupidedi/color"
  autoload :Config,           "stupidedi/config"
  autoload :Editor,           "stupidedi/editor"
  autoload :Either,           "stupidedi/either"
  autoload :Exceptions,       "stupidedi/exceptions"
  autoload :Inspect,          "stupidedi/inspect"
  autoload :Interchanges,     "stupidedi/interchanges"
  autoload :Parser,           "stupidedi/parser"
  autoload :Reader,           "stupidedi/reader"
  autoload :Schema,           "stupidedi/schema"
  autoload :Sets,             "stupidedi/sets"
  autoload :TransactionSets,  "stupidedi/transaction_sets"
  autoload :Values,           "stupidedi/values"
  autoload :Versions,         "stupidedi/versions"
  autoload :Writer,           "stupidedi/writer"
  autoload :Zipper,           "stupidedi/zipper"
  autoload :Versions,         "stupidedi/versions"
  autoload :VERSION,          "stupidedi/version"

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
      if k = ::Kernel.caller.at(depth - 1)
        k.split(":")
      end
    end
  end
end
