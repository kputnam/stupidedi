module Stupidedi
  module Zipper

    # @private
    class AbstractPath
      # @return [Array<#leaf?, #children, #copy>]
      abstract :left

      # @return [AbstractPath]
      abstract :parent

      # @return [Array<#leaf?, #children, #copy>]
      abstract :right

      abstract :last?

      abstract :first?
    end

    # @private
    Root = Class.new(AbstractPath) do
      # @return [Array<#leaf?, #children, #copy>]
      def left
        []
      end

      # @return self
      def parent
        self
      end

      # @return [Array<#leaf?, #children, #copy>]
      def right
        []
      end

      def last?
        true
      end

      def first?
        true
      end

      def inspect
        "root"
      end
    end.new

    # @private
    class Hole < AbstractPath

      # @return [Array<#leaf?, #children, #copy>]
      attr_reader :left

      # @return [AbstractPath]
      attr_reader :parent

      # @return [Array<#leaf?, #children, #copy>]
      attr_reader :right

      def initialize(left, parent, right)
        @left, @parent, @right =
          left, parent, right
      end

      def last?
        @right.empty?
      end

      def first?
        @left.empty?
      end

      def inspect
        "#{@parent.inspect}/#{@left.length}"
      end
    end

  end
end
