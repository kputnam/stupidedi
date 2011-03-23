module Stupidedi
  module Zipper

    class AbstractCursor

      # @return [#leaf?, #children, #copy]
      abstract :node

      # @return [AbstractPath]
      abstract :path

      #########################################################################
      # @group Query Methods

      # @return [Integer]
      def depth
        path.depth
      end

      def first?
        path.first?
      end

      def last?
        path.last?
      end

      abstract :leaf?

      abstract :root?

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Traversal Methods

      # @return [MemoizedCursor]
      def down
        if leaf?
          raise Exceptions::ZipperError,
            "cannot descend into leaf node"
        end

        @__down ||= begin
          head, *tail = @node.children

          MemoizedCursor.new(head,
            Hole.new([], @path, tail), self)
        end
      end

      # @return [AbstractCursor]
      def dangle
        if node.leaf?
          raise Exceptions::ZipperError,
            "cannot descend into leaf node"
        end

        if leaf?
          DanglingCursor.new(self)
        else
          down
        end
      end

      # @return [AbstractCursor]
      abstract :up

      # @return [AbstractCursor]
      abstract :next

      # @return [AbstractCursor]
      abstract :prev

      # @return [AbstractCursor]
      abstract :first

      # @return [AbstractCursor]
      abstract :last

      # @return [RootCursor]
      def root
        cursor = self
        cursor = cursor.up until cursor.root?
        cursor
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Editing Methods

      # @return [EditedCursor]
      abstract :append, :args => %w(node)

      # @return [EditedCursor]
      abstract :prepend, :args => %w(node)

      # @return [EditedCursor]
      def prepend_child(child)
        if node.leaf?
          raise Exceptions::ZipperError,
            "cannot add child to leaf node"
        end

        EditedCursor.new(child,
          Hole.new([], path, node.children), self)
      end

      # @return [EditedCursor]
      def append_child(child)
        if node.leaf?
          raise Exceptions::ZipperError,
            "cannot add child to leaf node"
        end

        EditedCursor.new(child,
          Hole.new(node.children, path, []), self)
      end

      # @return [AbstractCursor]
      abstract :replace, :args => %w(node)

      # @return [EditedCursor]
      abstract :delete

      # @endgroup
      #########################################################################
    end

  end
end
