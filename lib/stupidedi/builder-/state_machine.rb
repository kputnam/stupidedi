module Stupidedi
  module Builder_

    class StateMachine

      def initialize(states, errors)
        @states, @errors = states, errors
      end

      def input!(segment_tok, reader = nil)
        states = []
        errors = []

        @states.each do |state|
          state, table = state
          instructions = table.successors(segment_tok)

          if instructions.empty?
            errors.push(segment_tok)
            next
          end

          # Evaluate each instruction to compute the next AbstractState {s} and
          # and the InstructionTable {t}.
          instructions.each do |x|
            if x.push.nil?
              s = state.pop(x.pop).add(segment_tok, x.segment_use)
              t = table.pop(x.pop).drop(x.drop)

              unless x.pop.zero? or reader.nil?
                # More general than checking if segment_tok is an ISE/GE segment
                if not reader.separators.eql?(s.separators)
                  reader = reader.copy \
                    :separators   => s.separators,
                    :segment_dict => s.segment_dict
                elsif not reader.segment_dict.eql?(s.segment_dict)
                  reader = reader.copy \
                    :separators   => s.separators,
                    :segment_dict => s.segment_dict
                end
              end
            else
              # Note: Instruction#push returns a subclass of AbstractState,
              # which has a constructor method named {push}, that links the new
              # instance to the parent {state}
              a = x.push
              s = a.push(segment_tok, x.segment_use, state.pop(x.pop), reader)

              # @todo: Check for FailureState

              t = table.pop(x.pop).drop(x.drop)
              i = s.instructions

              if i.is_a?(Array)
                # Normally we only pushed a single {AbstractState}, so we only
                # need to add one layer to the instruction table.
                t = t.push(i)
              else
                # But sometimes we actually pushed more than one {AbstractState}
                # eg, by falling through TransactionSetState to TableState in a
                # single transition. In this case we need to concatenate tables.
                t = t.concat(i)
              end

              unless reader.nil?
                # More general than checking if segment_tok is an ISA/GS segment
                if not reader.separators.eql?(s.separators)
                  reader = reader.copy \
                    :separators   => s.separators,
                    :segment_dict => s.segment_dict
                elsif not reader.segment_dict.eql?(s.segment_dict)
                  reader = reader.copy \
                    :separators   => s.separators,
                    :segment_dict => s.segment_dict
                end
              end
            end

            states.push([s, t])
          end
        end

        @errors = errors
        @states = states
        
        return self, reader
      end

      def read!(reader)
        remainder = Either.success(reader)

        while not stuck? and remainder.defined?
          remainder = remainder.flatmap{|x| x.read_segment }.map do |result|
            # result.value: SegmentTok
            # result.remainder: TokenReader
            _, reader = input!(result.value, result.remainder)

            reader
          end
        end

        # return
      end

    end

  end
end
