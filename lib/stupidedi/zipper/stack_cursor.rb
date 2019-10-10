# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Zipper
    class StackCursor < AbstractCursor
      # @return [#leaf?, #children, #copy]
      attr_reader :node

      # @return [Hole]
      attr_reader :path

      # @private
      # @return [AbstractCursor]
      attr_reader :parent

      def initialize(node, path, parent)
        @node, @path, @parent =
          node, path, parent
      end

      # @group Querying the Tree Location
      #########################################################################

      # (see AbstractCursor#leaf?)
      def leaf?
        @node.leaf? or @node.children.empty?
      end

      # (see AbstractCursor#root?)
      def root?
        @path.root?
      end

      # @group Traversing the Tree
      #########################################################################

      # (see AbstractCursor#last)
      def last
        self
      end

      # (see AbstractCursor#up)
      def up
        if root?
          raise Exceptions::ZipperError,
            "root node has no siblings"
        end

        @parent
      end

      # @group Editing the Tree
      #########################################################################

      # (see AbstractCursor#append)
      # @return [void]
      def append(node)
        if root?
          raise Exceptions::ZipperError,
            "root node has no siblings"
        end

        replace(node)
      end

      # (see AbstractCursor#prepend)
      # @return [void]
      def prepend(node)
        if root?
          raise Exceptions::ZipperError,
            "root node has no siblings"
        end

        replace(node)
      end

      def append_child(child)
        StackCursor.new(child, Hole.new([], @path, []), self)
      end

      # (see AbstractCursor#replace)
      # @return [RootCursor]
      def replace(node)
        StackCursor.new(node, @path, @parent)
      end

      def dangle
        if leaf?
          StackCursor.new(nil, Hole.new([], @path, []), self)
        else
          head, *tail = @node.children

          unless tail.empty?
            raise Exceptions::ZipperError,
              "stack cursor doesn't support nodes with multiple children"
          end

          StackCursor.new(head, Hole.new([], @path, []), self)
        end
      end

      # @endgroup
      #########################################################################
    end
  end
end
