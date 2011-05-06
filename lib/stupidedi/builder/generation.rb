module Stupidedi
  module Builder

    module Generation

      # @return [(StateMachine, Either<Reader::TokenReader>)]
      def read(reader)
        machine   = self
        remainder = Either.success(reader)

        while remainder.defined?
          remainder = remainder.flatmap{|x| x.read_segment }.map do |result|
            segment_tok = result.value
            reader      = result.remainder

            machine, reader =
              machine.insert(segment_tok, reader)

            reader
          end
        end

        return machine, remainder
      end

      # @return [(StateMachine, Reader::TokenReader)]
      def insert(segment_tok, reader)
        active = []

        @active.each do |zipper|
          state        = zipper.node
          instructions = state.instructions.matches(segment_tok)

          if instructions.empty?
            active << zipper.append(FailureState.segment(segment_tok, state))
            next
          end

          instructions.each do |op|
            if op.push.nil?
              table = zipper.node.instructions
              value = zipper.node.zipper
              state = zipper

              op.pop_count.times do
                value = value.up
                state = state.up
              end

              # Create a new AbstractState node that has a new InstructionTable
              # and also points to a new AbstractVal tree (with the new segment)
              segment   = AbstractState.mksegment(segment_tok, op.segment_use)
              successor = state.append(state.node.copy(
                :zipper       => value.append(segment),
                :instructions => table.pop(op.pop_count).drop(op.drop_count)))

              unless op.pop_count.zero? or reader.stream?
                # More general than checking if segment_tok is an ISE/GE segment
                unless reader.separators.eql?(successor.node.separators) \
                  and reader.segment_dict.eql?(successor.node.segment_dict)
                  reader = reader.copy \
                    :separators   => successor.node.separators,
                    :segment_dict => successor.node.segment_dict
                end
              end
            else
              table = zipper.node.instructions
              value = zipper.node.zipper
              state = zipper

              op.pop_count.times do
                value = value.up
                state = state.up
              end

              parent = state.node.copy \
                :zipper       => value,
                :children     => [],
                :separators   => reader.separators,
                :segment_dict => reader.segment_dict,
                :instructions => table.pop(op.pop_count).drop(op.drop_count)

              state = state.append(parent) unless state.root?

              successor = op.push.push(state, parent, segment_tok, op.segment_use, @config)

              # More general than checking if segment_tok is an ISA/GS segment
              unless reader.separators.eql?(successor.node.separators) \
                and reader.segment_dict.eql?(successor.node.segment_dict)
                reader = reader.copy \
                  :separators   => successor.node.separators,
                  :segment_dict => successor.node.segment_dict
              end
            end

            active << successor
          end
        end

        return StateMachine.new(@config, active), reader
      end

      # @return [StateMachine]
      def replace(segment_tok, reader)
        # @todo
      end

      # @return [StateMachine]
      def remove
        # @todo
      end

    end
  end
end
