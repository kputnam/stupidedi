module Stupidedi
  module Reader
    
    class RepeatedElementTok

      # @return [Array<CompositeElementTok>]
      # @return [Array<SimpleElementTok>]
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def repeat(element)
        @value.unshift(element)
        self
      end

      def pretty_print(q)
        q.pp(:repeated.cons(@value))
      end

      def repeated?
        true
      end

      def blank?
        false
      end
    end

  end
end
