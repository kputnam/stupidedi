require "stupidedi"
require "benchmark"

N = 10_000_000

def one(a) nil; end
def two(a,b) nil; end
def three(a,b,c) nil; end
def four(a,b,c,d) nil; end
def five(a,b,c,d,e) nil; end
def six(a,b,c,d,e,f) nil; end
def seven(a,b,c,d,e,f,g) nil; end
def eight(a,b,c,d,e,f,g,h) nil; end

def implicit_return; 100; end
def explicit_return; return 100; end

Benchmark.bmbm(10) do |bm|
    single = %w(a)

  # puts "a. What's the cost of using #each to visit the item in a singleton list?"
  # bm.report("a. each") { N.times { single.each{|a| a } }}
  # bm.report("a. first") { N.times { if single.length == 1; single.first; end }}
  # Results:
  #   186: neither is consistently faster, less than 1% variance
  #   ree: neither is consistently faster, less than 1% variance
  #   192: first is 30% faster


  # puts "b. What is the cost of calling methods with more parameters?"
  # bm.report("b. one") { N.times { one(1) }}
  # bm.report("b. two") { N.times { two(1,2) }}
  # bm.report("b. three") { N.times { three(1,2,3) }}
  # bm.report("b. four") { N.times { four(1,2,3,4) }}
  # bm.report("b. five") { N.times { five(1,2,3,4,5) }}
  # bm.report("b. six") { N.times { six(1,2,3,4,5,6) }}
  # bm.report("b. seven") { N.times { seven(1,2,3,4,5,6,7) }}
  # bm.report("b. eight") { N.times { eight(1,2,3,4,5,6,7,8) }}


  # puts "c. What's the cost of 'coalescing' nil to a constant?"
  # bm.report("c. nil || 0") { N.times { nil || 0 }}
  # bm.report("c. nil") { N.times { nil }}


  # puts "d. Which method of runtime type dectection is fastest?"
  # bm.report("d. === true") { N.times { Array === %w(x) }}
  # bm.report("d. === false") { N.times { Array === "x" }}
  # bm.report("d. is_a? true") { N.times { %w(x).is_a?(Array) }}
  # bm.report("d. is_a? false") { N.times { "x".is_a?(Array) }}

    puts "e. How do explicit and implicit method returns compare?"
    bm.report("implicit") { N.times { implicit_return }}
    bm.report("explicit") { N.times { explicit_return }}
end
