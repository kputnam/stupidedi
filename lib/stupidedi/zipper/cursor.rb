module Stupidedi
  module Zipper

    class Cursor

      # @return [Object]
      attr_reader :node

      # @private
      # @return [Cursor]
      attr_reader :parent

      def initialize(node, parent, path)
        @node, @parent, @path =
          node, parent, path
      end

      #########################################################################
      # @group Predicate Methods

      def depth
        @path.depth
      end

      def first?
        @path.first?
      end

      def last?
        @path.last?
      end

      def leaf?
        @node.leaf? or @node.children.empty?
      end

      def root?
        @path.root?
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Traversal Methods

      # @return [Cursor]
      def prev
        @path.prev(@node, @parent)
      end

      # @return [Cursor]
      def next
        @path.next(@node, @parent)
      end

      # @return [Cursor]
      def up
        @path.up(@node, @parent)
      end

      # @return [Cursor]
      def down
        if leaf?
          raise Exceptions::ZipperError,
            "No child nodes"
        end

        head, *tail = @node.children
        Cursor.new(head, self,
          Hole.new([], @path, tail))
      end

      # @return [Cursor]
      def root
        cursor = self
        cursor = cursor.up until cursor.root?
        cursor
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Editing Methods

      # @return [Cursor]
      def replace(node)
        Cursor.new(node, @parent, @path)
      end

      # @return [Cursor]
      def append(node)
        Cursor.new(@node, @parent, @path.append(node))
      end

      # @return [Cursor]
      def prepend(node)
        Cursor.new(@node, @parent, @path.prepend(node))
      end

      # @return [Cursor]
      def push(node)
        children =
          if node.leaf?
            []
          else
            node.children
          end

        Cursor.new(node, self,
          Hole.new([], @path.parent, children))
      end

      # @return [Cursor]
      def delete
        if @path.root?
          raise Exceptions::ZipperError,
            "Cannot delete root node"
        end

        if not @path.successors.empty?
          # Move to the next successor
          head, *tail = @path.successors

          Cursor.new(head, @parent,
            Hole.new(@path.predecessors, @path.parent, tail))
        elsif not @path.predecessors.empty?
          # Move to the next predecessors
          head, *tail = @path.predecessors

          Cursor.new(head, @parent,
            Hole.new(tail, @path.parent, @path.successors))
        else
          # Move to the parent
          @path.up(nil, @parent)
        end
      end

      # @endgroup
      #########################################################################

      # @return [void]
      def pretty_print(q)
        q.text "Cursor"
        q.group(2, "(", ")") do
          q.breakable ""
          q.text @path.inspect
          q.text ","
          q.breakable
          q.pp @node
        end
      end

      # @return [String]
      def inspect
        "Cursor(#{@path.inspect}, #{@node.inspect})"
      end
    end

  end
end
