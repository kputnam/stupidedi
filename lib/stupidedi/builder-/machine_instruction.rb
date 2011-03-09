module Stupidedi
  module Builder_

    class Instruction

      # @return [SegmentUse]
      attr_reader :segment_use

      # @return [Integer]
      attr_reader :pop

      # @return [Integer]
      attr_reader :advance

      # @return [Array(Class<AbstractState>, SegmentUse)]
      attr_reader :push

      def initialize(segment_use, pop, advance, push)
        @segment_use, @pop, @advance, @push =
          segment_use, pop, advance, push
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
