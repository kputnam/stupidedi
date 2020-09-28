
# Managing Gigabytes
#
# 9.1 Text compression
# Table 9.1
#
#   n=5
#   i c code
#   -+-+----
#   1 1 0000
#   2 1 0001
#   3 1 001
#   4 3 01
#   5 4 1
#
#   n=6
#   i c code
#   -+-+-----
#   1 1 00000
#   2 1 00001
#   3 1 0001
#   4 3 001
#   5 4 01
#   6 7 1
#
#   n=7
#   i c  code
#   -+--+------
#   1  1 000000
#   2  1 000001
#   3  1 00001
#   4  3 0001
#   5  4 001
#   6  7 01
#   7 11 1
#
# Pathological sequence of symbol frequencies
#  F'(1) = 1
#  F'(2) = 1
#  F'(3) = 1
#  F'(4) = 3
#  F'(k+2) = F'(k+1) + F'(k) for k >= 2
#
# Figure 9.3 sketches the package-merge process
#

# Turpin and Moffat 1995, "Practical Length-Limited Coding for Large Alphabets"
#
#   For example in table 9.4, it is implicitly assumed that the items to the
#   left of the boundary line must be calculated; but in fact it's equally valid
#   to subtractively calculate items to the right of the boundary and there are
#   fewer of them
#
# Katajainen, Moffat, Turpin 1995, "A Fast and Space-Economical Algorithm for
#   Length-Limited Coding" Proc International Symposium on Algorithms and
#   Computation pg 12-21
#
#   it is also possible to calculate packages in an "on demand" manner and
#   release the space they occupy when the period of need for that package has
#   passed
#
# Moffat and Turpin 1998, "Efficient construction of minimum-redundancy code for
#   large alpdabets" IEEE Transactions on Information Theory
#
#   finally, the same run-length mechanisim as was sketched on p50 of chapter 2
#   for the standard huffman algorithm can be also employed
#
# Turpin and Moffat 1996, "Efficient implementation of the package-merge
#   paradigm for generating length-limited codes" Computing Australia Theory
#   Symposium
# Turpin 1998, "Efficient Prefix Coding (PhD thesis)" University of Melbourne
#
#   in combination, these techniques allow for implementation of package-merge
#   in surprisingly small amounts of space -- even for n=1,000,000 symbols, as
#   little as a few kilobytes above memory required to store the frequencies


$Z ||= Struct.new(:denom, :price)
$B = 2

class Coin < $Z
  def inspect
    "C(denom: #{$B}^#{denom}, price: #{price})"
  end

  def to_s
    inspect
  end

  def face
    $B**denom
  end
end

def C(*args)
  Coin.new(*args)
end

def package(as)
  denom = nil

  (0 .. as.length/2 - 1).map do |k|
    denom ||= (Math.log(as[2*k].face + as[2*k+1].face)/Math.log($B)).ceil
    Coin.new(denom, as[2*k].price + as[2*k+1].price)
  end
end

def mergesort(as, bs)
  ka = 0
  kb = 0

  (as.size + bs.size).times.map do
    if ka < as.size and (bs.size <= kb or as[ka].price < bs[kb].price)
      ka += 1
      as[ka - 1]
    else
      kb += 1
      bs[kb - 1]
    end
  end
end

def package_merge(target, coins)
  coins = coins.sort_by(&:price)
  coins = coins.group_by(&:denom)

  answer = []

  while target > 0
    denoms = Set.new(coins.keys)

    if coins.empty?
      return nil
    end

    d = denoms.min
    r = $B ** d
    m = $B ** target.to_s($B).reverse.index(/[^0]/)
    # p({d:d, r:r, m:m, denoms:denoms, coins:coins})

    if r > m
      return nil
    end

    if r == m
      answer.push(coins[d].shift)
      target -= m
    end

    coins[d+1] = mergesort(package(coins[d] || []), coins[d+1] || [])
    coins.delete(d)
    coins.delete(d+1) if coins[d+1].empty?
  end

  answer
end

def huffman(counts, length)
  # For each symbol, create "coins" with the market value associated with their
  # frequency and a face value from 2^(-1) down to 2^(-length). In total, we
  # will have |counts| * length "coins". Then use the package merge algorithm
  # to find a subset, with minimum market value, of coins whose face value sums
  # to n-1. Finally, the length of the Huffman code for each symbol is the
  # number of coins selected having its corresponding market value.
  #
  # Note we must first sort the symbols according to their frequency.

  if length < Math.log2(counts.size).ceil
    raise ArgumentError, "minimum code length is #{Math.log2(counts.size).ceil}"
  end

  leaves = counts.sort_by{|k,v| v }
  coins  = leaves.flat_map{|k,v| (1..length).map{|n| C(-n, v) }}

  package_merge(leaves.size - 1, coins)
end
