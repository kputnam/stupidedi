#!/usr/bin/env ruby -Ilib
require "stupidedi"
# require "memory_profiler"

config = Stupidedi::Config.contrib(Stupidedi::Config.hipaa(Stupidedi::Config.default))
parser = Stupidedi::Parser.build(config)
start  = Time.now

# MemoryProfiler.report do
  ARGV.each do |path|
    mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
    puts "Startup: %0.2d MiB" % mem

    reader  = Stupidedi::Reader.build(File.read(path))
    parser, = parser.read(reader)

    mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
    puts "Finish : %0.2d MiB" % mem
  end
# end.pretty_print(to_file: "prof/memprof-pp-#{start.strftime("%Y%m%dT%H%M%S")}.txt",
#                  color_output: false, retained_strings: 100,
#                  allocated_strings: 100, detailed_report: true,
#                  scale_bytes: true)

mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
puts "Reports: %0.2d MiB" % mem

stop = Time.now
$stderr.puts "%0.3f seconds" % (stop - start)
