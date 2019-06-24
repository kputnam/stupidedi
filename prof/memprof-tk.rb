#!/usr/bin/env ruby -Ilib
require "stupidedi"
require "memory_profiler"
require "pp"

using Stupidedi::Refinements

if ARGV.length < 1
  $stderr.puts "usage: #{$0} [--fast] file.x12"
  exit
end

def run(config, input, state)
  mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  $stderr.puts "Pre-init: %0.2d MiB" % mem

  start  = Time.now

  mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  $stderr.puts "Post-init: %0.2d MiB" % mem

  result = Stupidedi::Reader::Tokenizer.next_isa_segment(input, state)

  until result.fail?
    segment_tok = result.value
    #p segment_tok.segment_id

    if false
    case segment_tok.segment_id
    when "GS"
       # GS08: Version / Release / Industry Identifier Code
       version = segment_tok.element_toks.at(7).try(:value).try(:to_s)
       gscode  = version.try(:slice, 0, 6)
 
       # GS01: Functional Identifier Code
       fgcode = segment_tok.element_toks.at(0).try(:value)
 
       if config.functional_group.defined_at?(gscode)
         envelope_def = config.functional_group.at(gscode)
         envelope_val = envelope_def.empty
         segment_dict = state.segment_dict.push(envelope_val.segment_dict)
         state.segment_dict = segment_dict
       end
    when "GE"
      unless state.segment_dict.empty?
        segment_dict = state.segment_dict.pop
        state.segment_dict = segment_dict
      end
    end
    end

    result = Stupidedi::Reader::Tokenizer.next_segment(result.rest, state)
  end

  # pp result
  # puts

  mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  $stderr.puts "Finish: %0.2d MiB" % mem

  stop = Time.now
  $stderr.puts "%0.3f seconds" % (stop - start)
end

if ARGV.delete('--fast')
  config = Stupidedi::Config.contrib
  input  = Stupidedi::Reader::Pointer.build(File.read(ARGV[0]))
  state  = Stupidedi::Reader::Tokenizer::State.todo
  run(config, input, state)
else
  config = Stupidedi::Config.contrib
  input  = Stupidedi::Reader::Pointer.build(File.read(ARGV[0]))
  state  = Stupidedi::Reader::Tokenizer::State.todo
  start = Time.now

  MemoryProfiler.report do
    run(config, input, state)
  end.pretty_print(to_file: "prof/memprof-tk-#{start.strftime("%Y%m%dT%H%M%S")}.txt",
                   color_output: false, retained_strings: 100,
                   allocated_strings: 100, detailed_report: true,
                   scale_bytes: true)
end
