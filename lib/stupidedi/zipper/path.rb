module Stupidedi
  module Zipper

    class AbstractPath

      # @return [AbstractPath]
      abstract :parent

      # Contains the subtree's leftward siblings, sorted nearest to furthest
      #
      # @return [Array<#leaf?, #children, #copy>]
      abstract :left

      # Contains the subtree's rightward siblings, sorted nearest to furthest
      #
      # @return [Array<#leaf?, #children, #copy>]
      abstract :right

      # True when the subtree has no rightward siblings
      abstract :last?

      # True when the subtree has no leftward siblings
      abstract :first?

      # Distance from the root node
      #
      # @return [Integer]
      abstract :depth
    end

    # @private
    Root = Class.new(AbstractPath) do

      # @return self
      def parent
        self
      end

      # (see AbstractPath#left)
      def left
        []
      end

      # (see AbstractPath#right)
      def right
        []
      end

      # (see AbstractPath#last?)
      # @return true
      def last?
        true
      end

      # (see AbstractPath#first?)
      # @return true
      def first?
        true
      end

      # (see AbstractPath#depth)
      def depth
        0
      end

      # @return [String]
      def inspect
        "root"
      end
    end.new

    class Hole < AbstractPath

      # (see AbstractPath#right)
      attr_reader :left

      # @return [AbstractPath]
      attr_reader :parent

      # (see AbstractPath#left)
      attr_reader :right

      def initialize(left, parent, right)
        @left, @parent, @right =
          left, parent, right
      end

      # (see AbstractPath#last?)
      def last?
        @right.empty?
      end

      # (see AbstractPath#first?)
      def first?
        @left.empty?
      end

      def depth
        1 + @parent.depth
      end

      # @return [String]
      def inspect
        "#{@parent.inspect}/#{@left.length}"
      end
    end

  end
end
