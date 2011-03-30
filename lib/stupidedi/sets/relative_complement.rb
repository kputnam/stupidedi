# encoding: UTF-8

module Stupidedi
  module Sets

    #
    # This data type is an infinite and non-enumerable set of values that
    # encodes the complement of a {RelativeSet}
    #
    class RelativeComplement < AbstractSet

      def initialize(complement)
        @complement = complement
      end

      # (see AbstractSet#include?)
      def include?(object)
        not @complement.include?(object)
      end

      # (see AbstractSet#size)
      # @return Infinity
      def size
        1.0 / 0.0
      end

      # (see AbstractSet#finite?)
      # @return false
      def finite?
        false
      end

      # (see AbstractSet#empty?)
      # @return false
      def empty?
        false
      end

      # (see AbstractSet#replace)
      def replace(other)
        Sets.build(other)
      end

      # @group Set Operations
      #########################################################################

      # (see AbstractSet#complement)
      def complement
        # ¬(¬A) = A
        @complement
      end

      # (see AbstractSet#intersection)
      def intersection(other)
        if other.is_a?(RelativeComplement)
          # ¬A ∩ ¬B = ¬(A ∪ B)
          complement.union(other.complement).complement
        else
          # ¬A ∩ B = B ∖ A
          Sets.build(other).difference(complement)
        end
      end

      # (see AbstractSet#union)
      def union(other)
        if other.is_a?(RelativeComplement)
          # ¬A ∪ ¬B = ¬(A ∩ B)
          complement.intersection(other.complement).complement
        else
          # ¬A ∪ B = ¬(A ∖ B)
          complement.difference(Sets.build(other)).complement
        end
      end

      # (see AbstractSet#symmetric_difference)
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

      # (see AbstractSet#difference)
      def difference(other)
        if other.is_a?(RelativeComplement)
          # ¬A ∖ ¬B = ¬A ∩ B = B ∖ A
          other.complement.difference(complement)
        else
          # ¬A ∖ B = ¬A ∩ ¬B = ¬(A ∪ B)
          complement.union(Sets.build(other)).complement
        end
      end

      # @group Set Ordering
      #########################################################################

      # (see AbstractSet#proper_subset?)
      def proper_subset?(other)
        other.is_a?(RelativeComplement) and intersection(other) == self
      end

      # (see AbstractSet#proper_superset?)
      def proper_superset?(other)
        other.is_a?(RelativeComplement) and intersection(other) == other
      end

      # (see AbstractSet#==)
      def ==(other)
        eql?(other) or
         (other.is_a?(RelativeComplement) and complement == other.complement)
      end

      # @group Pretty Printing
      #########################################################################

      # @return [String]
      def inspect
        "RelativeComplement(#{@complement.inspect})"
      end

      # @endgroup
      #########################################################################
    end

  end
end
