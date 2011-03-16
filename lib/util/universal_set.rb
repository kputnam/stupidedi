module Stupidedi

  # Singleton
  UniversalSet = Class.new(RelativeComplement) do
    def initialize
    end

    def inspect
      "UniversalSet"
    end

    # @return true
    def include?(object)
      true
    end

    # @return false
    def finite?
      false
    end

    # @return EmptySet
    def complement
      EmptySet
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
      if other.is_a?(RelativeComplement) or other.is_a?(RelativeSet)
        other
      elsif other.is_a?(Array)
        RelativeSet.build(other)
      end
    end

    # Set Operations
    ###########################################################################

    # @return [AbstractSet]
    def intersection(other)
      if other.is_a?(RelativeSet) or other.is_a?(RelativeComplement)
        # U & A = A
        other
      else other.is_a?(Array)
        # U & ~A = ~A
        RelativeSet.build(other)
      end
    end

    # @return [AbstractSet]
    def union(other)
      # U | A = U
      # U | ~A = U
      self
    end

    # @return [AbstractSet]
    def symmetric_difference(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # U ^ B = (U - B) | (B - U) = (~B & U) | (B & 0) = ~B
        RelativeSet.build(other).complement
      elsif other.is_a?(RelativeComplement)
        # U ^ ~B = (U - ~B) | (~B - U) = (B - 0) | (0 - B) = 0 ^ B = B
        RelativeSet.build(other)
      end
    end

    # @return [AbstractSet]
    def difference(other)
      if other.is_a?(RelativeSet) or other.is_a?(Array)
        # U - B = ~B
        RelativeSet.build(other).complement
      elsif other.is_a?(RelativeComplement)
        # U - ~B = B
        other.complement
      end
    end

    # Set Ordering
    ###########################################################################
    
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

    # @endgroup

  end.new

end
