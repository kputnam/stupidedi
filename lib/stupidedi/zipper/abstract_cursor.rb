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

      # Returns nodes between this zipper and the other, including `self.node`
      # and `other.node` as end-points. The nodes are not returned in a
      # particular order. Both `self` and `other` must, and are assumed to,
      # belong to the same tree.
      #
      # @return [Array]
      def between(other)

        # Collect ancestors of other, sorted oldest first (deepest last)
        zipper    = other
        ancestors = [other]

        until zipper.root?
          zipper = zipper.up
          ancestors.unshift(zipper)
        end

        # Collect ancestors of self, sorted oldest first (deepest last)
        zipper    = self
        bncestors = [self]

        until zipper.root?
          zipper = zipper.up
          bncestors.unshift(zipper)
        end

        # This is a root node. We could check that self and the given other
        # belong to the same tree by comparing their roots -- unfortunately,
        # this requires comparing each node in the entire tree.
        common = zipper

        # Remove the common prefix in the paths to self and other, and keep
        # track of the youngest common ancestor.
        while a = ancestors.first and b = bncestors.first
          if a.path == b.path
            common = a # This is the next youngest ancestor

            ancestors.shift
            bncestors.shift
          else
            break
          end
        end

        if ancestors.empty?
          return self.cons(bncestors).map(&:node)
        elsif bncestors.empty?
          return other.cons(ancestors).map(&:node)
        elsif ancestors.head.path.position > bncestors.head.path.position
          # Arrange so ancestors is the left path and bncestors is the right
          ancestors, bncestors = bncestors, ancestors
        end

        # Accumulate the nodes between `common` and the left node (which is self
        # or other), but only those to the right of the left node.
        between = [ancestors.head.node]
        ancestors.tail.each do |zipper|
          between << zipper.node

          until zipper.last?
            zipper = zipper.next
            between.concat(zipper.flatten)
          end
        end

        # Accumulate the nodes in the siblings directly between self and other.
        zipper = ancestors.head
        (bncestors.head.path.position - zipper.path.position - 1).times do
          zipper = zipper.next
          between.concat(zipper.flatten)
        end

        # Accumulate the nodes between `common` and the right node (which is
        # self or other), but only those to the left of the right node.
        between << bncestors.head.node
        bncestors.tail.each do |zipper|
          between << zipper.node

          until zipper.first?
            zipper = zipper.prev
            between.concat(zipper.flatten)
          end
        end

        between
      end

      # Flattens all nodes in the subtree into an Array
      #
      # @return [Array]
      def flatten
        nodes = []
        queue = [node]

        while node = queue.pop
          nodes << node
          queue.concat(node.children) unless node.leaf?
        end

        nodes
      end

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
          cursor = cursor.next
          n -= 1
        end
        cursor
      end

      # Recursively descend to each node's `nth` child
      #
      # @return [AbstractCursor]
      def descendant(n, *ns)
        cursor = self

        n.cons(ns).each do |n|
          cursor = cursor.child(n)
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
