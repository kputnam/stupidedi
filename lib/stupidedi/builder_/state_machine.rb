module Stupidedi
  module Builder

    class StateMachine
      include Inspect

      # @return [Array<AbstractState>]
      attr_reader :states

      # @return [Array<FailureState>]
      attr_reader :errors

      def initialize(states, errors)
        @states, @errors = states, errors
      end

      # @return [Reader::TokenReader]
      def input!(segment_tok, reader)
        states = []
        errors = []

        @states.each do |state|
          instructions = state.instructions.matches(segment_tok)

          # No matching instructions means that this parse tree hit a dead end
          # and cannot accept this token. Keep in mind there may be another
          # state in @states that can accept this token.
          if instructions.empty?
            m = "Unexpected segment #{segment_tok.id}"
            errors << FailureState.new(m, segment_tok, state)
            next
          end

          instructions.each do |i|
            if i.push.nil?
              state = state.
                pop(i.pop_count).
                drop(i.drop_count).
                add(segment_tok, i.segment_use)

              states << state

              unless i.pop_count.zero? or reader.stream?
                # More general than checking if segment_tok is an ISE/GE segment
                if not reader.separators.eql?(state.separators)
                  reader = reader.copy \
                    :separators   => state.separators,
                    :segment_dict => state.segment_dict
                elsif not reader.segment_dict.eql?(state.segment_dict)
                  reader = reader.copy \
                    :separators   => state.separators,
                    :segment_dict => state.segment_dict
                end
              end
            else
              state = state.
                pop(i.pop_count).
                drop(i.drop_count)

              # Note Instruction#push returns a subclass of AbstractState,
              # which has a concrete constructor method named "push", that
              # links the new instance to the parent {state}
              state = i.push.push(segment_tok, i.segment_use, state, reader)

              if state.failure?
                errors << state
              else
                states << state
              end

              # More general than checking if segment_tok is an ISA/GS segment
              if not reader.separators.eql?(state.separators)
                reader = reader.copy \
                  :separators   => state.separators,
                  :segment_dict => state.segment_dict
              elsif not reader.segment_dict.eql?(state.segment_dict)
                reader = reader.copy \
                  :separators   => state.separators,
                  :segment_dict => state.segment_dict
              end
            end
          end
        end

      # puts "#{segment_tok.id}: #{states.length}"

        @errors.concat(errors)
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

        # This block of code is used to profile the tokenizer
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

      # True if the state machine cannot recover from failing to parse a token
      def stuck?
        @states.empty?
      end

      # @return [void]
      def pretty_print(q)
        q.text "StateMachine"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @errors
          q.text ","
          q.breakable
          q.pp @states
        end
      end

      # @return [Zipper::AbstractCursor]
      def zipper
        if @states.length == 1
          @states.head.zipper
        end
      end

      # @return [StateMachine]
      def root
        states = []
        @states.each do |state|
          state = state.pop(state.depth)
          states << state
        end

        StateMachine.new(states, @errors)
      end
    end

    class << StateMachine
      # @group Constructors
      #########################################################################

      # @return [StateMachine]
      def build(config)
        StateMachine.new(TransmissionState.build(config).cons, [])
      end

      # @endgroup
      #########################################################################
    end

  end
end
