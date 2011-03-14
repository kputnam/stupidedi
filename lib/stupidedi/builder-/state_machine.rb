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
          instructions = state.instructions.successors(segment_tok)

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
            deepest = 1.0 / 0.0 # Infinity
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
              s = state.
                pop(i.pop_count).
                drop(i.drop_count).
                add(segment_tok, i.segment_use)

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
              s = state.
                pop(i.pop_count).
                drop(i.drop_count)

              # Note Instruction#push returns a subclass of AbstractState,
              # which has a concrete constructor method named "push", that
              # links the new instance to the parent {state}
              s = i.push.push(segment_tok, i.segment_use, s, reader)

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

            states << s
          end
        end

        puts "#{segment_tok.id}: #{states.length}"

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
        separators   = Reader::Separators.empty
        segment_dict = Reader::SegmentDict.empty

        state = TransmissionState.new(config, separators, segment_dict)

        StateMachine.new(state.cons, [])
      end
    end

  end
end
