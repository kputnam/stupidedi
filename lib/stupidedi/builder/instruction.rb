module Stupidedi
  using Refinements

  module Builder

    class Instruction
      include Inspect

      # The segment identifier to which this {Instruction} applies
      #
      # @return [Symbol]
      attr_reader :segment_id

      # The segment use contains helpful information about the context of the
      # segment within a definition tree (eg the parent structure's definition).
      # It also enumerates the allowed values for segment qualifiers, which is
      # used to minimize non-determinism.
      #
      # @return [Schema::SegmentUse]
      attr_reader :segment_use

      # This indicates the number of levels to ascend and terminate within the
      # tree before storing the segment.
      #
      # @return [Integer]
      attr_reader :pop_count

      # This controls the allowed order in which structures may occur, by
      # indicating the number of instructions to remove from the beginning of
      # the instruction table.
      #
      # Repeatable structures have a value that ensures that their instruction
      # remains in the successor table.
      #
      # Sibling structures that have the same position (as defined by their
      # {Schema::SegmentUse}) will have equal drop_count values such that all of
      # the sibling instructions remain in the successor table when any one of
      # them is executed.
      #
      # @return [Integer]
      attr_reader :drop_count

      # This indicates that a child node should be added to the tree, which
      # will then contain the segment.
      #
      # When a segment indicates the start of a child structure, the class
      # indicated by this attribute is expected to respond to `push` by
      # creating a new {AbstractState}.
      #
      # @return [Zipper::AbstractCursor]
      attr_reader :push

      def initialize(segment_id, segment_use, pop, drop, push)
        @segment_id, @segment_use, @pop_count, @drop_count, @push =
          segment_id || segment_use.definition.id, segment_use, pop, drop, push
      end

      # @return [Instruction]
      def copy(changes = {})
        Instruction.new \
          changes.fetch(:segment_id, @segment_id),
          changes.fetch(:segment_use, @segment_use),
          changes.fetch(:pop_count, @pop_count),
          changes.fetch(:drop_count, @drop_count),
          changes.fetch(:push, @push)
      end

      # @return [void]
      def pretty_print(q)
        id = '% 3s' % @segment_id.to_s

        unless @segment_use.nil?
          width = 18
          name  = @segment_use.definition.name

          # Truncate the segment name to `width` characters
          if name.length > width - 2
            id << ": #{name.slice(0, width - 2)}.."
          else
            id << ": #{name.ljust(width)}"
          end
        end

        q.text "Instruction[#{'% 3s' % id}]"

        q.group(6, "(", ")") do
          q.breakable ""

          q.text "pop: #{@pop_count},"
          q.breakable

          q.text "drop: #{@drop_count}"

          unless @push.nil?
            q.text ","
            q.breakable
            q.text "push: #{@push.try{|c| c.name.split('::').last}}"
          end
        end
      end
    end

  end
end
