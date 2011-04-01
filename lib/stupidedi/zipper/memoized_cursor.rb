module Stupidedi
  module Zipper

    class MemoizedCursor < AbstractCursor

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

      def leaf?
        @node.leaf? or @node.children.empty?
      end

      def root?
        false
      end

      # @group Traversing the Tree
      #########################################################################

      # @return [AbstractCursor]
      def up
        @parent
      end

      # @return [MemoizedCursor]
      def next
        @__next ||= begin
          if last?
            raise Exceptions::ZipperError,
              "cannot move to next after last node"
          end

          head, *tail = @path.right

          MemoizedCursor.new(head,
            Hole.new(@node.cons(@path.left), @path.parent, tail), @parent)
        end
      end

      # @return [MemoizedCursor]
      def prev
        @__prev ||= begin
          if first?
            raise Exceptions::ZipperError,
              "cannot move to prev before first node"
          end

          head, *tail = @path.left

          MemoizedCursor.new(head,
            Hole.new(tail, @path.parent, @node.cons(@path.right)), @parent)
        end
      end

      # @return [MemoizedCursor]
      def first
        @parent.down

      # @note: The code below is correct but doesn't take advantage of values
      # memoized by the parent. Temporarily here to evaluate its perfomance
      # compared to the memoized call above.
      #
      # if first?
      #   return self
      # end

      # right = @path.left.init.reverse.concat(@node.cons(@path.right))

      # MemoizedCursor.new(@path.left.last,
      #   Hole.new([], @path.parent, right), @parent)
      end

      # @return [MemoizedCursor]
      def last
        current = self
        current = current.next until current.last?
        current

      # @note: The code below is correct but doesn't take advantage of values
      # memoized by the sibling. Temporarily here to evaluate its perfomance
      # compared to the memoized call above.
      #
      # if last?
      #   return self
      # end

      # left = @node.cons(@path.right.init.reverse).concat(@path.left)

      # MemoizedCursor.new(@path.right.last,
      #   Hole.new(left, @path.parent, []), @parent)
      end

      # @group Editing the Tree
      #########################################################################

      # @return [EditedCursor]
      def append(node)
        EditedCursor.new(node,
          Hole.new(@node.cons(@path.left), @path.parent, @path.right), @parent)
      end

      # @return [EditedCursor]
      def prepend
        EditedCursor.new(node,
          Hole.new(@path.left, @path.parent, @node.cons(@path.right)), @parent)
      end

      # @return [EditedCursor]
      def replace(node)
        EditedCursor.new(node, @path, @parent)
      end

      # @return [EditedCursor]
      def delete
        if not last?
          # Move to `next`
          head, *tail = @path.right

          EditedCursor.new(head,
            Hole.new(@path.left, @path.parent, tail), @parent)
        elsif not first?
          # Move to `prev`
          head, *tail = @path.left

          EditedCursor.new(head,
            Hole.new(tail, @path.parent, @path.right), @parent)
        else
          # Deleting the only child
          parent =
            @parent.node.copy(:children =>
              @path.left.reverse.concat(@path.right))

          EditedCursor.new(parent, @path.parent, @parent.parent)
        end
      end

      # @endgroup
      #########################################################################
    end

  end
end
