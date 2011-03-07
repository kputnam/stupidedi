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
      def segment(segment_tok)
        successors =
          case @states.length
          when 0 then []
          when 1 then @states.head.segment(segment_tok)
          else
            @states.inject([]) do |list, s|
              list.concat(s.segment(segment_tok))
            end
          end

        failures, states = successors.partition(&:stuck?)

        self.class.new(failures, states)
      end

      def read(reader)
        reader.read_segment.map do |result|
          pp result
        end
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
