module Stupidedi
  module Sets

    #
    # {AbstractSet} describes the common interface implemented by its concrete
    # subclasses. The two main implementations are {RelativeSet} and
    # {AbsoluteSet} which are each optimized for different kinds of set
    # operations.
    #
    class AbstractSet

      # True if the set includes the given +object+
      abstract :include?, :args => %w(object)

      # True if {#size} +< Infinity+
      abstract :finite?

      # True if {#size} +== 0+
      abstract :empty?

      # Returns the number of elements in the set
      #
      # @return [Numeric]
      abstract :size

      # @return [Set]
      abstract :replace, :args => %w(other)

      # True if the set contains infinitely many elements
      def infinite?
        not finite?
      end

      # @group Set Operations
      #########################################################################

      # @return [Set]
      abstract :complement

      # @return [Set]
      abstract :union, :args => %w(other)

      # @return [Set]
      abstract :difference, :args => %w(other)

      # @return [Set]
      abstract :symmetric_difference, :args => %w(other)

      # @return [Set]
      abstract :intersection, :args => %w(other)

      # @return [Set]
      def |(other) union(other) end

      # @return [Set]
      def +(other) union(other) end

      # @return [Set]
      def -(other) difference(other) end

      # @return [Set]
      def ~(other) complement(other) end

      # @return [Set]
      def ^(other) symmetric_difference(other) end

      # @return [Set]
      def  &(other) intersection(other) end

      # @return [Set]
      def <(other) proper_subset?(other) end

      # @return [Set]
      def >(other) proper_superset?(other) end

      # @return [Set]
      def <=(other) subset?(other) end

      # @return [Set]
      def >=(other) superset?(other) end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Set Ordering

      # @return [Boolean]
      abstract :==, :args => %w(other)

      def subset?(other)
        intersection(other) == self
      end

      def proper_subset?(other)
        other.size > size and subset?(other)
      end

      def superset?(other)
        intersection(other) == other
      end

      def proper_superset?(other)
        other.size < size and superset?(other)
      end

      def disjoint?(other)
        intersection(other).empty?
      end

      # @endgroup
      #########################################################################
    end

  end
end
