module Stupidedi
  module Sets

    #
    # {AbstractSet} describes the common interface implemented by its concrete
    # subclasses. The two main implementations are {RelativeSet} and
    # {AbsoluteSet} which are each optimized for different kinds of set
    # operations.
    #
    class AbstractSet
      include Inspect

      # True if the set includes the given `object`
      abstract :include?, :args => %w(object)

      # True if {#size} `< Infinity`
      abstract :finite?

      # True if {#size} `== 0`
      abstract :empty?

      # Returns the number of elements in the set
      #
      # @return [Numeric]
      abstract :size

      # Returns the `other` set, converting it to an {AbstractSet} if it isn't
      # already.
      #
      # @return [AbstractSet]
      abstract :replace, :args => %w(other)

      # True if the set contains infinitely many elements
      def infinite?
        not finite?
      end

      # @group Set Operations
      #########################################################################

      # (see AbstractSet#~)
      # @abstract
      abstract :complement

      # (see AbstractSet#|)
      # @abstract
      abstract :union, :args => %w(other)

      # (see AbstractSet#-)
      # @abstract
      abstract :difference, :args => %w(other)

      # (see AbstractSet#^)
      # @abstract
      abstract :symmetric_difference, :args => %w(other)

      # (see AbstractSet#&)
      # @abstract
      abstract :intersection, :args => %w(other)

      # Computes the union of two sets: the set of elements in _either_ or
      # _both_ sets
      #
      # @return [AbstractSet]
      #
      # @see http://en.wikipedia.org/wiki/Union_(set_theory)
      def |(other) union(other) end

      # (see AbstractSet#|)
      def +(other) union(other) end

      # Computes the difference of two sets: the set of elements elements in
      # _this_ set and not the _other_.
      #
      # @return [AbstractSet]
      #
      # @see http://en.wikipedia.org/wiki/Set_difference#Relative_complement
      def -(other) difference(other) end

      # Computes the complement of the set: the set of elements _not_ in this
      # set
      #
      # @return [AbstractSet]
      #
      # @see http://en.wikipedia.org/wiki/Complement_(set_theory)
      def ~; complement end

      # Computes the symmetric difference of two sets: the set of elements which
      # are in _either_ of the two sets but _not_ in both.
      #
      # @return [AbstractSet]
      #
      # @see http://en.wikipedia.org/wiki/Symmetric_difference
      def ^(other) symmetric_difference(other) end

      # Computes the intersection of two sets: the set of elements common
      # between _both_ sets.
      #
      # @return [AbstractSet]
      #
      # @see http://en.wikipedia.org/wiki/Intersection_(set_theory)
      def &(other) intersection(other) end

      # @endgroup
      #########################################################################

      # @group Set Ordering
      #########################################################################

      # True if every element in this set also belongs to the `other` set
      #
      # @see http://en.wikipedia.org/wiki/Subset
      def subset?(other)
        intersection(other) == self
      end

      # True if this set is a subset of the `other` set and there exists at
      # least one element in the `other` set that doesn't belong to this set
      #
      # @see http://en.wikipedia.org/wiki/Subset
      def proper_subset?(other)
        other.size > size and subset?(other)
      end

      # True if every element in the `other` set also belongs to this set
      #
      # @see http://en.wikipedia.org/wiki/Subset
      def superset?(other)
        intersection(other) == other
      end

      # True if this set is a superset of the `other` set and there exists at
      # least one element in this set that doesn't belong to the `other` set
      #
      # @see http://en.wikipedia.org/wiki/Subset
      def proper_superset?(other)
        other.size < size and superset?(other)
      end

      # True if this and the `other` set have no common elements
      #
      # @see http://en.wikipedia.org/wiki/Disjoint_sets
      def disjoint?(other)
        intersection(other).empty?
      end

      # True if this and the `other` set have exactly the same elements
      #
      # @return [Boolean]
      abstract :==, :args => %w(other)

      # (see AbstractSet#proper_subset?)
      def <(other) proper_subset?(other) end

      # (see AbstractSet#proper_superset?)
      def >(other) proper_superset?(other) end

      # (see AbstractSet#subset?)
      def <=(other) subset?(other) end

      # (see AbstractSet#superset?)
      def >=(other) superset?(other) end

      # @endgroup
      #########################################################################
    end

  end
end
