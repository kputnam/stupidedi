module Stupidedi

  class AbstractSet

    abstract :include?, :args => %w(object)

    abstract :finite?

    abstract :empty?

    # @return [Numeric]
    abstract :size

    # @return [AbstractSet] other
    abstract :replace, :args => %w(other)

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

    def  |(other) union(other) end
    def  +(other) union(other) end
    def  -(other) difference(other) end
    def  ~(other) complement(other) end
    def  ^(other) symmetric_difference(other) end
    def  &(other) intersection(other) end
    def  <(other) proper_subset?(other) end
    def  >(other) proper_superset?(other) end
    def <=(other) subset?(other) end
    def >=(other) superset?(other) end

    # @group Set Ordering
    ###########################################################################

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

    # @return [AbstractSet]
    def build(object)
      if object.is_a?(AbstractSet)
        object
      elsif object.is_a?(Enumerable)
        RelativeSet.build(object)
      end
    end
  end

end
