#
# AbsoluteSet is capable of computing set operations (& | ^ - < <= >= >)
# with other AbsoluteSet in constant time (best case) and linear time
# (worst case), instead of O(m*n), where m and n are the size of each set, as
# Ruby's Set class does.
#
# This is acheieved by keeping track of the set's universe, and encoding which
# elements are actually in the set as a bitmask. Set operations are performed
# with bitwise operations which take constant time (for Integers)
#
# Bitwise operations become slower when Ruby switches to Bignums, usually at
# 30 bits, but still perform in nearly constant time up to around 1024 bits.
# Past 1024 items (one bit per item), performance appears to be linear. What's
# probably happening is the number of machine words (n) required to represent
# the value is linear with respect to the value (eg with a 32-bit machine word
# a 2048 bit value requires 64 words), and computing the bitwise operation
# requires a constant operation -- n times.
#
# When performing operations on sets from different universes, the universes
# must be merged first.
#
class AbsoluteSet < AbstractSet
  # @return [Integer]
  attr_reader :mask

  # @return [Hash]
  attr_reader :universe

  def initialize(mask, universe)
    @mask, @universe = mask, universe.freeze
  end

  def include?(other)
    if bit = @universe.at(other)
      # Same as (@mask & (1 << n)).zero? but potentially eliminates
      # converting the intermediate computation to a Ruby value
      not @mask[bit].zero?
    end
  end

  def empty?
    @mask.zero?
  end

  # @return [Integer]
  def size
    @universe.inject(0){|size, (value, n)| size + @mask[n] }
  end

  # @return [AbsoluteSet]
  def complement
    self.class.new(~@mask, @universe)
  end

  # @return [AbsoluteSet]
  def union(other)
    if other.is_a?(self.class)
      if other.universe.eql?(@universe)
        return self.class.new(@mask | other.mask, @universe)
      else
        other = other.to_a
      end
    end

    # Create a new universe containing the current @universe and the values
    # from other. Calculate the mask for other's values in the new universe.
    # Our @mask will be the same in both universes
    mask     = 0
    universe = @universe.dup

    other.each do |x|
      unless bit = universe.at(x)
        bit = universe[x] = universe.length
      end

      mask |= (1 << bit)
    end

    self.class.new(mask | @mask, universe)
  end

  # @return [AbsoluteSet]
  def intersection(other)
    if other.is_a?(self.class)
      if other.universe.eql?(@universe)
        return self.class.new(@mask & other.mask, @universe)
      else
        other = other.to_a
      end
    end

    # The intersection does not need to merge universes as only the elements
    # in the current @universe can be in the intersection. We're computing
    # the mask of the items in other, relative to @universe
    mask = 0
    other.each do |x|
      if bit = @universe.at(x)
        mask |= (1 << bit)
      end
    end

    self.class.new(@mask & mask, @universe)
  end

  # @return [AbsoluteSet]
  def difference(other)
    if other.is_a?(self.class)
      if other.universe.eql?(@universe)
        return self.class.new(@mask & ~other.mask, @universe)
      else
        other = other.to_a
      end
    end

    mask = 0
    other.each do |x|
      if bit = @universe.at(x)
        mask |= (1 << bit)
      end
    end

    self.class.new(@mask & ~mask, @universe)
  end

  # @return [AbsoluteSet]
  def symmetric_difference(other)
    if other.is_a?(self.class)
      if other.universe.eql?(@universe)
        return self.class.new(@mask ^ other.mask, @universe)
      else
        other = other.to_a
      end
    end

    # Create a new universe containing the current @universe and the values
    # from other. Calculate the mask for other's values in the new universe.
    # Our @mask will be the same in both universes
    mask     = 0
    universe = @universe.dup

    other.each do |x|
      unless bit = universe.at(x)
        bit = universe[x] = universe.length
      end

      mask |= (1 << bit)
    end

    self.class.new(@mask ^ mask, universe)
  end

  # @return [AbsoluteSet]
  def replace(other)
    if other.is_a?(self.class)
      if other.universe.eql?(@universe)
        return other
      else
        other = other.to_a
      end
    end

    # Create a new universe containing the current @universe and the values
    # from other. Calculate the mask for other's values in the new universe.
    # Our @mask will be the same in both universes
    mask     = 0
    universe = @universe.dup

    other.each do |x|
      unless bit = universe.at(x)
        bit = universe[x] = universe.length
      end

      mask |= (1 << bit)
    end

    self.class.new(mask, universe)
  end

  def ==(other)
    if other.is_a?(self.class)
      if other.universe.eql?(@universe)
        return other.mask == @mask
      else
        other = other.to_a
      end
    end

    to_a == other
  end
end

class << AbsoluteSet

  # @return [AbsoluteSet]
  def build(values)
    count    = -1
    universe = values.inject({}){|hash, v| hash.update(v => (count += 1)) }

    AbsoluteSet.new((1 << (count + 1)) - 1, universe)
  end
end
