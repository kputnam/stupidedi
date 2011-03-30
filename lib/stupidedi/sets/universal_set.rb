module Stupidedi
  module Sets

    # @private
    UniversalSet = Class.new(RelativeComplement) do

      def initialize
      end

      # @return [UniversalSet]
      def build
        self
      end

      # @return true
      def include?(object)
        true
      end

      # @return false
      def finite?
        false
      end

      # @return Infinity
      def size
        1.0 / 0.0
      end

      # @return false
      def empty?
        false
      end

      # @return [AbstractSet]
      def replace(other)
        Sets.build(other)
      end

      # @group Set Operations
      #########################################################################

      # @return NullSet
      def complement
        # ¬U = ∅
        NullSet.build
      end

      # @return [AbstractSet]
      def intersection(other)
        # U & A = A
        Sets.build(other)
      end

      # @return [AbstractSet]
      def union(other)
        # U ∪ A = U
        self
      end

      # @return [AbstractSet]
      def symmetric_difference(other)
        # U ⊖ A = (U ∖ A) ∪ (A ∖ U) = (¬A) ∪ (∅) = ¬A
        Sets.complement(other)
      end

      # @return [AbstractSet]
      def difference(other)
        # U ∖ A = ¬A
        Sets.complement(other)
      end

      # @group Set Ordering
      #########################################################################

      # @return [Boolean]
      def proper_subset?(other)
        false
      end

      # @return [Boolean]
      def proper_superset?(other)
        not other.eql?(self)
      end

      # @return [Boolean]
      def ==(other)
        eql?(other)
      end

      # @group Pretty Printing
      #########################################################################

      # @return [String]
      def inspect
        "UniversalSet"
      end

      # @endgroup
      #########################################################################
    end.new

  end
end
