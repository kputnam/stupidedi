#!/usr/bin/env ruby -Ilib
require "stupidedi"
require "memory_profiler"

# This will be auto-enabled when $stdout.tty?, but -C forces color output
require "term/ansicolor" if ARGV.delete("-C")
if idx = ARGV.index("--format")
  ARGV.delete("--format")
  format = ARGV.delete_at(idx)
else
  format = "tree"
end

unless %w(html tree x12).include?(format)
  $stderr.puts "unrecognized format (expected html, tree, or x12)"
  exit(1)
end

config = Stupidedi::Config.contrib(Stupidedi::Config.hipaa(Stupidedi::Config.default))
parser = Stupidedi::Parser.build(config)
start  = Time.now

MemoryProfiler.report do
  ARGV.each do |path|
    mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
    puts "Startup: %0.2d MiB" % mem

    # Reading the entire input at once is slightly faster than streaming
    # from a file handle.
    #
    # content   = File.read(path, :encoding => "ISO-8859-1")
    # parser, r = parser.read(Stupidedi::Reader.build(content))
    #
    reader  = Stupidedi::Reader.build(File.read(path))
    parser, = parser.read(reader)

    mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
    puts "Finish : %0.2d MiB" % mem
  end
end.pretty_print(to_file: "prof/memprof-pp-#{start.strftime("%Y%m%dT%H%M%S")}.txt",
                 color_output: false, retained_strings: 100,
                 allocated_strings: 100, detailed_report: true,
                 scale_bytes: true)

mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
puts "Reports: %0.2d MiB" % mem

stop = Time.now
$stderr.puts "%0.3f seconds" % (stop - start)
