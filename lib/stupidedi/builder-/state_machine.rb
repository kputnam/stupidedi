module Stupidedi
  module Builder_

    class StateMachine

      def initialize(states, errors)
        @states, @errors = states, errors
      end

      # @return [Reader::TokenReader]
      def input!(segment_tok, reader = nil)
        states = []
        errors = []

        @states.each do |state|
          state, table = state

          instructions = table.successors(segment_tok)

          # No matching instructions means that this parse tree hit a dead end
          # and cannot accept this token. Keep in mind there may be another
          # state in @states that can accept this token.
          if instructions.empty?
            errors.push(segment_tok)
            next
          end

          # Each matching instruction produces a unique parse tree containing
          # the new token; more than one instruction creates non-determinism,
          # but often the difference between instructions is how tightly the
          # segment binds to the current subtree.
          #
          # For instance, "HL*20" always indicates a new 2000B loop. However,
          # if the parse tree is currently already within "Table 2 - Provider",
          # we could either place the 2000B loop within the current table or we
          # could create a new occurence of "Table 2 - Provider" as the parent
          # of the 2000B loop.
          #
          # This block of code dicards all instructions except those that most
          # tightly bind the segment. Note that without performing this filter,
          # we would end up with parse trees that accept exactly the same set
          # of tokens -- meaning the trees will never converge.
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

              # @todo: Combine AbstractState + InstructionTable
              # s = state.pop(i.pop_count).forward(i.drop_count, segment_tok, i.segment_use)

              unless reader.nil? or i.pop_count.zero?
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
              # Note Instruction#push returns a subclass of AbstractState,
              # which has a concrete constructor method named "push", that
              # links the new instance to the parent {state}
              a = i.push

              # @todo: Check for FailureState
              s = a.push(segment_tok, i.segment_use, state.pop(i.pop_count), reader)
              t = table.pop(i.pop_count).drop(i.drop_count)

              directive = s.instructions

              if directive.is_a?(InstructionTable)
                # Normally AbstractState#instructions returns Array<Instruction>
                # which is a single layer of instructions that get pushed onto
                # the table... (note Object#is_a? returned nearly twice as fast
                # when returning false than when returning true in micro-
                # benchmarks performed on Ruby 1.8.7)
                t = t.concat(directive)
              else
                # ... however sometimes we've pushed more than one state (when
                # the intermediate states don't consume the segment), so we need
                # to push more than one layer of instructions.
                t = t.push(directive)
              end

              # @todo: Combine AbstractState + InstructionTable
              # s = i.push.push(segment_tok, i.segment_use,
              #                 state.pop(i.pop_count).forward(i.drop_count),
              #                 reader)

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
        
        return reader
      end

      def read!(reader)
        remainder = Either.success(reader)

        while not stuck? and remainder.defined?
          remainder = remainder.flatmap{|x| x.read_segment }.map do |result|
            # result.value: SegmentTok
            # result.remainder: TokenReader
            input!(result.value, result.remainder)
          end
        end

        return remainder
      end

      def stuck?
        @states.empty?
      end

    end

    class << StateMachine
      def build(config)
        separators   = OpenStruct.new(:element => nil, :segment => nil, :component => nil, :repetition => nil)
        segment_dict = Schema::SegmentDict.empty

        state = TransmissionState.new(config, separators, segment_dict)
        table = InstructionTable.build(state.instructions)

        StateMachine.new([[state, table]], [])
      end
    end

  end
end
