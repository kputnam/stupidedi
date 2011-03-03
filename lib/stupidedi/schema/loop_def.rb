module Stupidedi
  module Schema

    # @see X222 B.1.3.12.4 Loops of Data Segments
    class LoopDef
      # @return [String]
      attr_reader :id

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [Array<SegmentUse, LoopDef>]
      attr_reader :segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [LoopDef, TableDef]
      attr_reader :parent

      def initialize(id, repeat_count, children, parent)
        @id, @repeat_count, @children, @parent =
          id, repeat_count, children, parent

        @children = @children.map{|x| x.copy(:parent => self) }
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent)
      end

      # @see X222 B.1.1.3.11.1 Loop Control Segments
      # @see X222 B.1.1.3.12.4 Loops of Data Segments Bounded Loops
      def bounded?
        children.head.definition.id == :LS and
        children.last.definition.id == :LE
      end

      # @see X12.59 5.6 HL-initiated Loop
      def hierarchical?
        children.head.definition.id == :HL
      end

      def value(children_vals, parent)
        LoopVal.new(self, children_vals, parent)
      end

      def empty(parent)
        LoopVal.new(self, [], parent)
      end

      abstract :reader, :args => %w(input, context)

      # @private
      def pretty_print(q)
        q.text("LoopDef[#{@id}]")
        q.group(1, "(", ")") do
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
    end

    class << LoopDef
      def build(id, repeat_count, *children)
        new(id, repeat_count, children, nil)
      end
    end

  end
end
