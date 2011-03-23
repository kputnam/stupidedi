module Stupidedi
  module Zipper

    class Cursor

      # @return [AbstractNode]
      attr_reader :node

      # @return [AbstractPath]
      attr_reader :path

      def initialize(node, path)
        @node, @path =
          node, path
      end

      #########################################################################
      # @group Location Methods

      def first?
        @path.predecessors.empty?
      end

      def last?
        @path.successors.empty?
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
        @path.prev(@node)
      end

      # @return [Cursor]
      def next
        @path.next(@node)
      end

      # @return [Cursor]
      def up
      # Cursor.new(@node.copy(:children => @path.up), @path.parent)
      end

      # @return [Cursor]
      def down
        head, *tail = @node.children
        Cursor.new(head,
          Hole.new([], @path, tail))
      end

      # @return [Cursor]
      def root
        cursor = self
        cursor = cursor.up until cursor.path.root?
        cursor
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Editing Methods

      # @return [Cursor]
      def replace(node)
        Cursor.new(node, @path)
      end

      def append(node)
        Cursor.new(@node, @path.append(node))
      end

      def prepend(node)
        Cursor.new(@node, @path.prepend(node))
      end

      def push(node)
        Cursor.new(node, Hole.new([], @path.parent, @node.children))
      end

      def delete
        if @path.root?
          raise Exceptions::ZipperError,
            "Cannot delete root node"
        end

        if not @path.successors.empty?
          # Move to the next successor
          head, *tail = @path.successors
          Cursor.new(head,
            Hole.new(@path.predecessors, @path.parent, tail))
        elsif not @path.predecessors.empty?
          # Move to the next predecessors
          head, *tail = @path.predecessors
          Cursor.new(head,
            Hole.new(tail, @path.parent, @path.successors))
        else
          # Move to the parent
          Cursor.new(@node.parent.copy(:children => []), @path.parent)
        end
      end

      # @endgroup
      #########################################################################

      # @return [void]
      def pretty_print(q)
        q.text "Cursor"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @node
          q.text ","
          q.breakable
          q.pp @path
        end
      end

      # @return [String]
      def inspect
        "Cursor(#{@node.inspect}, #{@path.inspect})"
      end

    end

    class << Cursor

      # @return [Cursor]
      def build(node)
        new(node, Root)
      end
    end

  end
end
