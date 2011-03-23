module Stupidedi
  module Builder

    class InterchangeState < AbstractState

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [TransmissionState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      def initialize(zipper, parent, instructions, separators, segment_dict)
        @zipper, @parent, @instructions, @separators, @segment_dict =
          zipper, parent, instructions, separators, segment_dict
      end

      # @return [InterchangeState]
      def copy(changes = {})
        InterchangeState.new \
          changes.fetch(:zipper, @zipper),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict)
      end

      # @return [InterchangeState]
      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      # @return [InterchangeState]
      def add(segment_tok, segment_use)
        copy(:zipper => @zipper.append(segment(segment_tok, segment_use)))
      end
    end

    class << InterchangeState

      # @return [InterchangeState]
      def push(segment_tok, segment_use, parent, reader = nil)
        # ISA12: Interchange Control Version Number
        version = segment_tok.element_toks.at(11).try(:value)

        unless parent.config.interchange.defined_at?(version)
          return FailureState.new("Unknown interchange version #{version}",
            segment_tok, parent)
        end

        # Construct a SegmentVal and InterchangeVal around it
        envelope_def = parent.config.interchange.at(version)
        segment_use  = envelope_def.entry_segment_use
        segment_val  = segment(segment_tok, segment_use)
        envelope_val = envelope_def.empty

        zipper = parent.zipper.
          append(envelope_val).
          append_child(segment_val)

        InterchangeState.new(zipper, parent,
          parent.instructions.push(instructions(envelope_def)),
          reader.separators.merge(envelope_def.separators(segment_val)),
          reader.segment_dict.push(envelope_val.segment_dict))
      end

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
