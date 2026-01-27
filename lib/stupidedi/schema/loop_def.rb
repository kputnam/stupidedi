# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # @see X222.pdf 2.2.2 Loops
    # @see X222.pdf B.1.3.12.4 Loops of Data Segments
    #
    class LoopDef < AbstractDef
      include Inspect

      # @return [String]
      attr_reader :id

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [Array<SegmentUse, LoopDef>]
      attr_reader :children

      # @return [LoopDef, TableDef]
      attr_reader :parent

      def_delegators :entry_segment_use, :requirement

      def_delegators :requirement, :required?, :optional?

      def initialize(id, repeat_count, children, parent)
        @id, @repeat_count, @children, @parent =
          id, repeat_count, children, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @children = @children.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [LoopDef]
      def copy(changes = {})
        LoopDef.new \
          changes.fetch(:id, @id),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent)
      end

      # Returns segments before the first LoopDef.
      # @deprecated Use {#children} instead. This method does not include
      #   segments that appear between child loops in interleaved structures.
      # @return [Array<SegmentUse>]
      def header_segment_uses
        @children.take_while{|x| x.is_a?(SegmentUse) }
      end

      # Returns all LoopDef children.
      # @deprecated Use {#children} instead and filter with `select{|x| x.is_a?(LoopDef)}`.
      # @return [Array<LoopDef>]
      def loop_defs
        @children.select{|x| x.is_a?(LoopDef) }
      end

      # Returns segments after the last LoopDef.
      # @deprecated Use {#children} instead. This method does not include
      #   segments that appear between child loops in interleaved structures.
      # @return [Array<SegmentUse>]
      def trailer_segment_uses
        last_loop_idx = @children.rindex{|x| x.is_a?(LoopDef) }
        return [] if last_loop_idx.nil?
        @children.drop(last_loop_idx + 1).select{|x| x.is_a?(SegmentUse) }
      end

      # @return [String]
      def descriptor
        "loop #{id}"
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      # @see X222 B.1.1.3.11.1 Loop Control Segments
      # @see X222 B.1.1.3.12.4 Loops of Data Segments Bounded Loops
      def bounded?
        first_seg = @children.find{|x| x.is_a?(SegmentUse) }
        last_seg = @children.reverse.find{|x| x.is_a?(SegmentUse) }
        first_seg && last_seg &&
          first_seg.definition.id == :LS &&
          last_seg.definition.id == :LE
      end

      # @see X12.59 5.6 HL-initiated Loop
      def hierarchical?
        first_seg = @children.find{|x| x.is_a?(SegmentUse) }
        first_seg && first_seg.definition.id == :HL
      end

      # @return [SegmentUse]
      def entry_segment_use
        @children.find{|x| x.is_a?(SegmentUse) }
      end

      # @return [LoopVal]
      def empty
        Values::LoopVal.new(self, [])
      end

      def loop?
        true
      end

      # @return [AbstractSet<CodeList>]
      def code_lists
        @children.map(&:code_lists).inject(&:|)
      end

      # @return [void]
      def pretty_print(q)
        q.text("LoopDef[#{@id}]")
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
    end

    class << LoopDef
      # @group Constructors
      #########################################################################

      # @return [LoopDef]
      def build(id, repeat_count, *children)
        # Validate: first child must be a SegmentUse
        if children.empty? || !children.head.is_a?(SegmentUse)
          raise Exceptions::InvalidSchemaError,
            "first child must be a SegmentUse"
        elsif children.head.repeat_count.include?(2)
          raise Exceptions::InvalidSchemaError,
            "first child must have RepeatCount.bounded(1)"
        end

        new(id, repeat_count, children, nil)
      end

      # @endgroup
      #########################################################################
    end
  end
end
