module Stupidedi

  #
  #
  #
  class SetSubset
    delegate :empty?, :include?, :to => :@values

    def initialize(values)
      @values = values
    end

    # @return [Set]
    def values
      @values
    end

    # @return [SetSubset]
    def union(other)
      self.class.new(@values | other.values)
    end
    
    # @return [SetSubset]
    def intersection(other)
      self.class.new(@values & other.values)
    end

    alias subset intersection

    # @return [SetSubset]
    def subtract(other)
      self.class.new(@values - other.values)
    end
  end

  #
  #
  #
  class BitmaskSubset

    # @return [Integer]
    attr_reader :mask

    # @return [Hash]
    attr_reader :universe

    def initialize(mask, universe)
      @universe, @mask = universe, mask
    end

    def include?(other)
      if bit = @universe.at(other)
        @mask & (1 << bit)
      end
    end

    def empty?
      @mask.zero?
    end

    # @return [Set]
    def values
      @universe.inject(Set.new) do |list, (value, n)|
        if (@mask & (1 << n)).zero?
          list
        else
          list << value
        end
      end
    end

    # @return [BitSubset]
    def union(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          self.class.new(other.mask | @mask, @universe)
        else
          self.class.build(values | other.values)
        end
      else
        universe = @universe.clone

        mask = other.inject(@mask) do |mask, x|
          unless bit = universe.at(x)
            # @todo: Explain
            bit = universe[x] = universe.length + 1
          end

          mask | (1 << bit)
        end

        self.class.new(mask, universe)
      end
    end

    alias + union

    # @return [BitSubset]
    def intersection(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          self.class.new(other.mask & @mask, @universe)
        else
          self.class.build(values & other.values)
        end
      else
        mask = other.inject(0) do |mask,x|
          if bit = @universe.at(x)
            mask | (1 << bit)
          else
            mask
          end
        end

        self.class.new(@mask & mask, @universe)
      end
    end

    alias intersect intersection
    alias subset intersection

    # @return [BitSubset]
    def subtract(other)
      if other.is_a?(self.class)
        if other.universe.eql?(@universe)
          self.class.new(~other.mask & @mask, @universe)
        else
          self.class.build(values - other.values)
        end
      else
        mask = other.inject(0) do |mask,x|
          if bit = @universe.at(x)
            mask | (1 << bit)
          else
            mask
          end
        end

        self.class.new(@mask & ~mask, @universe)
      end
    end

    alias - subtract
  end

  class << BitmaskSubset
    def build(values)
      count = 0
      universe = values.inject({}){|hash, v| hash.update(v => (count += 1)) }

      BitmaskSubset.new((1 << count) - 1, universe)
    end
  end

end
