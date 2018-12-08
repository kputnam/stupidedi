# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Builder

    module Generation

      # Consumes all input from `reader` and returns the updated
      # {StateMachine} along with the result of the last attempt
      # to read a segment.
      #
      # The `nondeterminism` argument specifies a limit on how many
      # parse trees can be built simultaneously due to ambiguity in
      # the input and/or specification. This prevents runaway memory
      # CPU consumption (see GH-129), and will return a {Result.failure}
      # once exceeded.
      #
      # The default value is 1, resulting in an error if any input
      # is ambiguous.
      #
      # NOTE: The error is detected *after* the resources are already
      # been consumed. The extra parse trees are returned (in memory)
      # via the {StateMachine} to aide diagnosis.
      #
      # @return [(StateMachine, Reader::Result)]
      def read(reader, options = {})
        limit    = options.fetch(:nondeterminism, 1)
        machine  = self
        reader_e = reader.read_segment

        while reader_e.defined?
          reader_e = reader_e.flatmap do |segment_tok, reader|
            machine, reader_ =
              machine.insert(segment_tok, reader)

            if machine.active.length <= limit
              reader_.read_segment
            else
              matches = machine.active.map do |m|
                segment_def = m.node.zipper.node.definition
                "#{segment_def.id} #{segment_def.name}"
              end.join(", ")

              return machine,
                Reader::Result.failure("too much non-determinism: #{matches}", reader_.input, true)
            end
          end
        end

        return machine, reader_e
      end

      # @return [(StateMachine, Reader::TokenReader)]
      def insert(segment_tok, reader)
        active = []

        @active.each do |zipper|
          state        = zipper.node
          instructions = state.instructions.matches(segment_tok)

          if instructions.empty?
            active << zipper.append(FailureState.mksegment(segment_tok, state))
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
