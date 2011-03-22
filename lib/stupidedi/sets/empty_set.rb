module Stupidedi
  module Sets

    # Singleton
    # @private
    EmptySet = Class.new(RelativeSet) do

      def initialize
      end

      # @return [EmptySet]
      def build
        self
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

      # @return false
      def include?(other)
        false
      end

      # @return true
      def finite?
        true
      end

      # @return [Set] other
      def replace(other)
        Sets.build(other)
      end

      # @return 0
      def size
        0
      end

      # @return true
      def empty?
        true
      end

      #########################################################################
      # @group Set Operations

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

      # @return UniversalSet
      def complement
        UniversalSet.build
      end

      # @return self
      def intersection(other)
        self
      end

      # @return [Set] other
      def union(other)
        Sets.build(other)
      end

      # @return self
      def difference(other)
        self
      end

      # @return [Set] other
      def symmetric_difference(other)
        Sets.build(other)
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Set Ordering

      def ==(other)
        eql?(other) or other.empty?
      end

      # @endgroup
    end.new

  end
end
