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

      def repeatable?
        @repeatable
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
      def detail(id, *children, repeatable: true)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 2, repeatable, header, loop_defs, trailer, nil)
      end

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
