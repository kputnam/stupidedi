#!/usr/bin/env ruby -Ilib
require "stupidedi"
require "memory_profiler"
require "pp"

using Stupidedi::Refinements

if ARGV.length < 1
  $stderr.puts "usage: #{$0} [--fast] file.x12"
  exit
end

def run(config, tokenizer)
  mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  $stderr.puts "Pre-init: %0.2d MiB" % mem

  start = Time.now

  mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  $stderr.puts "Post-init: %0.2d MiB" % mem

  result = tokenizer.each do |segment_tok|
    if segment_tok.is_a?(Stupidedi::Reader::IgnoredTok)
      pp segment_tok
      next
    end

    puts segment_tok.id

    case segment_tok.id
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

  pp result

  mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  $stderr.puts "Finish: %0.2d MiB" % mem

  stop = Time.now
  $stderr.puts "%0.3f seconds" % (stop - start)
end

position =
  if ARGV.delete('--0-pos')
    Stupidedi::Reader::NoPosition

  elsif ARGV.delete('--1-pos')
    Stupidedi::Reader::OffsetPosition

  elsif ARGV.delete('--2-pos')
    Struct.new(:line, :column).include(Stupidedi::Reader::Position)

  elsif ARGV.delete('--3-pos')
    Struct.new(:name, :line, :column).include(Stupidedi::Reader::Position)

  elsif ARGV.delete('--4-pos')
    Struct.new(:name, :line, :column, :offset).include(Stupidedi::Reader::Position)

  else
    Stupidedi::Reader::NoPosition
  end

if ARGV.delete('--fast')
  config    = Stupidedi::Config.contrib
  input     = Stupidedi::Reader::Input.file(ARGV[0], position)
  tokenizer = Stupidedi::Reader::Tokenizer.build(input)
  run(config, tokenizer)
else
  start     = Time.now
  config    = Stupidedi::Config.contrib
  input     = Stupidedi::Reader::Input.file(ARGV[0], position)
  tokenizer = Stupidedi::Reader::Tokenizer.build(input)

  MemoryProfiler.report do
    run(config, tokenizer)
  end.pretty_print(to_file: "prof/memprof-tk-#{start.strftime("%Y%m%dT%H%M%S")}.txt",
                   color_output: false, retained_strings: 100,
                   allocated_strings: 100, detailed_report: true,
                   scale_bytes: true)
end
