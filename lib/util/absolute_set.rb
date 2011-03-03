module Stupidedi

  #
  # AbsoluteSets are subsets of a finite, fully-enumerated universe set. This
  # means every possible value that can belong to the AbsoluteSet must already
  # belong to the universe set, which is a finite collection (Hash).
  #
  # This implementation is fairly efficient when computing set operations on two
  # sets from the same universe, especially compared to RelativeSet. Efficiency
  # is achieved by encoding which elements from the universe belong to the set
  # as a bitmask. Set operations can then be performed using bitwise operations,
  # instead of using operations on a Hash table.
  #
  # This data type is not suitable for sets whose elements belong to an infinite
  # universe of values, as each set requires 2**|U| bits of storage, where |U|
  # is the size of the universe. Operations on sets that belong to different
  # universes do not currently attempt to merge the two universe sets, as this
  # probably a better use case for RelativeSet.
  #
  class AbsoluteSet < AbstractSet
    include Enumerable

    # @return [Integer]
    attr_reader :mask

    # @return [Hash]
    attr_reader :universe

    def initialize(mask, universe)
      @mask, @universe = mask, universe.freeze
    end

    def copy(changes = {})
      self.class.new \
        changes.fetch(:mask, @mask),
        changes.fetch(:universe, @universe)
    end

    def each
      @universe.each do |value, n|
        unless @mask[n].zero?
          yield(value)
        end
      end
    end

    # @return [AbsoluteSet]
    def map
      mask = 0

      @universe.each do |value, n|
        unless @mask[n].zero?
          if m = @universe.at(yield(value))
            mask |= (1 << m)
          end
        end
      end

      copy(:mask => mask)
    end

    # @return [AbsoluteSet]
    def select
      mask = 0

      @universe.each do |value, n|
        unless @mask[n].zero? or not yield(value)
          mask |= (1 << n)
        end
      end

      copy(:mask => mask)
    end

    # @return [AbsoluteSet]
    def reject
      mask = 0

      @universe.each do |value, n|
        unless @mask[n].zero? or yield(value)
          mask |= (1 << n)
        end
      end

      copy(:mask => mask)
    end

    # @return [Boolean]
    def include?(element)
      if n = @universe.at(element)
        # Same as (@mask & (1 << n)).zero? but potentially eliminates
        # converting the intermediate computation to a Ruby value
        not @mask[n].zero?
      end
    end

    # @return [Boolean]
    def finite?
      true
    end

    # @return [Boolean]
    def empty?
      @mask.zero?
    end

    # @return [Integer]
    def size
      @universe.inject(0){|size, (value, n)| size + @mask[n] }
    end

    # @return [AbsoluteSet]
    def complement
      copy(:mask => ~@mask & ((1 << @universe.size) - 1))
    end

    # @return [AbsoluteSet]
    def union(other)
      if other.is_a?(self.class) and other.universe.eql?(@universe)
        copy(:mask => @mask | other.mask)
      else
        copy(:mask => @mask | as_mask(other))
      end
    end

    # @return [AbsoluteSet]
    def intersection(other)
      if other.is_a?(self.class) and other.universe.eql?(@universe)
        copy(:mask => @mask & other.mask)
      else
        copy(:mask => @mask & as_mask(other))
      end
    end

    # @return [AbsoluteSet]
    def difference(other)
      if other.is_a?(self.class) and other.universe.eql?(@universe)
        copy(:copy => @mask & ~other.mask)
      else
        copy(:copy => @mask & ~as_mask(other))
      end
    end

    # @return [AbsoluteSet]
    def symmetric_difference(other)
      if other.is_a?(self.class) and other.universe.eql?(@universe)
        copy(:copy => @mask ^ other.mask)
      else
        copy(:copy => @mask ^ as_mask(other))
      end
    end

    # @return [AbsoluteSet]
    def replace(other)
      if other.is_a?(self.class) and other.universe.eql?(@universe)
        other
      else
        copy(:mask => as_mask(other, true))
      end
    end

    # @return [Boolean]
    def ==(other)
      if other.is_a?(self.class) and other.universe.eql?(@universe)
        @mask == other.mask
      else
        @mask == as_mask(other)
      end
    end

  private

    # @return [Integer]
    def as_mask(other, strict = false)
      mask = 0

      # Unfortunately, computing our size is O(|U|) and other.size
      # might be O(|V|) so this is O(2*|U| + |V|) or O(2*|V| + |U|)
      if other.is_a?(AbstractSet) and (other.infinite? or size < other.size)
        @universe.each do |value, n|
          if other.include?(value)
            mask |= (1 << n)
          end
        end
      else
        # We might land here if other is an Array, since its probably
        # much worse to repeatedly call Array#include? than it is to
        # iterate the entire Array only once
        other.each do |x|
          if n = @universe.at(x)
            mask |= (1 << n)
          else
            raise "Universe does not contain element #{x.inspect}"
          end
        end
      end

      mask
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
end
