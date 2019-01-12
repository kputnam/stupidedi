#!/usr/bin/env ruby
require File.expand_path("../../lib/stupidedi", __FILE__)
require "pp"

using Stupidedi::Refinements

if ARGV.length != 1
  $stderr.puts "usage: #{$0} [file.x12]"
  exit
end

config = Stupidedi::Config.hipaa
reader = Stupidedi::Reader.build(File.read(ARGV[0]))

while (result = reader.read_segment).defined?
  segment_tok = result.fetch
  reader      = result.remainder

  pp segment_tok

  # @todo: Perhaps the code below should be built-into the tokenizer?  Normally
  # segment_dict is updated in the parser (in {FunctionalGroupState}), but if
  # users want to use the tokenizer directly, like we're doing here, then they
  # need to re-implement this.
  case segment_tok.id
  when :GS
    reader = result.remainder

    # GS08: Version / Release / Industry Identifier Code
    version = segment_tok.element_toks.at(7).try(:value)
    gscode  = version.try(:slice, 0, 6)

    # GS01: Functional Identifier Code
    fgcode = segment_tok.element_toks.at(0).try(:value)

    if config.functional_group.defined_at?(gscode)
      envelope_def = config.functional_group.at(gscode)
      envelope_val = envelope_def.empty
      segment_dict = reader.segment_dict.push(envelope_val.segment_dict)
      reader       = reader.copy(:segment_dict => segment_dict)
    end
  when :GE
    reader = reader.copy(:segment_dict => reader.segment_dict.pop)
  end
end
