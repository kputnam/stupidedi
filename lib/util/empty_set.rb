module Stupidedi

  EmptySet = Class.new(RelativeSet) do
    def initialize
    end

    def inspect
      "EmptySet"
    end

    def each
    end

    def to_a
      []
    end

    def map
      self
    end

    def select
      self
    end

    def reject
      self
    end

    def include?(other)
      false
    end

    def finite?
      true
    end

    def complement
      RelativeComplement.build(self)
    end

    def intersection(other)
      self
    end

    def union(other)
      RelativeSet.build(other)
    end

    def difference(other)
      self
    end

    def symmetric_difference(other)
      RelativeSet.build(other)
    end

    def replace(other)
      RelativeSet.build(other)
    end

    def size
      0
    end

    def empty?
      true
    end

    def ==(other)
      eql?(other) or other.empty?
    end
  end.new

end
