module Stupidedi

  class AbstractSet
    abstract :include?, :args => %w(object)
    abstract :empty?
    abstract :size

    abstract :complement
    abstract :union, :args => %w(other)
    abstract :difference, :args => %w(other)
    abstract :complement, :args => %w(other)
    abstract :symmetric_difference, :args => %w(other)
    abstract :intersection, :args => %w(other)
    abstract :replace, :args => %w(other)

    abstract :==, :args => %w(other)

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
  end

end
