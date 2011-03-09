module Stupidedi
  module Builder

    #
    # This state machine processes all possible states (ie, interpretations) of
    # the input in parallel using a breadth-first traversal.
    #
    # If the grammar is deterministic, the state machine will parse the input in
    # linear time, proportional to the number of tokens. Otherwise, performance
    # is proportional to the grammar's degree of non-determinism. It performs
    # better when fewer tokens are required to resolve the non-determinism.
    #
    # @see http://en.wikipedia.org/wiki/GLR_parser
    #
    class StateMachine

      # @return [Array<AbstractState>]
      attr_reader :states

      # @return [Array<FailureState>]
      attr_reader :failures

      def initialize(failures, states)
        @failures, @states = failures, states
      end

      # @return [StateMachine]
      def advance!(segment_tok)
        successors =
          case @states.length
          when 0 then []
          when 1 then @states.head.successors(segment_tok)
          else
            @states.inject([]) do |list, s|
              list.concat(s.successors(segment_tok))
            end
          end

        failures, states = successors.partition(&:stuck?)

        @states = states
        @failures.concat(failures)

        self
      end

      def read!(reader)
        remainder = Either.success(reader)

        while not stuck? and remainder.defined?
          remainder = remainder.flatmap(&:read_segment).map do |result|
            # result.value: SegmentTok
            # result.remainder: TokenReader
            advance!(result.value)

            if @states.size > 1
              pp @states
              pp @states.size
              pp result.value
              raise
            end

            if stuck?
              return remainder
            end

            # @todo: Handle non-deterministic state
            #
            # @todo: Can we move these comparisons into the respective
            # Builder classes, so we can skip them most of the time?

            case result.value.id
            when :ISA
              # value: InterchangeVal

              # Add the interchange version-specific separators to TokenReader
              value.merge!(result.remainder)

              value.separators.segment =
                result.remainder.separators.segment

              value.separators.element =
                result.remainder.separators.element

              # Add the interchange segment definitions
              result.remainder.segment_dict =
                result.remainder.segment_dict.concat(value.segment_dict)
            when :GS
              # value: FunctionalGroupVal

              # Add the segment definitions defined by the functional group
              result.remainder.segment_dict =
                result.remainder.segment_dict.concat(value.segment_dict)
            when :GE
              # value: FunctionalGroupVal

              # Remove the segment definitions defined by the functional group
              result.remainder.segment_dict =
                result.remainder.segment_dict.pop
            when :ISE
              # value: InterchangeVal

              # Remove the interchange version-specific separators from TokenReader
              value.unmerge!(result.remainder)

              # Remove the interchange segment definitions
              result.remainder.segment_dict =
                result.remainder.segment_dict.pop
            end

            result.remainder
          end
        end

        # @todo: "Reached end of input without finding a segment identifier" is
        # a normal failed state, but we can't easily prevent it because #empty?
        # is false, even if the only remaining input is control characters
        @states.first.terminate

        remainder
      end

      def stuck?
        @states.empty?
      end

      # @return [Values::AbstractVal]
      def value
        if @states.length == 1
          @states.first.value
        end
      end
    end

    class << StateMachine
      def start(config)
        start = TransmissionBuilder.start(config)
        StateMachine.new([], start.cons)
      end
    end

  end
end
