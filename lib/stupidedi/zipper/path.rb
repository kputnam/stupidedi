module Stupidedi
  module Zipper

    class AbstractPath
      abstract :root?
    end

    Root = Class.new(AbstractPath) do
      def root?
        true
      end

      def parent
        self
      end

      def prev
        raise Exceptions::ZipperError,
          "No predecessor sibling nodes"
      end

      def next
        raise Exceptions::ZipperError,
          "No successor sibling nodes"
      end

      def up
        raise Exceptions::ZipperError,
          "No parent node"
      end

      def inspect
        "Root"
      end
    end.new

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

      def root?
        false
      end

      def number
        @predecessors.length
      end

      # @return [Cursor]
      def prev(node)
        if @predecessors.empty?
          raise Exceptions::ZipperError,
            "No predecessor sibling nodes"
        end

        head, *tail = @predecessors

        Cursor.new(head,
          Hole.new(tail, @parent, node.cons(@successors)))
      end

      # @return [Cursor]
      def next(node)
        if @successors.empty?
          raise Exceptions::ZipperError,
            "No successor sibling nodes"
        end

        head, *tail = @successors

        Cursor.new(head,
          Hole.new(node.cons(@predecessors), @parent, tail))
      end

      # @return [Array<AbstractNode>]
      def up
        @predecessors.reverse.cons(@successors)
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
        "Hole(#{@predecessors.inspect}, #{@parent.inspect}, #{@successors.inspect})"
      end

    end

  end
end
