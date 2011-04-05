module Stupidedi
  module Zipper

    class DanglingCursor < AbstractCursor

      # @private
      # @return [AbstractCursor]
      attr_reader :parent

      def initialize(parent)
        @parent = parent
      end

      def node
        raise Exceptions::ZipperError,
          "DanglingCursor#node should not be called"
      end

      # @group Querying the Tree Location
      #########################################################################

      def leaf?
        true
      end

      def root?
        false
      end

      def depth
        @parent.depth + 1
      end

      def first?
        true
      end

      def last?
        true
      end

      # @group Traversing the Tree
      #########################################################################

      # @return [AbstractCursor]
      def up
        @parent
      end

      def next
        raise Exceptions::ZipperError,
          "cannot move to next after last node"
      end

      def prev
        raise Exceptions::ZipperError,
          "cannot move to prev before first node"
      end

      def first
        self
      end

      def last
        self
      end

      # @group Editing the Tree
      #########################################################################

      # @return [EditedCursor]
      def append(node)
        @parent.append_child(node)
      end

      # @return [EditedCursor]
      def prepend
        @parent.append_child(node)
      end

      # @return [EditedCursor]
      def replace(node)
        @parent.append_child(node)
      end

      # @return [EditedCursor]
      def delete
        @parent
      end

      # @endgroup
      #########################################################################
    end

  end
end
