module Stupidedi

  #
  # This data type encodes a set of unique values that belong to an infinite
  # universe of possible values. Set operations generally perform worse than
  # AbsoluteSet, as they operate on Hash tables and require copying before
  # mutating and most operations require traversing the Hash table of at least
  # of of the sets in O(n) time.
  #
  # This is suitable for sets that don't have an inherently restricted universe
  # of allowed values (eg a Set of arbitrary String values), including where the
  # universe is significantly large compared to the typical size of sets built
  # from those values.
  #
  class RelativeSet < AbstractSet
    include Enumerable

    def initialize(hash)
      @hash = hash
    end

    def inspect
      "RelativeSet(#{to_a.join(', ')})"
    end

    def each
      @hash.keys.each{|o| yield o }
    end

    def to_a
      @hash.keys
    end

    def map
      self.class.new(@hash.keys.inject({}) do |hash, key|
        hash[yield(key)] = true
        hash
      end)
    end

    def select
      self.class.new(@hash.clone.delete_if{|o,_| not yield(o) })
    end

    def reject
      self.class.new(@hash.clone.delete_if{|o,_| yield(o) })
    end

    def include?(object)
      @hash.include?(object)
    end

    def finite?
      true
    end

    def complement
      RelativeComplement.build(self)
    end

    def intersection(other)
      if other.is_a?(self.class)
        # A & B
        if size <= other.size
          self.class.new(@hash.clone.delete_if{|o,_| not other.include?(o) })
        else
          other.intersection(self)
        end
      elsif other.is_a?(Array)
        # A & B
        if other.empty?
          self
        else
          self.class.build(to_a & other)
        end
      elsif other.is_a?(RelativeComplement)
        # A & ~B = A - B
        if other.complement.empty?
          self
        else
          self.class.new(@hash.clone.delete_if{|o,_| not other.include?(o) })
        end
      else
        raise TypeError, "Argument must be an AbstractSet or an Array"
      end
    end

    def union(other)
      if other.is_a?(self.class)
        # A | B
        if other.empty?
          self
        elsif size >= other.size
          self.class.new(other.inject(@hash.clone){|h,o| h[o] = true; h })
        else
          other.union(self)
        end
      elsif other.is_a?(Array)
        # A | B
        if other.empty?
          self
        else
          self.class.new(other.inject(@hash.clone){|h,o| h[o] = true; h })
        end
      elsif other.is_a?(RelativeComplement)
        # A | ~B = ~(B - A)
        difference(other.complement).complement
      else
        raise TypeError, "Argument must be an AbstractSet or an Array"
      end
    end

    def difference(other)
      if other.is_a?(self.class)
        # A - B = A & ~B
        if other.empty?
          self
        else
          self.class.new(@hash.clone.delete_if{|o,_| other.include?(o) })
        end
      elsif other.is_a?(Array)
        # A - B = A & ~B
        if other.empty?
          self
        else
          self.class.build(to_a - other)
        end
      elsif other.is_a?(RelativeComplement)
        # A - ~B = A & B
        intersection(other.complement)
      else
        raise TypeError, "Argument must be an AbstractSet or an Array"
      end
    end

    def symmetric_difference(other)
      if other.is_a?(self.class) or other.is_a?(Array)
        # A ^ B = (A | B) - (A & B) = (A - B) | (B - A)
        # A ^ B = (A | B) - (A & B) = (A - B) | (B - A)
        if other.empty?
          self
        else
          difference(other).
            union(RelativeSet.build(other).difference(self))
        end
      elsif other.is_a?(RelativeComplement)
        # A ^ ~B = (A - ~B) | (~B - A) = (B & A) | (~B & ~A) = ~A ^ B
        difference(other).
          union(other.difference(self))
      else
        raise TypeError, "Argument must be an AbstractSet or an Array"
      end
    end

    def replace(other)
      if other.is_a?(AbstractSet)
        other
      elsif other.is_a?(Array)
        self.class.build(other)
      else
        raise TypeError, "Argument must be an AbstractSet or an Array"
      end
    end

    def size
      @hash.size
    end

    def empty?
      @hash.empty?
    end

    def ==(other)
      eql?(other) or
        (other.size == size and
         if other.is_a?(self.class)
           @hash.keys == other.to_a
         elsif other.is_a?(Array)
           @hash.keys == other
         end)
    end
  end

  class << RelativeSet
    # @return [RelativeSet]
    def build(object)
      if object.is_a?(RelativeSet)
        object
      elsif object.is_a?(Hash)
        if object.empty?
          EmptySet
        else
          RelativeSet.new(object)
        end
      elsif object.is_a?(Enumerable)
        if object.empty?
          EmptySet
        else
          RelativeSet.new(object.inject({}){|h,o| h[o] = true; h })
        end
      else
        raise TypeError
      end
    end

    def empty
      EmptySet
    end
  end

end
