module Stupidedi
  module Builder

    #
    # @see http://en.wikipedia.org/wiki/GLR_parser
    #
    class StateMachine
      attr_reader :states

      def initialize(states)
        @states = states
      end

      # @return [NonDeterministicStateMachine]
      def segment(name, elements)
        successors =
          case @states.length
          when 0 then []
          when 1 then @states.head.segment(name, elements)
          else
            @states.inject([]) do |list, s|
              list.concat(s.segment(name, elements))
            end
          end

        #
        # states, failures = successors.patition(&:stuck?)
        self.class.new(successors)
      end

      def value
        if @states.length == 1
          @states.first.value
        end
      end
    end

    class << StateMachine
      def start(router)
        start = TransmissionBuilder.start(router)
        StateMachine.new(start.cons)
      end
    end

  end
end
