# encoding: UTF-8

module Stupidedi
  module Sets

    #
    # This data type encodes the complement of a {RelativeSet}, which is an
    # infinite and non-enumerable set of values.
    #
    class RelativeComplement < AbstractSet

      def initialize(complement)
        @complement = complement
      end

      # @return [void]
      def inspect
        "RelativeComplement(#{@complement.inspect})"
      end

      def include?(object)
        not @complement.include?(object)
      end

      # @return Infinity
      def size
        1.0 / 0.0
      end

      # @return false
      def finite?
        false
      end

      # @return false
      def empty?
        false
      end

      # @return [AbstractSet] other
      def replace(other)
        Sets.build(other)
      end

      # @group Set Operations
      #########################################################################

      # @return [AbstractSet]
      def complement
        # ¬(¬A) = A
        @complement
      end

      # @return [AbstractSet]
      def intersection(other)
        if other.is_a?(RelativeComplement)
          # ¬A ∩ ¬B = ¬(A ∪ B)
          complement.union(other.complement).complement
        else
          # ¬A ∩ B = B ∖ A
          Sets.build(other).difference(complement)
        end
      end

      # @return [AbstractSet]
      def union(other)
        if other.is_a?(RelativeComplement)
          # ¬A ∪ ¬B = ¬(A ∩ B)
          complement.intersection(other.complement).complement
        else
          # ¬A ∪ B = ¬(A ∖ B)
          complement.difference(Sets.build(other)).complement
        end
      end

      # @return [AbstractSet]
      def symmetric_difference(other)
        if other.is_a?(RelativeComplement)
          # ¬A ⊖ ¬B = (¬A ∖ ¬B) ∪ (¬B ∖ ¬A)
          #         =  (B ∖ A)  ∪ (A ∖ B)
          #         = A ⊖ B
          complement.symmetric_difference(other.complement)
        else
          # ¬A ⊖ B = (¬A ∖ B)  ∪ (B ∖ ¬A)
          #        = (¬A ∩ ¬B) ∪ (B ∩ A)
          #        = (¬B ∖ A)  ∪ (A ∖ ¬B)
          #        = A ⊖ ¬B
          other = Sets.build(other)

          intersection(other.complement).
            union(other.intersection(complement))
        end
      end

      # @return [AbstractSet]
      def difference(other)
        if other.is_a?(RelativeComplement)
          # ¬A ∖ ¬B = ¬A ∩ B = B ∖ A
          other.complement.difference(complement)
        else
          # ¬A ∖ B = ¬A ∩ ¬B = ¬(A ∪ B)
          complement.union(Sets.build(other)).complement
        end
      end

      # @endgroup
      #########################################################################

      # @group Set Ordering
      #########################################################################

      # @return [Boolean]
      def proper_subset?(other)
        other.is_a?(RelativeComplement) and intersection(other) == self
      end

      # @return [Boolean]
      def proper_superset?(other)
        other.is_a?(RelativeComplement) and intersection(other) == other
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.is_a?(RelativeComplement) and complement == other.complement)
      end

      # @endgroup
      #########################################################################
    end

  end
end
