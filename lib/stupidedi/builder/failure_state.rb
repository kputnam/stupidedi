module Stupidedi
  module Builder

    class FailureState < AbstractState

      # @return [String]
      attr_reader :explanation

      # @return [AbstractState]
      attr_reader :predecessor

      def initialize(explanation, predecessor)
        @explanation, @predecessor = explanation, predecessor
      end

      def stuck?
        true
      end

      # @return [Array<self>]
      def segment(name, elements)
        self.cons
      end

      # @private
      def pretty_print(q)
        q.text("FailureState")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @explanation
        end
      end
    end
  
  end
end
