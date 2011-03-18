module Stupidedi

  #
  # {AbstractSet} describes the common interface implemented by its concrete
  # subclasses. The two main implementations are {RelativeSet} and {AbsoluteSet}
  # which are each optimized for different kinds of set operations.
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

    # @return [AbstractSet]
    abstract :replace, :args => %w(other)

    # True if the set contains infinitely many elements
    def infinite?
      not finite?
    end

    # @group Set Operations
    ###########################################################################

    # @return [AbstractSet]
    abstract :complement

    # @return [AbstractSet]
    abstract :union, :args => %w(other)

    # @return [AbstractSet]
    abstract :difference, :args => %w(other)

    # @return [AbstractSet]
    abstract :symmetric_difference, :args => %w(other)

    # @return [AbstractSet]
    abstract :intersection, :args => %w(other)

    # @return [AbstractSet]
    def |(other) union(other) end

    # @return [AbstractSet]
    def +(other) union(other) end

    # @return [AbstractSet]
    def -(other) difference(other) end

    # @return [AbstractSet]
    def ~(other) complement(other) end

    # @return [AbstractSet]
    def ^(other) symmetric_difference(other) end

    # @return [AbstractSet]
    def  &(other) intersection(other) end

    # @return [AbstractSet]
    def <(other) proper_subset?(other) end

    # @return [AbstractSet]
    def >(other) proper_superset?(other) end

    # @return [AbstractSet]
    def <=(other) subset?(other) end

    # @return [AbstractSet]
    def >=(other) superset?(other) end

    # @group Set Ordering
    ###########################################################################

    # @return [Boolean]
    abstract :==, :args => %w(other)

    def subset?(other)
      self == intersection(other)
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
  end

  class << AbstractSet

    # @group Constructor Methods

    # @return [AbstractSet]
    def build(object)
      if object.is_a?(AbstractSet)
        object
      elsif object.is_a?(Enumerable)
        RelativeSet.build(object)
      end
    end

    # @endgroup

  end

end
