module Stupidedi
  module Schema

    # @see X222 B.1.3.12.4 Loops of Data Segments
    class LoopDef
      # @return [String]
      attr_reader :id

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [LoopDef, TableDef]
      attr_reader :parent

      def initialize(id, repeat_count, header_segment_uses, loop_defs, trailer_segment_uses, parent)
        @id, @repeat_count, @header_segment_uses, @loop_defs, @trailer_segment_uses, @parent =
          id, repeat_count, header_segment_uses, loop_defs, trailer_segment_uses, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @header_segment_uses  = @header_segment_uses.map{|x| x.copy(:parent => self) }
          @loop_defs            = @loop_defs.map{|x| x.copy(:parent => self) }
          @trailer_segment_uses = @trailer_segment_uses.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [LoopDef]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      # @return [Array<SegmentUse>]
      def segment_uses
        @header_segment_uses + @trailer_segment_uses
      end

      # @see X222 B.1.1.3.11.1 Loop Control Segments
      # @see X222 B.1.1.3.12.4 Loops of Data Segments Bounded Loops
      def bounded?
        @header_segment_uses.head.definition.id == :LS and
        @trailer_segment_uses.last.definition.id == :LE
      end

      # @see X12.59 5.6 HL-initiated Loop
      def hierarchical?
        @header_segment_uses.head.definition.id == :HL
      end

      # @return [Array<SegmentUse>]
      def entry_segment_uses
        @header_segment_uses.head.cons
      end

      # @return [LoopVal]
      def value(segment_val, parent = nil)
        Values::LoopVal.new(self, segment_val.cons, [], [], parent)
      end

      # @return [LoopVal]
      def empty(parent = nil)
        Values::LoopVal.new(self, [], [], [], parent)
      end

      # @private
      def pretty_print(q)
        q.text("LoopDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @loop_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @trailer_segment_uses.each do |e|
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
      # @return [LoopDef]
      def build(id, repeat_count, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }

        # @todo: Ensure there is at least one SegmentUse in header
        if header.empty?
          raise Exceptions::InvalidSchemaError,
            "LoopDef must start with a SegmentUse"
        elsif header.head.repeat_count.include?(0)
          "First SegmentUse in LoopDef must have RepeatCount.bounded(1)"
        end

        new(id, repeat_count, header, loop_defs, trailer, nil)
      end
    end

  end
end
