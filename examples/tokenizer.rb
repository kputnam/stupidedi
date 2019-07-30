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
  tokenizer = Stupidedi::Reader::Tokenizer.build(input)

  result = tokenizer.each do |segment_tok|
    if segment_tok.is_a?(Stupidedi::Tokens::IgnoredTok)
      pp segment_tok
      next
    end

    pp segment_tok

    case segment_tok.id
    when :ISA
      version = segment_tok.element_toks.at(11)
      version = version.value.to_s if version

      if config.interchange.defined_at?(version)
        # Configure separators that depend on the ISA version
        envelope_def   = config.interchange.at(version)
        ver_separators = envelope_def.separators(segment_tok)
        tokenizer.separators = tokenizer.separators.merge(ver_separators)
      end
    when :GS
      # GS08: Version / Release / Industry Identifier Code
      version = segment_tok.element_toks.at(7).try(:value).try(:to_s)
      gscode  = version.try(:slice, 0, 6)

      # GS01: Functional Identifier Code
      fgcode = segment_tok.element_toks.at(0).try(:value)

      if config.functional_group.defined_at?(gscode)
        envelope_def = config.functional_group.at(gscode)
        envelope_val = envelope_def.empty
        tokenizer.segment_dict =
          tokenizer.segment_dict.push(envelope_val.segment_dict)
      end
    when :GE
      unless tokenizer.segment_dict.empty?
        tokenizer.segment_dict = tokenizer.segment_dict.pop
      end
    end
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
