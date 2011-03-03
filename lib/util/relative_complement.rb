module Stupidedi

  class RelativeComplement < AbstractSet
    def initialize(orig)
      @orig = orig
    end

    def include?(object)
      not @orig.include?(object)
    end

    def complement
      # ~(~A) = A
      @orig
    end

    def size
      1.0 / 0.0
    end

    def empty?
      false
    end

    def intersection(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A & B = B - A
        RelativeSet.build(other).difference(complement)
      elsif other.is_a?(self.class)
        # ~A & ~B = ~(A | B)
        complement.union(other.complement).complement
      end
    end

    def union(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A | B = ~(A - B)
        complement.difference(other).complement
      elsif other.is_a?(self.class)
        # ~A | ~B = ~(A & B)
        complement.intersection(other.complement).complement
      end
    end

    def symmetric_difference(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A ^ B = (~A | B) - (~A & B) = ~(A - B) - (B - A)
        complement.difference(other).complement.
          difference(RelativeSet.build(other).difference(complement))
      elsif other.is_a?(self.class)
        # ~A ^ ~B = (~A | ~B) - (~A & ~B)
      end
    end

    def difference(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # ~A - B = ~(A | B)
        complement.union(other).complement
      elsif other.is_a?(self.class)
        # ~A - ~B
      end
    end

    def replace(other)
      if other.is_a?(self.class) or other.is_a?(RelativeSet)
        other
      elsif other.is_a?(Array)
        RelativeSet.build(other)
      end
    end
    
    def proper_subset?(other)
      other.is_a?(self.class) and 
      other.complement.size > @orig.size and
      subset?(other)
    end

    def proper_superset?(other)
      other.is_a?(self.class) and 
      other.complement.size < @orig.size and
      superset?(other)
    end

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
        RelativeComplement.new(object)
      elsif object.is_a?(Enumerable)
        RelativeComplement.new(RelativeSet.build(object))
      else
        raise TypeError
      end
    end
  end

end
