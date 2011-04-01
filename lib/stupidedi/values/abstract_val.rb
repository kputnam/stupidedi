module Stupidedi
  module Values

    class AbstractVal
      include Inspect
      include Color

      # @return [SimpleElementDef, CompositeElementDef, LoopDef, SegmentDef, TableDef]
      abstract :definition

      # @see X222.pdf B.1.3.10 Absence of Data
      abstract :empty?

      abstract :leaf?

      def present?
        not empty?
      end

      def blank?
        empty?
      end

      def transmission?
        false
      end

      def interchange?
        false
      end

      def functional_group?
        false
      end

      def transaction_set?
        false
      end

      def table?
        false
      end

      def loop?
        false
      end

      def segment?
        false
      end

      def element?
        false
      end

      def composite?
        false
      end

      def component?
        false
      end

      def repeated?
        false
      end
    end

  end
end
