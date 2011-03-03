module Stupidedi
  module Builder

    class StateMachine
      def initialize(router)
        @leaves = [TransmissionBuilder.start(router)]
      end

      def successors(input)
        if @leaves.length == 1
          @leaves.first.successors(input)
        else
          @leaves.inject([]) do |list, s|
            list.concat(s.successors(input))
          end
        end
      end

      def read(input)
        successes, failures = successors(input).partition(&:success?)
        @leaves = successes
      end
    end

  end
end
