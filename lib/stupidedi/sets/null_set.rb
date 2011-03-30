# encoding: UTF-8

module Stupidedi
  module Sets

    # @private
    NullSet = Class.new(RelativeSet) do

      def initialize
      end

      # @return [NullSet]
      def build
        self
      end

      # Yields each element in the set to the implicit block argument. Since
      # there are no elements, the block is never executed
      #
      # @return [void]
      def each
      end

      # Returns an {Array} containing each element in this set. Since there are
      # no elements, the {Array} is empty
      #
      # @return [Array]
      def to_a
        []
      end

      # @return false
      def include?(other)
        false
      end

      # @return true
      def finite?
        true
      end

      # @return [Set] other
      def replace(other)
        Sets.build(other)
      end

      # @return 0
      def size
        0
      end

      # @return true
      def empty?
        true
      end

      # @group Set Operations
      #########################################################################

      # @return self
      def map
        self
      end

      # @return self
      def select
        self
      end

      # @return self
      def reject
        self
      end

      # @return UniversalSet
      def complement
        # ¬∅ = U
        UniversalSet.build
      end

      # @return self
      def intersection(other)
        # ∅ ∩ A = ∅
        self
      end

      # @return [Set] other
      def union(other)
        # ∅ ∪ A = A
        Sets.build(other)
      end

      # @return self
      def difference(other)
        # ∅ ∖ A = A
        self
      end

      # @return [Set] other
      def symmetric_difference(other)
        # ∅ ⊖ A = A
        Sets.build(other)
      end

      # @group Set Ordering
      #########################################################################

      def ==(other)
        eql?(other) or other.empty?
      end

      # @group Pretty Printing
      #########################################################################

      # @return [String]
      def inspect
        "NullSet"
      end

      # @endgroup
      #########################################################################
    end.new

  end
end
