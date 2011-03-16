module Stupidedi

  # Singleton
  EmptySet = Class.new(RelativeSet) do

    def initialize
    end

    # @return [void]
    def inspect
      "EmptySet"
    end

    # @return [void]
    def each
    end

    # @return [Array]
    def to_a
      []
    end

    # @return self
    def map
      self
    end

    # @return self
    def select
      self
    end

    # @return self
    def reject
      self
    end

    # @return false
    def include?(other)
      false
    end

    # @return true
    def finite?
      true
    end

    # @return [AbstractSet] other
    def replace(other)
      AbstractSet.build(other)
    end

    # @return 0
    def size
      0
    end

    # @return true
    def empty?
      true
    end

    # @group Set Operations
    ###########################################################################

    # @return UniversalSet
    def complement
      UniversalSet
    end

    # @return self
    def intersection(other)
      self
    end

    # @return [AbstractSet] other
    def union(other)
      AbstractSet.build(other)
    end

    # @return self
    def difference(other)
      self
    end

    # @return [AbstractSet] other
    def symmetric_difference(other)
      AbstractSet.build(other)
    end

    # @group Set Ordering
    ###########################################################################

    def ==(other)
      eql?(other) or other.empty?
    end

    # @endgroup
  end.new

end
