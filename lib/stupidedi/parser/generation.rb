# frozen_string_literal: true
module Stupidedi
  using Refinements

  # TODO: Rename this
  #
  module Parser
    module Generation
      # Consumes all input from `reader` and returns the updated
      # {StateMachine} along with the result of the last attempt
      # to read a segment.
      #
      # @param  tokenizer [Tokens::Tokenizer]
      # @param  options
      #
      # @yield  [Tokens::IgnoredTok]
      # @return [(StateMachine, Tokens::Tokenizer::Result)]
      def read(tokenizer, options = {})
        #imit   = options.fetch(:nondeterminism, 1)
        machine = self.dup

        return machine, tokenizer.each do |token|
          case token
          when Tokens::SegmentTok
            machine.insert!(token, false, tokenizer)
          when Tokens::IgnoredTok
            yield token if block_given?
          end
        end
      end

      # NOTE: This may destructively update the `state` by reassigning its
      # `segment_dict` or `separators` attributes.
      #
      # @return [StateMachine]
      def insert(segment_tok, strict, tokenizer)
        StateMachine.new(@config, insert_(segment_tok, strict, tokenizer))
      end

      # @return self
      def insert!(segment_tok, strict, tokenizer)
        @active = insert_(segment_tok, strict, tokenizer)
        self
      end

    private

      # NOTE: This may destructively update the `state` by reassigning its
      # `segment_dict` or `separators` attributes.
      #
      # @return [Array<Zipper::AbstractCursor<StateMachine::AbstractState>>]
      def insert_(segment_tok, strict, tokenizer)
        @active.flat_map do |zipper|
          state        = zipper.node
          instructions = state.instructions.matches(segment_tok, strict, :insert)

          if instructions.empty?
            zipper.append(FailureState.mksegment(segment_tok, state)).cons
          else
            instructions.map do |op|
              successor = execute(op, zipper, tokenizer, segment_tok)

              # We might be moving up or down past the interchange or functional
              # group envelope, which determine the separators and segment_dict
              unless op.push.nil? and (op.pop_count.zero? or tokenizer.separators.blank?)
                tokenizer.separators   = successor.node.separators
                tokenizer.segment_dict = successor.node.segment_dict
              end

              successor
            end
          end
        end
      end

    public

      # Three things change together when executing an {Instruction}:
      #
      # 1. The stack of instruction tables that indicates where a segment
      #    would be located if it existed, or was added to the parse tree
      #
      # 2. The parse tree, to which we add the new syntax nodes using a
      #    zipper.
      #
      # 3. The corresponding tree of states, which tie together the first
      #    two and are also updated using a zipper
      #
      # @return [AbstractCursor<StateMachine>]
      def execute(op, zipper, tokenizer, segment_tok)
        table = zipper.node.instructions  # 1.
        value = zipper.node.zipper        # 2.
        state = zipper                    # 3.

        op.pop_count.times do
          value = value.up
          state = state.up
        end

        if op.push.nil?
          # This instruction doesn't create a child node in the parse tree,
          # but it might move us forward to a sibling or upward to an uncle
          segment = AbstractState.mksegment(segment_tok, op.segment_use)
          value   = value.append(segment)

          # If we're moving upward, pop off the current table(s). If we're
          # moving forward, shift off the previous instructions. Important
          # that these are done in order.
          instructions = table.pop(op.pop_count).drop(op.drop_count)

          # Create a new AbstractState node that has a new InstructionTable
          # and also points to a new AbstractVal tree (with the new segment)
          state.append(state.node.copy(
            :zipper       => value,
            :instructions => instructions))
        else
          # Make a new sibling or uncle that will be the parent to the child
          parent = state.node.copy \
            :zipper       => value,
            :children     => [],
            :separators   => tokenizer.try{|x| x.separators },
            :segment_dict => tokenizer.try{|x| x.segment_dict },
            :instructions => table.pop(op.pop_count).drop(op.drop_count)

          # Note, `state` is a cursor pointing at a state, while `parent`
          # is an actual state
          state = state.append(parent) unless state.root?

          # Note, op.push == TableState; op.push.push == TableState.push
          op.push.push(state, parent, segment_tok, op.segment_use, @config)
        end
      end

    end
  end
end
