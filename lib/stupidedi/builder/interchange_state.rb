module Stupidedi
  module Builder

    class InterchangeState < AbstractState

      # @return [Envelope::InterchangeVal]
      attr_reader :value
      alias interchange_val value

      # @return [TransmissionState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      def initialize(value, parent, instructions, separators, segment_dict)
        @value, @parent, @instructions, @separators, @segment_dict =
          value, parent, instructions, separators, segment_dict
      end

      def copy(changes = {})
        InterchangeState.new \
          changes.fetch(:value, @value),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict)
      end

      def pop(count)
        if count.zero?
          self
        else
          @parent.merge(@value).pop(count - 1)
        end
      end

      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      def add(segment_tok, segment_use)
        copy(:value => @value.append(segment(segment_tok, segment_use)))
      end

      def merge(child)
        copy(:value => @value.append(child))
      end
    end

    class << InterchangeState

      # @param [SegmentTok] segment_tok the interchange start segment
      # @param [SegmentUse] segment_use nil
      #
      # This will construct a state whose successors do not include the entry
      # segment defined by the InterchangeDef (which is typically ISA). This
      # means another occurence of that segment will pop this state and the
      # parent state will create a new InterchangeState.
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
        envelope_val = envelope_def.value(segment_val)

        InterchangeState.new(envelope_val, parent,
          parent.instructions.push(instructions(envelope_def)),
          envelope_val.separators.merge(reader.try(:separators)),
          reader.segment_dict.push(envelope_val.segment_dict))
      end

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
