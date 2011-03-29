module Stupidedi
  module Reader

    class ComponentElementTok
      include Inspect

      # @return [String]
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
        q.pp(:component.cons(@value.cons))
      end

      def blank?
        @value.blank?
      end

      def simple?
        true
      end
    end

    class << ComponentElementTok
      # @group Constructors
      #########################################################################

      # @return [ComponentElementTok]
      def build(value, start, remainder)
        new(value, start, remainder)
      end

      # @endgroup
      #########################################################################
    end

  end
end
