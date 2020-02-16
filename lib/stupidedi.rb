# frozen_string_literal: true
require "bigdecimal"
require "pathname"
require "time"
require "date"
require "set"

begin
  require "term/ansicolor" if $stdout.tty?
rescue LoadError
  warn "terminal color disabled. gem install term-ansicolor to enable"
end

require_relative "stupidedi/ruby/regexp"
require_relative "stupidedi/ruby/array"
require_relative "stupidedi/ruby/blank"
require_relative "stupidedi/ruby/exception"
require_relative "stupidedi/ruby/hash"
require_relative "stupidedi/ruby/module"
require_relative "stupidedi/ruby/object"
require_relative "stupidedi/ruby/string"
require_relative "stupidedi/ruby/to_d"
require_relative "stupidedi/ruby/to_date"
require_relative "stupidedi/ruby/to_time"
require_relative "stupidedi/ruby/try"

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
  autoload :Native,           "stupidedi/native"
  autoload :Parser,           "stupidedi/parser"
  autoload :Position,         "stupidedi/position"
  autoload :Reader,           "stupidedi/reader"
  autoload :Schema,           "stupidedi/schema"
  autoload :Sets,             "stupidedi/sets"
  autoload :Tokens,           "stupidedi/tokens"
  autoload :TransactionSets,  "stupidedi/transaction_sets"
  autoload :Values,           "stupidedi/values"
  autoload :Versions,         "stupidedi/versions"
  autoload :Writer,           "stupidedi/writer"
  autoload :Zipper,           "stupidedi/zipper"
  autoload :Versions,         "stupidedi/versions"
  autoload :VERSION,          "stupidedi/version"

  def self.caller(offset = 2)
    if k = ::Kernel.caller(offset, 1).first
      k.split(":")
    end
  end
end
