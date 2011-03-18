module Stupidedi

  #
  # This data type encodes a set of unique values that belong to an _infinite_
  # universe of possible values. Set operations generally perform worse than
  # {AbsoluteSet}, as they operate on {Hash} values and require iterating the
  # underlying {Hash} of at least one of the two sets in +O(n)+ time.
  #
  # This is suitable for sets that don't have an inherently restricted universe
  # of allowed values (eg a set of arbitrary {String} values), including where
  # the universe is significantly large compared to the typical size of sets
  # built from those values. {RelativeSet} also requires only a single step to
  # execute {#include?}, while {AbsoluteSet} requires two.
  #
  class RelativeSet < AbstractSet
    include Enumerable

    def initialize(hash)
      @hash = hash
    end

    # @return [void]
    def inspect
      "RelativeSet(#{to_a.join(', ')})"
    end

    # @return [void]
    def each
      @hash.keys.each{|o| yield o }
    end

    # @return [Array]
    def to_a
      @hash.keys
    end

    # @return [RelativeSet]
    def map
      self.class.new(@hash.keys.inject({}) do |hash, key|
        hash[yield(key)] = true
        hash
      end)
    end

    # @return [RelativeSet]
    def select
      self.class.new(@hash.clone.delete_if{|o,_| not yield(o) })
    end

    # @return [RelativeSet]
    def reject
      self.class.new(@hash.clone.delete_if{|o,_| yield(o) })
    end

    def include?(object)
      @hash.include?(object)
    end

    # @return true
    def finite?
      true
    end

    # @return [AbstractSet]
    def replace(other)
      if other.is_a?(AbstractSet)
        other
      elsif other.is_a?(Array)
        self.class.build(other)
      else
        raise TypeError, "Argument must be an AbstractSet or an Array"
      end
    end

    # @return [Integer]
    def size
      @hash.size
    end

    def empty?
      @hash.empty?
    end

    # @group Set Operations
    ###########################################################################

    # @return [RelativeComplement]
    def complement
      RelativeComplement.build(self)
    end

    # @return [AbstractSet]
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

    # @return [AbstractSet]
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

    # @return [AbstractSet]
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

    # @return [AbstractSet]
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

    # @group Set Ordering
    ###########################################################################

    # @return [Boolean]
    def ==(other)
      eql?(other) or
        (other.size == size and
         if other.is_a?(self.class)
           @hash.keys == other.to_a
         elsif other.is_a?(Array)
           @hash.keys == other
         end)
    end

    # @endgroup
  end

  class << RelativeSet

    # @group Constructor Methods

    # Returns a set that contains the elements from +other+
    #
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

    # Returns an empty set
    #
    # @return [EmptySet]
    def empty
      EmptySet
    end

    # @endgroup
  end

end
