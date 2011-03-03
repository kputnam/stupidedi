module Stupidedi

  #
  #
  #
  class AbsoluteSet < AbstractSet

    # @return [Integer]
    attr_reader :mask

    # @return [Hash]
    attr_reader :universe

    def initialize(mask, universe)
      @mask, @universe = mask, universe.freeze
    end

    # @return [Array]
    def to_a
      elements = []
      @universe.each do |(value, n)|
        unless @mask[n].zero?
          elements << value
        end
      end
      elements
    end

    # @return [AbsoluteSet]
    def map
      mask = 0

      @universe.each do |(value, n)|
        unless @mask[n].zero?
          if m = @universe.at(yield(value))
            mask |= (1 << m)
          end
        end
      end

      self.class.new(mask, @universe)
    end

    # @return [AbsoluteSet]
    def select
      mask = 0

      @universe.each do |(value, n)|
        unless @mask[n].zero? or not yield(value)
          mask |= (1 << n)
        end
      end

      self.class.new(mask, @universe)
    end

    # @return [AbsoluteSet]
    def reject
      mask = 0

      @universe.each do |(value, n)|
        unless @mask[n].zero? or yield(value)
          mask |= (1 << n)
        end
      end

      self.class.new(mask, @universe)
    end

    # @return [Boolean]
    def include?(other)
      if n = @universe.at(other)
        # Same as (@mask & (1 << n)).zero? but potentially eliminates
        # converting the intermediate computation to a Ruby value
        not @mask[n].zero?
      end
    end

    # @return [Boolean]
    def finite?
      true
    end

    # @return [Boolean]
    def empty?
      @mask.zero?
    end

    # @return [Integer]
    def size
      @universe.inject(0){|size, (value, n)| size + @mask[n] }
    end

    # @return [AbsoluteSet]
    def complement
      self.class.new(~@mask, @universe)
    end

    # @return [AbsoluteSet]
    def union(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask | other.mask, @universe)
        else
          other = other.to_a
        end
      end

      mask = 0

      other.each do |x|
        if n = @universe.at(x)
          mask |= (1 << n)
        end
      end

      self.class.new(mask | @mask, @universe)
    end

    # @return [AbsoluteSet]
    def intersection(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask & other.mask, @universe)
        else
          other = other.to_a
        end
      end

      mask = 0

      other.each do |x|
        if n = @universe.at(x)
          mask |= (1 << n)
        end
      end

      self.class.new(@mask & mask, @universe)
    end

    # @return [AbsoluteSet]
    def difference(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask & ~other.mask, @universe)
        else
          other = other.to_a
        end
      end

      mask = 0

      other.each do |x|
        if n = @universe.at(x)
          mask |= (1 << n)
        end
      end

      self.class.new(@mask & ~mask, @universe)
    end

    # @return [AbsoluteSet]
    def symmetric_difference(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return self.class.new(@mask ^ other.mask, @universe)
        else
          other = other.to_a
        end
      end

      mask = 0

      other.each do |x|
        if n = @universe.at(x)
          mask |= (1 << n)
        end
      end

      self.class.new(@mask ^ mask, @universe)
    end

    # @return [AbsoluteSet]
    def replace(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return other
        else
          other = other.to_a
        end
      end

      mask = 0

      other.each do |x|
        if n = @universe.at(x)
          mask |= (1 << n)
        end
      end

      self.class.new(mask, @universe)
    end

    # @return [Boolean]
    def ==(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          return other.mask == @mask
        else
          other = other.to_a
        end
      end

      to_a == other
    end
  end

  class << AbsoluteSet

    # @return [AbsoluteSet]
    def build(values)
      count    = -1
      universe = values.inject({}){|hash, v| hash.update(v => (count += 1)) }

      AbsoluteSet.new((1 << (count + 1)) - 1, universe)
    end
  end
end
