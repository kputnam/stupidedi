module Stupidedi
  module Builder

    class FailureState < AbstractState

      # @return [String]
      attr_reader :explanation

      # @return [AbstractState]
      attr_reader :predecessor

      # @return [SegmentTok]
      attr_reader :segment_tok

      def initialize(explanation, segment_tok, predecessor)
        @explanation, @segment_tok, @predecessor =
          explanation, segment_tok, predecessor
      end

      def stuck?
        true
      end

      # @private
      def pretty_print(q)
        q.text("FailureState")
        q.group(2, "(", ")") do
          q.breakable ""

          q.pp @explanation
          q.text ","
          q.breakable

          q.pp @segment_tok
        end
      end
    end
  
  end
end
