module Stupidedi
  module Zipper

    class DanglingCursor < AbstractCursor

      # @private
      # @return [AbstractCursor]
      attr_reader :parent

      def initialize(parent)
        @parent = parent
      end

      #########################################################################
      # @group Query Methods

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

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Traversal Methods

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
        raise Exceptions::ZipperError,
          "cannot move to first node"
      end

      def last
        raise Exceptions::ZipperError,
          "cannot move to last node"
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Editing Methods

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
