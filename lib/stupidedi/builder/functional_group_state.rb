module Stupidedi
  module Builder

    class FunctionalGroupState < AbstractState

      # @return [Envelope::FunctionalGroupVal]
      attr_reader :value
      alias functional_group_val value

      # @return [InterchangeState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      def initialize(value, parent, instructions, segment_dict)
        @value, @parent, @instructions, @segment_dict =
          value, parent, instructions, segment_dict
      end

      def copy(changes = {})
        FunctionalGroupState.new \
          changes.fetch(:value, @value),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions),
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

    class << FunctionalGroupState

      def push(segment_tok, segment_use, parent, reader = nil)
        # GS08: Version / Release / Industry Identifier Code
        version = segment_tok.element_toks.at(7).try{|t| t.value.slice(0, 6) }

        unless parent.config.functional_group.defined_at?(version)
          return FailureState.new("Unknown functional group version #{version}",
            segment_tok, parent)
        end

        envelope_def = parent.config.functional_group.at(version)
        segment_use  = envelope_def.entry_segment_use
        segment_val  = segment(segment_tok, segment_use)
        envelope_val = envelope_def.value(segment_val, parent.value)

        FunctionalGroupState.new(envelope_val, parent,
          parent.instructions.push(instructions(envelope_def)),
          parent.segment_dict.push(envelope_val.segment_dict))
      end

      # @return [Array<Instruction>]
      def instructions(functional_group_def)
        @__instructions ||= Hash.new
        @__instructions[functional_group_def] ||= begin
        # puts "FunctionalGroupState.instructions(#{functional_group_def.object_id})"
          is = sequence(functional_group_def.header_segment_uses.tail)
          is << Instruction.new(:ST, nil, 0, is.length, TransactionSetState)
          is.concat(sequence(functional_group_def.trailer_segment_uses, is.length))
        end
      end
    end

  end
end
