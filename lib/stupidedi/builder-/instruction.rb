module Stupidedi
  module Builder_

    class Instruction

      # @return [Symbol]
      attr_reader :segment_id

      # @return [SegmentUse]
      attr_reader :segment_use

      # @return [Integer]
      attr_reader :pop

      # @return [Integer]
      attr_reader :drop

      # @return [Class<AbstractState>]
      attr_reader :push

      def initialize(segment_id, segment_use, pop, advance, push)
        @segment_id, @segment_use, @pop, @advance, @push =
          segment_id, segment_use, pop, advance, push
      end

      # @return [Instruction]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:segment_use, @segment_use),
          changes.fetch(:pop, @pop),
          changes.fetch(:advance, @advance),
          changes.fetch(:push, @push)
      end
    end

  end
end
