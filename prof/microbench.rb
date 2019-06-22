#!/usr/bin/env ruby
require "pp"
require "benchmark/ips"
require "memory_profiler"

GC.disable

def mem(label, &block)
  result = MemoryProfiler::Reporter.report(&block)
  print label.ljust(30); pp result.allocated_memory_by_class
end

XS = [1, 2, 3, 4].freeze

mem("<<") { s = ""; x = "x"; 1000.times { s << x }}
mem("+=") { s = ""; x = "x"; 1000.times { s += x }}

exit

###############################################################################

XS = [1, 2, 3, 4].freeze
RX = /\S/
RY = "abc"

puts "REGEXP MATCHING #{"="*64}"
mem("===")    { RX     === RY }
mem("not")    { not RX === RY }
mem("=~")     { RX     =~  RY }
mem("!~")     { RX     !~  RY }
mem("match?") { RX.match?(RY) }

###############################################################################

def cons_a(n, xs); i = 0; x = nil; while i < n; i += 1; x = [0] + xs          ;end;end
def cons_b(n, xs); i = 0; x = nil; while i < n; i += 1; x = [0, *xs]          ;end;end
def cons_c(n, xs); i = 0; x = nil; while i < n; i += 1; x = [0].push(*xs)     ;end;end
def cons_d(n, xs); i = 0; x = nil; while i < n; i += 1; x = xs.dup.unshift(0) ;end;end

puts
puts "CONS #{"="*73}"
mem("[0] + xs")          { cons_a(500_000, XS) }
mem("[0, *xs]")          { cons_b(500_000, XS) }
mem("[0].push(*xs)")     { cons_c(500_000, XS) }
mem("xs.dup.unshift(0)") { cons_d(500_000, XS) }

Benchmark.ips do |x|
  x.report("[0] + xs")          {|n| cons_a(n, XS) }
  x.report("[0, *xs]")          {|n| cons_b(n, XS) }
  x.report("[0].push(*xs)")     {|n| cons_c(n, XS) }
  x.report("xs.dup.unshift(0)") {|n| cons_d(n, XS) }
  x.compare!
end

###############################################################################

def snoc_a(n, xs); i = 0; x = nil; while i < n; i += 1; x = xs + [0]          ;end;end
def snoc_b(n, xs); i = 0; x = nil; while i < n; i += 1; x = [*xs, 0]          ;end;end
def snoc_c(n, xs); i = 0; x = nil; while i < n; i += 1; x = xs.dup.push(0)    ;end;end
def snoc_d(n, xs); i = 0; x = nil; while i < n; i += 1; x = [0, *xs.reverse].reverse ;end;end

puts
puts "SNOC #{"="*73}"
mem("xs + [5]")                 { snoc_a(500_000, XS) }
mem("[*xs, 5]")                 { snoc_b(500_000, XS) }
mem("xs.dup.push(5)")           { snoc_c(500_000, XS) }
mem("[5, *xs.reverse].reverse") { snoc_d(500_000, XS) }

Benchmark.ips do |x|
  x.report("xs + [5]")                 {|n| snoc_a(n, XS) }
  x.report("[*xs, 5]")                 {|n| snoc_b(n, XS) }
  x.report("xs.dup.push(5)")           {|n| snoc_c(n, XS) }
  x.report("[5, *xs.reverse].reverse") {|n| snoc_d(n, XS) }
  x.compare!
end

###############################################################################

mem = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
puts "Process: %0.2d MiB" % mem
