# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Zipper
    class DanglingCursor < AbstractCursor
      # @return [AbstractCursor]
      attr_reader :parent

      def initialize(parent)
        @parent = parent
      end

      # (see AbstractCursor#node)
      def node
        raise Exceptions::ZipperError,
          "DanglingCursor#node should not be called"
      end

      # (see AbstractCursor#path)
      def path
        Hole.new([], @parent.path.parent, [])
      end

      # @group Querying the Tree Location
      #########################################################################

      # (see AbstractCursor#leaf?)
      def leaf?
        true
      end

      # (see AbstractCursor#root?)
      def root?
        false
      end

      # (see AbstractCursor#depth)
      def depth
        @parent.depth + 1
      end

      # (see AbstractCursor#first?)
      def first?
        true
      end

      # (see AbstractCursor#last?)
      def last?
        true
      end

      # @group Traversing the Tree
      #########################################################################

      # @return [AbstractCursor]
      def up
        @parent
      end

      # (see AbstractCursor#next)
      def next
        raise Exceptions::ZipperError,
          "cannot move to next after last node"
      end

      # (see AbstractCursor#prev)
      def prev
        raise Exceptions::ZipperError,
          "cannot move to prev before first node"
      end

      # (see AbstractCursor#first)
      def first
        self
      end

      # (see AbstractCursor#last)
      def last
        self
      end

      # @group Editing the Tree
      #########################################################################

      # (see AbstractCursor#replace)
      def replace(node)
        @parent.append_child(node)
      end

      alias prepend replace
      alias append  replace

      # (see AbstractCursor#delete)
      def delete
        self
      end

      # @endgroup
      #########################################################################
    end
  end
end
