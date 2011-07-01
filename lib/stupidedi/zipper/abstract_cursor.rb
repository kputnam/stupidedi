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
      # and `other.node` as end points. When this and the other zipper point to
      # the same node within the tree, a single node is returned. Otherwise, the
      # nodes are returned in order according to a left-to-right depth-first
      # pre-order traversal.
      #
      # @note This method assumes `other` is a zipper for the same tree as the
      #   tree wrapped by `this`. In general, there is no way to know if that is
      #   or isn't the case, without comparing the entire tree. If this method
      #   is called on two different trees, the results are undefined.
      #
      # @return [Array]
      def between(other)
        # Collect ancestors of self, sorted oldest first (deepest last). This
        # forms a boundary of nodes, which is called a "spine" below
        zipper = self
        lspine = [self]

        until zipper.root?
          zipper = zipper.up
          lspine.unshift(zipper)
        end

        # Collect ancestors of self, sorted oldest first (deepest last). This
        # forms a list of boundary nodes, which is called a "spine" below
        zipper = other
        rspine = [other]

        until zipper.root?
          zipper = zipper.up
          rspine.unshift(zipper)
        end

        # Now we have two spines, both beginning with the root node. We remove
        # the prefix common to both spines.
        while a = lspine.first and b = rspine.first
          if a.path == b.path
            lspine.shift
            rspine.shift
          else
            break
          end
        end

        if lspine.empty?
          # The other node is a child of self's node, and rspine contains all
          # the nodes along the path between the two nodes, not including the
          # self node.
          return node.cons(rspine.map(&:node))

        elsif rspine.empty?
          # Self's node is a child of other's node, and lspine contains all
          # the nodes along the path between the two nodes, not including the
          # other node
          return other.node.cons(lspine.map(&:node))

        elsif lspine.head.path.position > rspine.head.path.position
          # The first elements of lspine and rspine are siblings that share a
          # common parent. Arrange them such that lspine is on the left, and
          # so rspine is on the right
          lspine, rspine = rspine, lspine
        end

        between = []

        # Starting at the bottom of the left spine working upward, accumulate
        # all the nodes to the right of the spine. Remember this is contained
        # within the subtree under lspine.head
        lspine.each{|z| between << z.node }
        lspine.tail.reverse.each do |zipper|
          until zipper.last?
            zipper = zipper.next
            between.concat(zipper.flatten)
          end
        end

        # For the sibling nodes directly between (not including) lspine.head
        # and rspine.head, we can accumulate the entire subtrees.
        count  = rspine.head.path.position - lspine.head.path.position - 1
        zipper = lspine.head

        count.times do
          zipper = zipper.next
          between.concat(zipper.flatten)
        end

        between << rspine.head.node

        rspine.tail.each do |zipper|
          count  = zipper.path.position
          zipper = zipper.first

          # We have to do a bit more work to traverse the siblings in left-to-
          # right order, because `zipper` is now the left spine. We start on
          # the first sibling and move left a fixed number of times
          count.times do
            between.concat(zipper.flatten)
            zipper = zipper.next
          end

          # Now zipper is along the left spine. We don't expand it here, but the
          # next item in rspine is the next child along the left spine
          between << zipper.node
        end

        between
      end

      # Flattens the subtree into an Array of nodes. The nodes are arranged
      # according to a depth-first left-to-right preorder traversal.
      #
      # @return [Array]
      def flatten
        nodes = []
        queue = [node]

        while node = queue.shift
          nodes << node
          queue.unshift(*node.children) unless node.leaf?
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

      # Returns a list of cursors, one pointing to each child node.
      #
      # @return [Array<MemoizedCursor>]
      def children
        children = []

        unless leaf?
          zipper    = down
          children << zipper

          until zipper.last?
            zipper    = zipper.next
            children << zipper
          end
        end

        children
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
