module Stupidedi
  module Builder

    class FailureState < AbstractState

      # @return [AbstractState]
      attr_reader :parent

      # @return [SegmentTok]
      attr_reader :segment_tok

      # @return [String]
      attr_reader :value
      alias explanation value

      def initialize(value, segment_tok, parent)
        @value, @segment_tok, @parent =
          value, segment_tok, parent
      end

      def failure?
        true
      end

      def instructions
        []
      end

      def pop(count)
        raise "@todo: FailureState#pop"
      end

      def drop(count)
        raise "@todo: FailureState#drop"
      end

      def add(segment_tok, segment_use)
        raise "@todo: FailureState#add"
      end
    end

  end
end
