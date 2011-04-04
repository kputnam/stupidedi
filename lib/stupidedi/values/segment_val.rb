module Stupidedi
  module Values

    # @see X222 B.1.1.3.4 Data Segment
    class SegmentVal < AbstractVal

      # @return [SegmentDef]
      delegate :definition, :to => :@usage

      # @return [Array<AbstractElementVal>]
      attr_reader :children

      # @return [SegmentUse]
      attr_reader :usage

      def initialize(children, usage)
        @children, @usage =
          children, usage
      end

      # @return [SegmentVal]
      def copy(changes = {})
        SegmentVal.new \
          changes.fetch(:children, @children),
          changes.fetch(:usage, @usage)
      end

      # @return false
      def leaf?
        false
      end

      # (see AbstractVal#segment?)
      # @return true
      def segment?
        true
      end

      def empty?
        @children.all?(&:empty?)
      end

      def defined_at?(n)
        definition.element_uses.defined_at?(n)
      end

      # @return [SimpleElementVal, CompositeElementVal, RepeatedElementVal]
      def at(n)
        raise IndexError unless defined_at?(n)

        if @children.defined_at?(n)
          @children.at(n)
        else
          definition.element_uses.at(n).definition.blank
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

    class InvalidSegmentVal < AbstractVal

      # @return [String]
      attr_reader :reason

      # @return [Reader::SegmentTok]
      attr_reader :segment_tok

      def initialize(reason, segment_tok)
        @reason, @segment_tok =
          reason, segment_tok
      end

      # @return [SegmentVal]
      def copy(changes = {})
        SegmentVal.new \
          changes.fetch(:reason, @reason),
          changes.fetch(:segment_tok, @segment_tok)
      end

      # @return true
      def leaf?
        true
      end

      # (see AbstractVal#segment?)
      # @return true
      def segment?
        false
      end

      def empty?
        @children.all?(&:empty?)
      end

      # @return [void]
      def pretty_print(q)
        id = ansi.invalid("[#{@segment_tok.id}]")

        q.text(ansi.segment("InvalidSegmentVal#{id}"))
        q.group(2, "(", ")") do
          q.breakable ""
          q.text @reason
          q.text ","
          q.breakable
          q.pp @segment_tok
        end
      end

      # @return [String]
      def inspect
        ansi.invalid(@segment_tok.id.to_s)
      end

      # @return [Boolean]
      def ==(other)
        eql?(other)
      end
    end

  end
end
