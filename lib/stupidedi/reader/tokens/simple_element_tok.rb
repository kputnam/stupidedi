module Stupidedi
  module Reader

    class SimpleElementTok
      include Inspect

      # @return [String, Object]
      attr_reader :value

      # @return [Position]
      attr_reader :start

      # @return [Position]
      attr_reader :remainder

      def initialize(value, start, remainder)
        @value, @start, @remainder =
          value, start, remainder
      end

      def pretty_print(q)
        q.pp(:simple.cons(@value.cons))
      end

      def repeat(element)
        RepeatedElementTok.new([element, self])
      end

      def repeated?
        false
      end

      def blank?
        @value.blank?
      end

      def simple?
        true
      end
    end

    class << SimpleElementTok
      # @group Constructor Methods
      #########################################################################

      def build(value, start, remainder)
        new(value, start, remainder)
      end

      # @endgroup
      #########################################################################
    end

  end
end
