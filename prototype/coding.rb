#!/usr/bin/env ruby
require "set"
require "pp"

C ||= Struct.new(:length, :bits)
E ||= Struct.new(:parent, :child)

class C
  def inv
    @inv ^= true
    self
  end

  def parent
    I.new(length - 1, bits >> 1) if length > 1
  end

  def ancestors(s = Set.new)
    c = self

    length.times do
      I.new(c.length - 1, c.bits >> 1).tap do |p|
        s << c
        s << E.new(p, c)
        c = p
      end
    end

    s
  end

  def to_s
    if length == 0
      "r"
    else
      bits.to_s(2).rjust(length, "0").then{|s| @inv ? s.reverse : s }
    end
  end

  def attrs(**more)
    "[%s]" % ({shape:"box"}.update(more).map{|x|'%s="%s"' % x }.join(","))
  end

  def inspect
    to_s
  end
end

class I < C
  def attrs(**more)
    "[%s]" % ({label:" ", shape:"circle"}.update(more).map{|x| '%s="%s"' % x }.join(","))
  end
end

class E
  def to_s
    "%s -- %s" % [parent, child]
  end

  def attrs(**more)
    label = (child.bits.even?) ? "0" : "1"
    "[%s]" % ({label:label}.update(more).map{|x| '%s="%s"' % x }.join(","))
  end
end

module Enumerable
  def sorted?
    each_cons(2).all?{|a,b| a <= b }
  end
end

def histogram(xs)
  xs.inject({}) do |h, x|
    h.update(x => h.fetch(x, 0) + 1)
  end
end

# returns s[i], k[i] where s[i] is the i-th least frequent symbol k[i] is the
# number of occurrences of the i-th least frequent symbol symbol
def tally(str)
  histogram(str.each_char).to_a.sort_by{|s,f| f }.transpose
end

# convert counts into probabilities
def prob(f)
  f.sum.to_f.tap do |total|
    return f.map!{|x| x / total }
  end
end

# compute average codeword length
def lavg(p, l)
  p.zip(l).sum{|a,b| a * b }
end

def kraft(c)
  c.each.with_index.sum{|v,l| v * (2.0 ** -l) }
end

# modify the probabilities to ensure certain coding systems(*) will not
# generate codes longer than the given `l`. (*: the coding algorithm must
# guarantee l[i] <= ⌈lg(p[i])⌉, where p[i] is probability of i-th symbol
# and l[i] is the assigned codeword length)
def scale(l, p)
  Math.log2(p.size).ceil.tap do |req|
    raise "at least #{req} bits are required to encode #{p.size} items" \
      if l < req
  end

  min         = 2.0 ** -l
  numerator   = 1
  denominator = p.sum.to_f

  raise unless denominator == 1
  raise unless p.sorted?

  n = p.size
  s = nil

  λ = (n - 1).times.find do |λ|
    s = numerator / denominator

    numerator   -= min
    denominator -= p[λ]

    s * p[λ+1] >= min
  end

  if λ > 0
    0.upto(λ)      {|i| p[i] = min }
    (λ+1).upto(n-1){|i| p[i] *= s  }
  end

  #puts "λ=#{λ}, s=#{s}"
  return p
end

# TODO
def locate(c, x)
  t = 0
  (c.size-1..0).step(-1).find do |l|
    t += c[l]
    x < t
  end
end

# _l is the maximum allowed codeword length
# p[i] is the probability of the i-th least probable symbol
#
# returns c, where c[i] is the number of codewords with length i
def coder(_l, p)
  raise unless p.sorted?

  # initial guess
  c = Array.new(_l + 1, 0)
  p.each{|p| c[(-Math.log2(p)).ceil - 1] += 1 }

  k = kraft(c)
  n = p.size

  n.times do |i|
    break if k <= 1
    l         = locate(c, i)
    c[l]     -= 1
    c[l + 1] += 1
    k        -= 2.0 ** -(l + 1)
    raise unless k == kraft(c)
  end

  c
end

###############################################################################
def coder_(_l, p)
  raise unless p.sorted?

  # initial guess
  c = Array.new(_l + 1, 0)
  p.each do |p|
    l = (-Math.log2(p)).ceil - 1
    raise unless l <= _l
    c[l] += 1
  end

  # find longest codeword and kraft sum
  k     = 0
  max_l = 0

  c.each.with_index do |n, l|
    k    += n * 2.0**-l
    max_l = l if n > 0
  end

  max_l.downto(0).each do |l|
    delta = k - 1
    break if delta <= 0

    unit  = 2.0 ** -(l + 1)
    count = (delta / unit).ceil
    count = c[l] if (count > c[l])

    c[l]     -= count
    c[l + 1] += count
    k        -= count * unit
    raise unless k == kraft(c)
  end

  c
end

###############################################################################

# shorten some codewords to by filling unused space
#   TODO: [0,0,1,3] becomes [0,0,2,2], why not [0,0,4]?
def fill(c)
  n = (c.size-1..0).step(-1).find{|l| c[l] > 0 }
  k = kraft(c)

  # look for unused space starting at top level
  n.times do |m|
    w = 2**-m

    # there's unused space at level m
    while k < 1 - w
      # find a node at a lower level to move up
      j = (m+1..n).find{|i| c[i] > 0 }

      c[m] += 1
      c[j] -= 1
      k += w - 2**-j
    end
  end

  c
end

# def sort(s, c)
#   c.reverse.inject([[], s.length - 1]) do |(s_, i), n|
#     [s_.concat(s[i-n+1..i].sort), i-n]
#   end.first
# end

# c[i] is number of codewords with length i
# traditional canonical huffman codeword assignment
def generate(c)
  code  = 0
  prev  = 1

  c.map.with_index do |n, l|
    n.times.map do
      code <<= (l - prev)
      prev = l
      C.new(l, code).tap { code +=  1 }
    end
  end
end

# c[i] is number of codewords with length i
# assigns codewords for use in a wavelet matrix
def generate_(c)
  q = [0, 1]
  x = 0
  y = c.each.with_index.sum{|v,l| v }

  (1..c.length-1).map do |l|
    c[l].times.map{ C.new(l, q.shift) }.tap do
      z = q.map{|x| (x << 1) | 0 }
      o = q.map{|x| (x << 1) | 1 }
      q = z.concat(o)
      x = [x, q.size].max
    end
  end.tap{ $stderr.puts "NUMBER OF SYMBOLS: #{y}\nMAX QUEUE SIZE: #{x}\n" }
end

# s[i] is the i-th least probable symbol
# m[i] is the list of codewords of length i
def assign(s, m)
  m.inject([{}, s.size - 1]) do |(h,i), cs|
    cs.inject([h, i]) do |(h,i), c|
      [h.update(s[i] => c), i - 1]
    end
  end.first
end

# q[s] is the codeword assigned to the symbol s
def draw(q)
  q      = q.invert
  inner  = Set.new
  edges  = Set.new
  leaves = q.keys.sort_by!{|l| [l.length, -l.bits] }
  family = leaves.inject(Set.new){|s,o| o.ancestors(s) }

  out = ["graph G {",
         "    nodesep=0.3;",
         "    ranksep=1;",
         "    margin=0.1;",
         '    node [fontname="Andale-Mono, Bold", fontsize=18];',
         '    edge [fontname="Andale-Mono", fontsize=12, arrowsize=0.8];',
         ""]

  out << '    r [label=" ", shape=circle];'
  inner = family.select{|x| x.class == I }
  inner.sort_by!{|i| [i.length, -i.bits] }
  inner.each{|i| out << "    #{i} #{i.attrs};" }

  out << ""
  leaves.each{|l| out << "    #{l} #{l.attrs(label:q.fetch(l))};" }

  out << ""
  edges = family.select{|x| x.class == E }
  edges.sort_by!{|e| [e.parent.length, -e.parent.bits] }
  edges.each{|e| out << "    #{e} #{e.attrs};" }

  out << "}"
  out.join("\n")
end

def main(_l, huffman=true)
  x    = (STDIN.tty?) ? File.read("test.txt") : STDIN.read
  s, f = tally(x)     .tap{|x| $stderr.puts "tally: #{x.inspect}\n\n" }
  p    = prob(f)      #tap{|x| $stderr.puts "prob:  #{x.inspect}\n\n" }
  p    = scale(_l, p) #tap{|x| $stderr.puts "scale: #{x.inspect}\n\n" }

  c    = huffman ? :coder : :coder_
  c    = send(c, _l, p) #tap{|x| $stderr.puts "coder: #{x.inspect}\n\n" }
  c    = fill(c)      #tap{|x| $stderr.puts "fill:  #{x.inspect}\n\n" }
  m    = huffman ? :generate : :generate_
  m    = send(m, c)   .tap{|x| $stderr.puts "gen:   #{x.inspect}\n\n" }
  q    = assign(s, m) .tap{|x| $stderr.puts "assign:#{x.inspect}\n\n" }
  #puts draw(q)

  $stderr.puts "lavg=#{lavg(p, s.map{|x| q.fetch(x).length})}, K=#{kraft(c)}"
end

if __FILE__ == $0
  main((ARGV[0] || 16).to_i, ARGV[1].nil?)
end

# This demonstrates the problem described in section 5 of "The Wavelet Matrix -
# An Efficient Wavelet Tree for Large Alphabets". For example,
#
#   >> puts "\n", table([C.new(5,8),C.new(5,12),C.new(5,16),C.new(6,32),C.new(6,48)])
#
#   l=1: 8  12 <|> 16 32 48
#   l=2: 16  32 <|> 8 12 48
#   l=3: 16  32  8  48 <|> 12
#   l=4: 16  32  8  48  12 <|> 
#   l=5: (16)  32  (8)  48  (12) <|> 
#   l=6: (32)  (48) <|> 
#
# You can see at l=5 that the leaves are not contiguous because there's an
# internal node 48 between the two leaves (8) and (12). The wavelet matrix
# requires all leaves are all the way to the left.
#
# m[i] is list of codewords with length i
def table(m)
  fmt      = lambda{|l,o| (l == o.length - 1 ? "(%s)" : "%s") % o }
  leaves = m.flatten

  (leaves.max_by(&:length).length).times.map do |l|
    leaves = leaves.select{|x| x.length > l}
    ze, on = leaves.partition{|x| x.bits[x.length - 1 - l].zero? }
    leaves = ze + on

    "l=%d: %s <|> %s" % [l+1, ze.map{|z|fmt[l,z]}.join("  "), on.map{|o|fmt[l,o]}.join(" ")]
  end
end
