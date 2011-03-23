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


      #########################################################################
      # @group Query Methods

      # @return 0
      def depth
        0
      end

      # @return true
      def first?
        true
      end

      # @return true
      def last?
        true
      end

      def leaf?
        @node.leaf? or @node.children.empty?
      end

      # @return true
      def root?
        true
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Traversal Methods

      # @return [void]
      def next
        raise Exceptions::ZipperError,
          "root has no siblings"
      end

      # @return [void]
      def prev
        raise Exceptions::ZipperError,
          "root has no siblings"
      end

      # @return [RootCursor]
      def root
        self
      end

      # @return [void]
      def up
        raise Exceptions::ZipperError,
          "root has no parent"
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Editing Methods

      # @return [void]
      def append(node)
        raise Exceptions::ZipperError,
          "root has no siblings"
      end

      # @return [void]
      def prepend(node)
        raise Exceptions::ZipperError,
          "root has no siblings"
      end

      # @return [RootCursor]
      def replace(node)
        RootCursor.new(node)
      end

      # @return [void]
      def delete
        raise Exceptions::ZipperError,
          "cannot delete root"
      end
    end

  end
end
