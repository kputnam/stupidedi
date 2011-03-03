module Stupidedi
  module Builder

    class FailureState < AbstractState
      attr_reader :explanation

      def initialize(explanation)
        @explanation = explanation
      end

      def stuck?
        true
      end

      def segment(name, elements)
        self.cons
      end
    end
  
  end
end
