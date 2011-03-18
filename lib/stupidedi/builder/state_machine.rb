module Stupidedi
  module Builder

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

      # puts "#{segment_tok.id}: #{states.length}"

        @errors = errors
        @states = states

        return reader
      end

      # @return [Reader::TokenReader]
      def read!(reader)
        remainder = Either.success(reader)

        while not stuck? and remainder.defined?
          remainder = remainder.flatmap{|x| x.read_segment }.map do |result|
            # result.value: SegmentTok
            # result.remainder: TokenReader
            input!(result.value, result.remainder)
          end

        # remainder = remainder.flatmap do |x|
        #   RubyProf.resume
        #   y = x.read_segment
        #   RubyProf.pause
        #   y
        # end.map do |result|
        #   # result.value: SegmentTok
        #   # result.remainder: TokenReader
        #   input!(result.value, result.remainder)
        # end
        end

        return remainder
      end

      def stuck?
        @states.empty?
      end
    end

    class << StateMachine
      #########################################################################
      # @group Constructor Methods

      # @return [StateMachine]
      def build(config)
        separators   = Reader::Separators.empty
        segment_dict = Reader::SegmentDict.empty

        state = TransmissionState.new(config, separators, segment_dict)

        StateMachine.new(state.cons, [])
      end

      # @endgroup
      #########################################################################
    end

  end
end
