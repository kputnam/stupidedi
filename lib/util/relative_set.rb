module Stupidedi

  class RelativeSet < AbstractSet
    include Enumerable

    def initialize(hash)
      @hash = hash
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

    def complement
      RelativeComplement.build(self)
    end

    def intersection(other)
      if other.is_a?(self.class)
        # A & B
        if other.empty?
          self
        elsif size <= other.size
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
        # A - B
        if other.empty?
          self
        else
          self.class.new(@hash.clone.delete_if{|o,_| other.include?(o) })
        end
      elsif other.is_a?(Array)
        # A - B
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
          difference(other).union(RelativeSet.build(other).difference(self))
        end
      elsif other.is_a?(RelativeComplement)
        # A ^ ~B = (A | ~B) - (A & ~B) = ~(B - A) - (A - B)
        difference(other.complement).complement.
          difference(difference(other.complement))
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
      hash = if object.is_a?(RelativeSet)
               object.instance_variable_get(:@hash)
             elsif object.is_a?(Hash)
               object
             elsif object.is_a?(Enumerable)
               object.inject({}){|h,o| h[o] = true; h }
             else
               raise TypeError
             end

      RelativeSet.new(hash)
    end
  end

end
