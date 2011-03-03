module Stupidedi

  #
  # This data type encodes the complement of a RelativeSet, which is an infinite
  # and non-enumerable set of values.
  #
  class RelativeComplement < AbstractSet
    def initialize(complement)
      @complement = complement
    end

    def inspect
      "RelativeComplement(#{@complement.inspect})"
    end

    def include?(object)
      not @complement.include?(object)
    end

    def finite?
      false
    end

    def complement
      # ~(~A) = A
      @complement
    end

    def size
      1.0 / 0.0
    end

    def empty?
      false
    end

    # @return [AbstractSet]
    def intersection(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A & B = B - A
        RelativeSet.build(other).difference(complement)
      elsif other.is_a?(self.class)
        # ~A & ~B = ~(A | B)
        complement.union(other.complement).complement
      end
    end

    # @return [AbstractSet]
    def union(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A | B = ~(A - B)
        if other.empty?
          self
        else
          complement.difference(other).complement
        end
      elsif other.is_a?(self.class)
        # ~A | ~B = ~(A & B)
        complement.intersection(other.complement).complement
      end
    end

    # @return [AbstractSet]
    def symmetric_difference(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A ^ B = (~A - B) | (B - ~A) = (~B & ~A) | (B & A) = A ^ ~B
        difference(other).
          union(RelativeSet.build(other).difference(self))
      elsif other.is_a?(self.class)
        # ~A ^ ~B = (~A - ~B) | (~B - ~A) = (B - A) | (A - B) = A ^ B
        RelativeSet.build(other).difference(complement).
          union(complement.difference(other))
      end
    end

    # @return [AbstractSet]
    def difference(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A - B = ~(A | B)
        complement.union(other).complement
      elsif other.is_a?(self.class)
        # ~A - ~B = B - A
        complement.difference(other.complement)
      end
    end

    # @return [AbstractSet]
    def replace(other)
      if other.is_a?(self.class) or other.is_a?(RelativeSet)
        other
      elsif other.is_a?(Array)
        RelativeSet.build(other)
      end
    end
    
    # @return [Boolean]
    def proper_subset?(other)
      other.is_a?(self.class) and 
      other.complement.size > @complement.size and
      subset?(other)
    end

    # @return [Boolean]
    def proper_superset?(other)
      other.is_a?(self.class) and 
      other.complement.size < @complement.size and
      superset?(other)
    end

    # @return [Boolean]
    def ==(other)
      eql?(other) or 
       (other.is_a?(self.class) and
        complement == other.complement)
    end
  end

  class << RelativeComplement
    # @return [RelativeComplement]
    def build(object)
      if object.is_a?(RelativeComplement)
        object
      elsif object.is_a?(AbstractSet)
        if object.empty?
          UniversalSet
        else
          RelativeComplement.new(object)
        end
      elsif object.is_a?(Enumerable)
        if object.empty?
          UniversalSet
        else
          RelativeComplement.new(RelativeSet.build(object))
        end
      else
        raise TypeError
      end
    end

    def universal
      UniversalSet
    end
  end

end
