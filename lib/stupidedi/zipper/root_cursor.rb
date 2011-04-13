module Stupidedi
  module Zipper

    class RootCursor < AbstractCursor

      # @return [AbstractNode]
      attr_reader :node

      # @return [AbstractPath]
      attr_reader :path

      def initialize(node)
        @node, @path =
          node, Root
      end

      # @group Query the Tree Location
      #########################################################################

      # (see AbstractCursor#depth)
      def depth
        0
      end

      # (see AbstractCursor#first?)
      def first?
        true
      end

      # (see AbstractCursor#last?)
      def last?
        true
      end

      # (see AbstractCursor#leaf?)
      def leaf?
        @node.leaf? or @node.children.empty?
      end

      # (see AbstractCursor#root?)
      def root?
        true
      end

      # @group Traversing the Tree
      #########################################################################
      
      # (see AbstractCursor#first)
      def first
        self
      end

      # (see AbstractCursor#last)
      def last
        self
      end

      # (see AbstractCursor#next)
      # @return [void]
      def next
        raise Exceptions::ZipperError,
          "root node has no siblings"
      end

      # (see AbstractCursor#prev)
      # @return [void]
      def prev
        raise Exceptions::ZipperError,
          "root node has no siblings"
      end

      # (see AbstractCursor#root)
      # @return [RootCursor]
      def root
        self
      end

      # (see AbstractCursor#up)
      # @return [void]
      def up
        raise Exceptions::ZipperError,
          "root node has no parent"
      end

      # @group Editing the Tree
      #########################################################################

      # (see AbstractCursor#append)
      # @return [void]
      def append(node)
        raise Exceptions::ZipperError,
          "root node has no siblings"
      end

      # (see AbstractCursor#prepend)
      # @return [void]
      def prepend(node)
        raise Exceptions::ZipperError,
          "root node has no siblings"
      end

      # (see AbstractCursor#replace)
      # @return [RootCursor]
      def replace(node)
        RootCursor.new(node)
      end

      # (see AbstractCursor#delete)
      # @return [void]
      def delete
        raise Exceptions::ZipperError,
          "cannot delete root node"
      end

      # @endgroup
      #########################################################################
    end

  end
end
