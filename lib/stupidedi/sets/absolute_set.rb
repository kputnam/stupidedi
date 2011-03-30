module Stupidedi
  module Sets

    #
    # {AbsoluteSet} is a subset of a finite, fully-enumerated universe set. This
    # means every possible value that can belong to the {AbsoluteSet} must
    # already belong to the universe set, which is a _finite_ collection.
    #
    # This implementation is fairly efficient when computing set operations on
    # two sets from the same universe, especially compared to {RelativeSet}.
    # Efficiency is achieved by encoding each element in the universe's
    # membership to the specific subset as a bitmask. Operations can then be
    # performed using bitwise operations, instead of using operations on a Hash.
    #
    # This data type is not suitable for sets whose elements belong to an
    # huge universe of possible values, as each set requires `2**|U|` bits of
    # storage where `|U|` is the size of the universe. Operations on sets that
    # belong to different universes do not currently attempt to merge the two
    # universe sets, as this probably a better use case for {RelativeSet}.
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

      # @private
      # @return [AbsoluteSet]
      def copy(changes = {})
        AbsoluteSet.new \
          changes.fetch(:mask, @mask),
          changes.fetch(:universe, @universe)
      end

      # Returns a single element from the set, with no guarantees about which
      # element. If the set is {#empty?}, the return value is undefined.
      def first
        @universe.each do |value, n|
          unless @mask[n].zero?
            return value
          end
        end
      end

      # Yields each element in the set to the implicit block argument
      #
      # @return [void]
      def each
        @universe.each do |value, n|
          unless @mask[n].zero?
            yield(value)
          end
        end
      end

      # (see AbstractSet#finite?)
      def finite?
        true
      end

      # (see AbstractSet#empty?)
      def empty?
        @mask.zero?
      end

      # (see AbstractSet#size)
      def size
        @universe.inject(0){|size, (value, n)| size + @mask[n] }
      end

      # (see AbstractSet#replace)
      def replace(other)
        if other.is_a?(AbstractSet)
          other
        else
          copy(:mask => as_mask(other, true))
        end
      end

      # (see AbstractSet#include?)
      def include?(element)
        if n = @universe.at(element)
          # Same as (@mask & (1 << n)).zero? but potentially eliminates
          # converting the intermediate computation to a Ruby value
          not @mask[n].zero?
        end
      end

      # @group Set Operations
      #########################################################################

      # @return [AbsoluteSet]
      def map
        mask = 0

        @universe.each do |value, n|
          unless @mask[n].zero?
            value = yield(value)

            if m = @universe.at(value)
              mask |= (1 << m)
            else
              raise "Universe does not contain element #{value.inspect}"
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

      # (see AbstractSet#complement)
      def complement
        copy(:mask => ~@mask & ((1 << @universe.size) - 1))
      end

      # (see AbstractSet#union)
      def union(other)
        if other.is_a?(AbsoluteSet) and other.universe.eql?(@universe)
          copy(:mask => @mask | other.mask)
        elsif other.is_a?(AbstractSet) and other.infinite?
          other.union(self)
        else
          copy(:mask => @mask | as_mask(other, true))
        end
      end

      # (see AbstractSet#intersection)
      def intersection(other)
        if other.is_a?(AbsoluteSet) and other.universe.eql?(@universe)
          copy(:mask => @mask & other.mask)
        elsif other.is_a?(AbstractSet) and other.infinite?
          other.intersection(self)
        else
          copy(:mask => @mask & as_mask(other, false))
        end
      end

      # (see AbstractSet#difference)
      def difference(other)
        if other.is_a?(AbsoluteSet) and other.universe.eql?(@universe)
          copy(:mask => @mask & ~other.mask)
        elsif other.is_a?(AbstractSet) and other.infinite?
          intersection(other.complement)
        else
          copy(:mask => @mask & ~as_mask(other, false))
        end
      end

      # (see AbstractSet#symmetric_difference)
      def symmetric_difference(other)
        if other.is_a?(AbsoluteSet) and other.universe.eql?(@universe)
          copy(:mask => @mask ^ other.mask)
        elsif other.is_a?(AbstractSet) and other.infinite?
          other.symmetric_difference(self)
        else
          copy(:mask => @mask ^ as_mask(other, true))
        end
      end

      # @group Set Ordering
      #########################################################################

      # (see AbstractSet#==)
      def ==(other)
        if other.is_a?(AbsoluteSet) and other.universe.eql?(@universe)
          @mask == other.mask
        elsif other.is_a?(AbstractSet) and other.infinite?
          false
        elsif other.is_a?(Enumerable)
          @mask == as_mask(other, false) and size == other.size
        end
      end

      # @group Pretty Printing
      #########################################################################

      # @return [void]
      def pretty_print(q)
        q.text("AbsoluteSet[#{size}/#{@universe.size}]")
        q.group(2, "(", ")") do
          q.breakable ""

          elements = to_a
          elements.take(5).each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          if elements.length > 5
            q.text ","
            q.breakable
            q.text "..."
          end
        end
      end

      # @return [String]
      def inspect
        "AbsoluteSet(#{to_a.map(&:inspect).join(', ')})"
      end

      # @endgroup
      #########################################################################

    private

      # @return [Integer]
      def as_mask(other, strict)
        mask = 0
        size = 0

        if other.is_a?(AbstractSet) and @universe.size < other.size
          @universe.each do |value, n|
            if other.include?(value)
              mask |= (1 << n)
              size += 1
            end
          end

          if strict and size < other.size
            # other is not a subset of @universe
            raise "Universe does not contain all elements from #{other.inspect}"
          end
        else
          # We might land here if other is an Array, since its probably
          # much worse to repeatedly call Array#include? than it is to
          # iterate the entire Array only once
          other.each do |x|
            if n = @universe.at(x)
              mask |= (1 << n)
            elsif strict
              raise "Universe does not contain element #{x.inspect}"
            end
          end
        end

        mask
      end

    end

    class << AbsoluteSet
      # @group Constructors
      #########################################################################

      # @return [AbsoluteSet]
      def build(values)
        count    = -1
        universe = values.inject({}){|hash, v| hash.update(v => (count += 1)) }

        new((1 << (count + 1)) - 1, universe)
      end

      # @endgroup
      #########################################################################
    end

  end
end
