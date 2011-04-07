module Stupidedi
  module Zipper

    class EditedCursor < AbstractCursor

      # (see AbstractCursor#node)
      attr_reader :node

      # @return [Hole]
      attr_reader :path

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
        false
      end

      # @group Traversing the Tree
      #########################################################################

      # (see AbstractCursor#up)
      # @return [AbstractCursor]
      def up
        node =
          @parent.node.copy(:children =>
            @path.left.reverse.concat(@node.cons(@path.right)))

        if parent.root?
          RootCursor.new(node)
        else
          EditedCursor.new(node, @path.parent, @parent.parent)
        end
      end

      # (see AbstractCursor#next)
      # @return [EditedCursor]
      def next
        if last?
          raise Exceptions::ZipperError,
            "cannot move to next after last node"
        end

        head, *tail = @path.right

        EditedCursor.new(head,
          Hole.new(@node.cons(@path.left), @path.parent, tail), @parent)
      end

      # (see AbstractCursor#prev)
      # @return [EditedCursor]
      def prev
        if first?
          raise Exceptions::ZipperError,
            "cannot move to prev before first node"
        end

        head, *tail = @path.left

        EditedCursor.new(head,
          Hole.new(tail, @path.parent, @node.cons(@path.right)), @parent)
      end

      # (see AbstractCursor#first)
      # @return [EditedCursor]
      def first
        if first?
          return self
        end

        right = @path.left.init.reverse.concat(@node.cons(@path.right))

        EditedCursor.new(@path.left.last,
          Hole.new([], @path.parent, right), @parent)
      end

      # (see AbstractCursor#last)
      # @return [EditedCursor]
      def last
        if last?
          return self
        end

        left = @node.cons(@path.right.init.reverse).concat(@path.left)

        EditedCursor.new(@path.right.last,
          Hole.new(left, @path.parent, []), @parent)
      end

      # @group Editing the Tree
      #########################################################################

      # (see AbstractCursor#last)
      # @return [EditedCursor]
      def append(node)
        EditedCursor.new(node,
          Hole.new(@node.cons(@path.left), @path.parent, @path.right), @parent)
      end

      # (see AbstractCursor#last)
      # @return [EditedCursor]
      def prepend(node)
        EditedCursor.new(node,
          Hole.new(@path.left, @path.parent, @node.cons(@path.right)), @parent)
      end

      # (see AbstractCursor#last)
      # @return [EditedCursor]
      def replace(node)
        EditedCursor.new(node, @path, @parent)
      end

      # (see AbstractCursor#last)
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

          EditedCursor.new(parent, @path.parent, @parent.parent).dangle
        end
      end

      # @endgroup
      #########################################################################
    end

  end
end
