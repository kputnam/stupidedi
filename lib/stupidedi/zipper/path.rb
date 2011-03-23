module Stupidedi
  module Zipper

    # @private
    class AbstractPath
    end

    # @private
    Root = Class.new(AbstractPath) do

      # return 0
      def depth
        0
      end

      # @return true
      def root?
        true
      end

      # @return true
      def first?
        true
      end

      # @return true
      def last?
        true
      end

      # @return self
      def parent
        self
      end

      # @raise Exceptions::ZipperError
      def prev(node, parent)
        raise Exceptions::ZipperError,
          "No predecessor sibling nodes"
      end

      # @raise Exceptions::ZipperError
      def next(node, parent)
        raise Exceptions::ZipperError,
          "No successor sibling nodes"
      end

      # @raise Exceptions::ZipperError
      def up(node, parent)
        raise Exceptions::ZipperError,
          "No parent node"
      end

      # @return [String]
      def inspect
        "Root"
      end
    end.new

    # @private
    class Hole < AbstractPath

      # @return [Array<AbstractNode>]
      attr_reader :predecessors

      # @return [AbstractPath]
      attr_reader :parent

      # @return [Array<AbstractNode>]
      attr_reader :successors

      def initialize(predecessors, parent, successors)
        @predecessors, @parent, @successors =
          predecessors, parent, successors
      end

      def depth
        @parent.depth + 1
      end

      def root?
        false
      end

      def first?
        @predecessors.empty?
      end

      def last?
        @successors.empty?
      end

      # @return [Cursor]
      def prev(node, parent)
        if @predecessors.empty?
          raise Exceptions::ZipperError,
            "No predecessor sibling nodes"
        end

        head, *tail = @predecessors

        Cursor.new(head, parent,
          Hole.new(tail, @parent, node.cons(@successors)))
      end

      # @return [Cursor]
      def next(node, parent)
        if @successors.empty?
          raise Exceptions::ZipperError,
            "No successor sibling nodes"
        end

        head, *tail = @successors

        Cursor.new(head, parent,
          Hole.new(node.cons(@predecessors), @parent, tail))
      end

      # @return [Cursor]
      def up(node, parent)
        children = if node.nil?
                     @predecessors.reverse.concat(@successors)
                   else
                     @predecessors.reverse.concat(node.cons(@successors))
                   end

        Cursor.new(parent.node.copy(:children => children),
          parent.parent, @parent)
      end

      # @return [Hole]
      def append(node)
        Hole.new(@predecessors, @parent, node.cons(@successors))
      end

      # @return [Hole]
      def prepend(node)
        Hole.new(node.cons(@predecessors), @parent, @successors)
      end

      # @return [void]
      def pretty_print(q)
        q.text "Hole"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @predecessors
          q.text ","
          q.breakable
          q.pp @parent
          q.text ","
          q.breakable
          q.pp @successors
        end
      end

      # @return [String]
      def inspect
        if @predecessors.empty?
          "#{@parent.inspect}.down"
        else
          "#{@parent.inspect}.down#{'.next' * @predecessors.length})"
        end
      end

    end

  end
end
