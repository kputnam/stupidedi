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

          # No matching instructions indicates this token cannot legally belong
          # to any part of this state's parse tree according to the grammar. If
          # there are more @states, the token might be valid in those states.
          if instructions.empty?
            errors.push(segment_tok)
            next
          end

          # 
          if instructions.length > 1
            deepest = 0
            buffer  = []

            instructions.each do |i|
              if i.pop_count == deepest
                buffer << i
              elsif i.pop_count < deepest
                deepest = i.pop_count
                buffer.clear
                buffer << i
              end
            end

            instructions = buffer
          end

          instructions.each do |i|
            if i.push.nil?
              s = state.pop(i.pop_count).add(segment_tok, i.segment_use)
              t = table.pop(i.pop_count).drop(i.drop_count)

              unless i.pop_count.zero? or reader.nil?
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
              # Note: Instruction#push returns a concrete subclass of
              # AbstractState, which has a constructor method named {push}, that
              # links the new instance to the parent {state}
              a = i.push

              # @todo: Check for FailureState
              s = a.push(segment_tok, i.segment_use, state.pop(i.pop_count), reader)
              t = table.pop(i.pop_count).drop(i.drop_count)

              directive = s.instructions
              if directive.is_a?(InstructionTable)
                t = t.concat(directive)
              else
                t = t.push(directive)
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

        # @todo: return
      end

    end

  end
end
