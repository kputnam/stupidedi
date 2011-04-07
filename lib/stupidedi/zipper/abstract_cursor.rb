module Stupidedi
  module Zipper

    class AbstractCursor

      # @return [#leaf?, #children, #copy]
      abstract :node

      # @return [AbstractPath]
      abstract :path

      # @group Querying the Tree Location
      #########################################################################

      # (see AbstractPath#depth)
      def depth
        path.depth
      end

      # (see AbstractPath#first?)
      def first?
        path.first?
      end

      # (see AbstractPath#last?)
      def last?
        path.last?
      end

      # True if the node has no children
      abstract :leaf?

      # True if the node has no parent
      abstract :root?

      # @group Traversing the Tree
      #########################################################################

      # Navigate to the first child node
      #
      # @return [MemoizedCursor]
      def down
        @__down ||= begin
          if leaf?
            raise Exceptions::ZipperError,
              "cannot descend into leaf node"
          end

          head, *tail = @node.children

          MemoizedCursor.new(head,
            Hole.new([], @path, tail), self)
        end
      end

      # Navigate to the first child node, or if there are no children,
      # create a placeholder where the first child node will be placed
      #
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

      # Navigate to the `nth` child node
      #
      # @return [AbstractCursor]
      def child(n)
        if n < 0
          raise Exceptions::ZipperError,
            "child index cannot be negative"
        end

        cursor = down
        until n.zero?
          cursor = cursor.left
          n += 1
        end
        cursor
      end

      # Navigate to the parent node
      #
      # @return [AbstractCursor]
      abstract :up

      # Navigate to the next (rightward) sibling node
      #
      # @return [AbstractCursor]
      abstract :next

      # Navigate to the previous (leftward) sibling node
      #
      # @return [AbstractCursor]
      abstract :prev

      # Navigate to the first (leftmost) sibling node
      #
      # @return [AbstractCursor]
      abstract :first

      # Navigate to the last (rightmost) sibling node
      #
      # @return [AbstractCursor]
      abstract :last

      # Navigate to the root node
      #
      # @return [RootCursor]
      def root
        cursor = self
        cursor = cursor.up until cursor.root?
        cursor
      end

      # @group Editing the Tree
      #########################################################################

      # Insert a new sibling node after (to the right of) the current node,
      # and navigate to the new sibling node
      #
      # @return [EditedCursor]
      abstract :append, :args => %w(sibling)

      # Insert a new sibling node before (to the left of) the current node,
      # and navigate to the new sibling node
      #
      # @return [EditedCursor]
      abstract :prepend, :args => %w(sibling)

      # (see #append)
      def insert_right(sibling)
        append(sibling)
      end

      # (see #prepend)
      def insert_left(sibling)
        prepend(sibling)
      end

      # Insert a new child node before (to the left of) any existing children
      # nodes and navigate to the new child node
      #
      # @return [EditedCursor]
      def prepend_child(child)
        if node.leaf?
          raise Exceptions::ZipperError,
            "cannot add child to leaf node"
        end

        EditedCursor.new(child,
          Hole.new([], path, node.children), self)
      end

      # Insert a new child node after (to the right of) any existing children
      # nodes and navigate to the new child node
      #
      # @return [EditedCursor]
      def append_child(child)
        if node.leaf?
          raise Exceptions::ZipperError,
            "cannot add child to leaf node"
        end

        EditedCursor.new(child,
          Hole.new(node.children.reverse, path, []), self)
      end

      # Replace the current node with the given node
      #
      # @return [AbstractCursor]
      abstract :replace, :args => %w(node)

      # Remove the current node, and navigate to the next (rightward) node if
      # one exists. Otherwise, navigate to the previous (leftward) node if one
      # exists. Otherwise, create a placehold where the next sibling node will
      # be created.
      #
      # @return [EditedCursor]
      abstract :delete

      # @endgroup
      #########################################################################
    end

  end
end
