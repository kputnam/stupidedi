module Stupidedi
  module Builder

    class InterchangeState < AbstractState

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [Array<AbstractState>]
      attr_reader :children

      def initialize(separators, segment_dict, instructions, zipper, children)
        @separators, @segment_dict, @instructions, @zipper, @children =
          separators, segment_dict, instructions, zipper, children
      end

      # @return [InterchangeState]
      def copy(changes = {})
        InterchangeState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << InterchangeState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, segment_use, config)
        # ISA12: Interchange Control Version Number
        version = segment_tok.element_toks.at(11).try(:value)

        unless config.interchange.defined_at?(version)
          return FailureState.push(
            zipper,
            parent,
            segment_tok,
            "unknown interchange version #{version.inspect}")
        end

        # Construct a SegmentVal and InterchangeVal around it
        envelope_def = config.interchange.at(version)
        envelope_val = envelope_def.empty(parent.separators)
        segment_use  = envelope_def.entry_segment_use
        segment_val  = mksegment(segment_tok, segment_use)

        separators =
          parent.separators.merge(envelope_def.separators(segment_val))

        zipper.append_child new(
          separators,
          parent.segment_dict.push(envelope_val.segment_dict),
          parent.instructions.push(instructions(envelope_def)),
          parent.zipper.append(envelope_val).append_child(segment_val),
          [])
      end

      # @endgroup
      #########################################################################

    private

      # @return [Array<Instruction>]
      def instructions(interchange_def)
        @__instructions ||= Hash.new
        @__instructions[interchange_def] ||= begin
        # puts "InterchangeState.instructions(#{interchange_def.object_id})"
          is = if interchange_def.header_segment_uses.head.repeatable?
                 sequence(interchange_def.header_segment_uses)
               else
                 sequence(interchange_def.header_segment_uses.tail)
               end

          is << Instruction.new(:GS, nil, 0, is.length, FunctionalGroupState)
          is.concat(sequence(interchange_def.trailer_segment_uses, is.length))
        end
      end
    end

  end
end
