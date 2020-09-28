#!/usr/bin/env ruby -Ilib
require "stupidedi"
require "pp"

using Stupidedi::Refinements

if ARGV.length != 1
  $stderr.puts "usage: #{$0} [file.x12]"
  exit
end

def run(config, path, position)
  input     = Stupidedi::Reader::Input.file(path, position: position)
  tokenizer = Stupidedi::Reader::Tokenizer.build(input, config)

  result = tokenizer.each do |segment_tok|
    if segment_tok.is_a?(Stupidedi::Tokens::IgnoredTok)
      pp segment_tok
      next
    end

    pp segment_tok
  end

  if result.fatal?
    raise "#{result.error} at #{result.position}"
  else
    puts "#{result.error} at #{result.position}"
  end
end

position =
  Stupidedi::Position::NoPosition
  # Stupidedi::Position::OffsetPosition
  # Struct.new(:line, :column).include(Stupidedi::Position)
  # Struct.new(:name, :line, :column).include(Stupidedi::Position)
  # Struct.new(:name, :line, :column, :offset).include(Stupidedi::Position)

config = Stupidedi::Config.contrib(Stupidedi::Config.hipaa)
run(config, ARGV[0], position)
