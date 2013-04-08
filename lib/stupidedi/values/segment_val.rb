module Stupidedi
  module Values

    # @see X222 B.1.1.3.4 Data Segment
    class SegmentVal < AbstractVal

      # @return [SegmentDef]
      delegate_stupid :definition, :to => :@usage

      # @return [Array<AbstractElementVal>]
      attr_reader :children

      # @return [SegmentUse]
      attr_reader :usage

      # @return [Position]
      attr_reader :position

      def initialize(children, usage, position)
        @children, @usage, @position =
          children, usage, position
      end

      # @return [SegmentVal]
      def copy(changes = {})
        SegmentVal.new \
          changes.fetch(:children, @children),
          changes.fetch(:usage, @usage),
          changes.fetch(:position, @position)
      end

      # (see AbstractVal#size)
      def size
        1
      end

      # @return [Symbol]
      def id
        definition.id
      end

      # @return false
      def leaf?
        false
      end

      def valid?
        true
      end

      # (see AbstractVal#segment?)
      # @return true
      def segment?
        true
      end

      # @return [AbstractElementVal]
      def element(m, n = nil, o = nil)
        unless m > 0
          raise ArgumentError,
            "m must be positive"
        end

        unless n.nil?
          @children.at(m - 1).element(n, o)
        else
          @children.at(m - 1)
        end
      end

      # @return [void]
      def pretty_print(q)
        id = definition.try do |d|
          ansi.bold("[#{d.id}: #{d.name}]")
        end

        q.text(ansi.segment("SegmentVal#{id}"))
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [String]
      def inspect
        ansi.segment(ansi.bold(definition.id.to_s))
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == definition and
          other.children   == @children)
      end
    end

  end
end
