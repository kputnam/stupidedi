module Stupidedi
  module Builder

    class FailureState < AbstractState

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [String]
      attr_reader :explanation

      # @return [SegmentTok]
      attr_reader :segment_tok

      def initialize(explanation, segment_tok, separators, segment_dict, zipper)
        @separators, @segment, @explanation, @segment_tok, @zipper =
          separators, segment_dict, explanation, segment_tok, zipper
      end

      def leaf?
        true
      end

      # @return [InstructionTable]
      def instructions
        InstructionTable.empty
      end

      # @return [void]
      def pretty_print(q)
        q.text("FailureState")
        q.group(2, "(", ")") do
          q.breakable ""

          q.pp @explanation
          q.text ","
          q.breakable

          q.pp @segment_tok
          q.text ","
          q.breakable

          q.pp @zipper.node
        end
      end
    end

  end
end
