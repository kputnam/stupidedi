module Stupidedi

  #
  # BitmaskSubset is capable of computing set operations (& | ^ - < <= >= >)
  # with other BitmaskSubsets in constant time (best case) and linear time
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
  class BitmaskSubset

    # @return [Integer]
    attr_reader :mask

    # @return [Hash]
    attr_reader :universe

    def initialize(mask, universe)
      @mask, @universe = mask, universe.freeze
    end

    # Performs in constant time
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

    def full?
      @mask == (1 << @universe.size) - 1
    end

    # Performs in linear time proportional to the universe size
    # @return [Set]
    def values
      @universe.inject(Set.new) do |list, (value, n)|
        # Same as (@mask & (1 << n)).zero? but potentially eliminates
        # converting the intermediate computation to a Ruby value
        if @mask[n].zero?
          list
        else
          list << value
        end
      end
    end

    # @return [Integer]
    def size
      @universe.inject(0){|size, (value, n)| size + @mask[n] }
    end

    # Performs in linear time, proportional to the universe size, when {other}
    # is a subset of the same {universe}.
    #
    # @return [BitmaskSubset]
    def union(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask | other.mask, @universe)
        else
          other = other.values
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

    # Performs in linear time, proportional to the universe size, when {other}
    # is a subset of the same {universe}.
    #
    # @return [BitmaskSubset]
    def intersection(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask & other.mask, @universe)
        else
          other = other.values
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

    # Performs in linear time, proportional to the universe size, when {other}
    # is a subset of the same {universe}.
    #
    # @return [BitmaskSubset]
    def subtract(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask & ~other.mask, @universe)
        else
          other = other.values
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

    # Performs in linear time, proportional to the universe size, when {other}
    # is a subset of the same {universe}.
    #
    # @return [BitmaskSubset]
    def exclusion(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask ^ other.mask, @universe)
        else
          other = other.values
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

    # Performs in linear time, proportional to the universe size, when {other}
    # is a subset of the same {universe}.
    def subset?(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return @mask == other.mask & @mask
        else
          other = other.values
        end
      end

      vs = values
      vs == vs & other
    end

    def proper_subset?(other)
      other != self and subset?(other)
    end

    # Performs in linear time, proportional to the universe size, when {other}
    # is a subset of the same {universe}.
    def superset?(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return other.mask == other.mask & @mask
        else
          other = other.values
        end
      end

      other == other & values
    end

    def proper_superset?(other)
      other != self and superset?(other)
    end

    def ==(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return other.mask == @mask
        else
          other = other.values
        end
      end

      values == other
    end

    alias | union
    alias + union
    alias - subtract
    alias ^ exclusion
    alias & intersection
    alias < proper_subset?
    alias > proper_superset?
    alias <= subset?
    alias >= superset?

    alias subset intersection
    alias intersect intersection
  end

  class << BitmaskSubset

    # @return [BitmaskSubset]
    def build(values)
      count    = -1
      universe = values.inject({}){|hash, v| hash.update(v => (count += 1)) }

      BitmaskSubset.new((1 << (count + 1)) - 1, universe)
    end
  end

end
