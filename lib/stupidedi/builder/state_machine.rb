module Stupidedi
  module Builder

    class StateMachine
      include Inspect

      # @return [Config::RootConfig]
      attr_reader :config

      # @return [Array<Zipper::AbstractCursor>]
      attr_reader :active

      def initialize(config, active)
        @config, @active = config, active
      end

      # @return [Reader::TokenReader]
      def input!(segment_tok, reader)
        active = []

        @active.each do |zipper|
          state        = zipper.node
          instructions = state.instructions.matches(segment_tok)

          if instructions.empty?
            if state.leaf?
              segment_val = Values::InvalidSegmentVal.new \
                "Unexpected segment", segment_tok

              active << zipper.append(
                FailureState.new(
                  false,
                  state.separators,
                  state.segment_dict,
                  state.instructions,
                  state.zipper.append(segment_val)))
            else
              active << zipper
            end

            next
          end

          instructions.each do |op|
            if op.push.nil?
              # There are two trees being edited in parallel. The first tree
              # has AbstractState nodes, and the second tree has AbstractVal
              # nodes.
              i = zipper.node.instructions
              t = zipper.node.zipper
              z = zipper

              op.pop_count.times do
                t = t.up
                z = z.up
                z = z.replace(z.node.copy(:zipper => t))
              end

              # Create a new AbstractState node that has a new InstructionTable
              # and also points to a new AbstractVal tree (with the new segment)
              segment = AbstractState.mksegment(segment_tok, op.segment_use)
              state   = z.node.copy \
                :zipper       => t.append(segment),
                :instructions => i.pop(op.pop_count).drop(op.drop_count)

              active   << z.append(state)
              successor = active.last.node

              unless op.pop_count.zero? or reader.stream?
                # More general than checking if segment_tok is an ISE/GE segment
                unless reader.separators.eql?(successor.separators) \
                  and reader.segment_dict.eql?(successor.segment_dict)
                  reader = reader.copy \
                    :separators   => successor.separators,
                    :segment_dict => successor.segment_dict
                end
              end
            else
              # There are two trees being edited in parallel. The first tree
              # has AbstractState nodes, and the second tree has AbstractVal
              # nodes.
              i = zipper.node.instructions
              t = zipper.node.zipper
              z = zipper

              op.pop_count.times do
                t = t.up
                z = z.up
                z = z.replace(z.node.copy(:zipper => t))
              end

              # Create a new AbstractState node that has a new InstructionTable
              # and also points to the AbstractVal tree constructed by children
              # states (whose ancestor is z).
              parent = z.node.copy \
                :zipper       => t,
                :separators   => reader.separators,
                :segment_dict => reader.segment_dict,
                :instructions => i.pop(op.pop_count).drop(op.drop_count)

              active   << op.push.push(z, parent, segment_tok, op.segment_use, @config)
              successor = active.last.node

              # More general than checking if segment_tok is an ISA/GS segment
              unless reader.separators.eql?(successor.separators) \
                and reader.segment_dict.eql?(successor.segment_dict)
                reader = reader.copy \
                  :separators   => successor.separators,
                  :segment_dict => successor.segment_dict
              end
            end
          end
        end

        # puts "#{segment_tok.id}: #{active.length}"
        @active = active

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
        false
      end

      def successors
        @active.map{|a| a.node.instructions }
      end

      # @return [void]
      def pretty_print(q)
        q.text "StateMachine"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @active.map(&:node)
        end
      end

      # @return [Zipper::AbstractCursor]
      def zipper
        if @active.length == 1
          @active.head.node.zipper
        end
      end

      # @return [StateMachine]
      def root
        active = []

        @active.each do |zipper|
          z = zipper
          t = zipper.node.zipper

          zipper.depth.times do
            t = t.up
            z = z.up
            z = z.replace(z.node.copy(:zipper => t))
          end

          active << z
        end

        StateMachine.new(@config, active)
      end
    end

    class << StateMachine
      # @group Constructors
      #########################################################################

      # @return [StateMachine]
      def build(config)
        StateMachine.new(config, Zipper.build(TransmissionState.build).cons)
      end

      # @endgroup
      #########################################################################
    end

  end
end
