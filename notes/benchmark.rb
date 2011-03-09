require "stupidedi"
require "benchmark"

N = 10_000_000

Benchmark.bmbm(10) do |bm|

  bm.report("=== true") do
    N.times { Array === %w(x) }
  end

  bm.report("=== false") do
    N.times { Array === "x" }
  end

  bm.report("is_a? true") do
    N.times { %w(x).is_a?(Array) }
  end

  bm.report("is_a? false") do
    N.times { "x".is_a?(Array) }
  end

end
