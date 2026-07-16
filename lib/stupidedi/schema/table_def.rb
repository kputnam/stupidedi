# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class TableDef < AbstractDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse, LoopDef>]
      attr_reader :children

      # @return [TransactionSetDef]
      attr_reader :parent

      # @return [Integer]
      attr_reader :position

      def initialize(id, position, children, parent)
        @id, @position, @children, @parent =
          id, position, children, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @children = @children.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [TableDef]
      def copy(changes = {})
        TableDef.new \
          changes.fetch(:id, @id),
          changes.fetch(:position, @position),
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
        "table #{id}"
      end

      def repeatable?
        header_segment_uses.empty? and
          loop_defs.present?       and
          loop_defs.head.repeatable?
      end

      def repeat_count
        if repeatable?
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
        uses = @children.map do |child|
          if child.is_a?(SegmentUse)
            child
          else
            child.entry_segment_use
          end
        end

        # Up to and including the first required segment
        suffix = uses.drop_while(&:optional?)

        if suffix.present?
          # Some segment(s) is required, so table can't start without it
          position = suffix.map(&:position).min
          uses.take_while{|u| u.position <= position }
        else
          # Nothing is required, table can begin at any of these
          uses
        end
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
        @children.map(&:code_lists).inject(&:|)
      end

      # @return [void]
      # :nocov:
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
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
      # :nocov:
    end

    class << TableDef
      # @group Constructors
      #########################################################################

      # @return [TableDef]
      def header(id, *children)
        unless id.is_a?(String)
          raise Exceptions::InvalidSchemaError,
            "first argument to TableDef.header must be a String but got #{id.inspect}"
        end

        new(id, 1, children, nil)
      end

      # @return [TableDef]
      def detail(id, *children)
        unless id.is_a?(String)
          raise Exceptions::InvalidSchemaError,
            "first argument to TableDef.detail must be a String but got #{id.inspect}"
        end

        new(id, 2, children, nil)
      end

      # @return [TableDef]
      def summary(id, *children)
        unless id.is_a?(String)
          raise Exceptions::InvalidSchemaError,
            "first argument to TableDef.summary must be a String but got #{id.inspect}"
        end

        new(id, 3, children, nil)
      end

      # @endgroup
      #########################################################################
    end
  end
end
