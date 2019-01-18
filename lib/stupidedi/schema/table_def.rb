# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class TableDef < AbstractDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [TransactionSetDef]
      attr_reader :parent

      # @return [Integer]
      attr_reader :position

      def initialize(id, position, repeatable, header_segment_uses, loop_defs, trailer_segment_uses, parent)
        @id, @position, @repeatable, @header_segment_uses, @loop_defs, @trailer_segment_uses, @parent =
          id, position, repeatable, header_segment_uses, loop_defs, trailer_segment_uses, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @header_segment_uses  = @header_segment_uses.map{|x| x.copy(:parent => self) }
          @loop_defs            = @loop_defs.map{|x| x.copy(:parent => self) }
          @trailer_segment_uses = @trailer_segment_uses.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [TableDef]
      def copy(changes = {})
        TableDef.new \
          changes.fetch(:id, @id),
          changes.fetch(:position, @position),
          changes.fetch(:repeatable, @repeatable),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      # @return [String]
      def descriptor
        "table #{id}"
      end

      def repeatable?
        @repeatable
      end

      def repeat_count
        if @repeatable
          RepeatCount.unbounded
        else
          RepeatCount.bounded(1)
        end
      end

      def required?
        entry_segment_uses.any?(&:required?)
      end

      # @return [Array<SegmentUse>]
      def entry_segment_uses
        uses = []
        uses.concat(@header_segment_uses)
        uses.concat(@loop_defs.map{|l| l.entry_segment_use })
        uses.concat(@trailer_segment_uses)

        # Up to and including the first required segment
        opt, req = uses.split_until(&:optional?)
        opt.concat(req.take(1))
      end

      # @return [Array<SegmentUse, LoopDef>]
      def children
        @header_segment_uses + @loop_defs + @trailer_segment_uses
      end

      # @return [Values::TableVal]
      def empty
        Values::TableVal.new(self, [])
      end

      def table?
        true
      end

      # @return [AbstractSet<CodeList>]
      def code_lists
        children.map(&:code_lists).inject(&:|)
      end

      # @return [void]
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
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

    class << TableDef
      # @group Constructors
      #########################################################################

      # @return [TableDef]
      def header(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 1, false, header, loop_defs, trailer, nil)
      end

      # @return [TableDef]
      def detail(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 2, false, header, loop_defs, trailer, nil)
      end

      # @todo This cannot work properly without changing
      # {ConstraintTable::ValueBased#matches} to not narrow the table down first
      # by using deepest(...); this is because, while we insert matching loops
      # into the current table, alternating loops would be placed in alternating
      # tables. Thus, for {Navigation#find} we need to search the current table
      # first but then try an uncle table (cousin loop) next. These are two
      # different instructions, but {#matches} would only provide an instruction
      # to search the current table.
      #
      # @return [TableDef]
      # def repeatable_detail(id, *children)
      #   header, children   = children.split_when{|x| x.is_a?(LoopDef) }
      #   loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
      #   new(id, 2, true, header, loop_defs, trailer, nil)
      # end

      # @return [TableDef]
      def summary(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 3, false, header, loop_defs, trailer, nil)
      end

      # @endgroup
      #########################################################################
    end
  end
end
