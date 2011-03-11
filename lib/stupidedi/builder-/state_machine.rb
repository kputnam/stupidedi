module Stupidedi
  module Builder_

    class StateMachine

      def initialize(states, errors)
        @states, @errors = states, errors
      end

      def read(segment_tok)
        case @states.length
        when 0
        when 1
          state, table = @states.head
          instructions = table.successors(segment_tok)

          @states = instructions.map do |x|
            if x.push.nil?
              s = state.pop(x.pop).append(segment_tok, x.segment_use)
              t = table.pop(x.pop).drop(x.drop)
              s.cons(t).cons
            else
              s = x.push.push(segment_tok, x.segment_use, state)
              t = table.pop(x.pop).drop(x.drop).push(s.successors)
              s.cons(t).cons
            end
          end
        else
        end
      end

      def deterministic?
        @states.length <= 1
      end
    end

  end
end
