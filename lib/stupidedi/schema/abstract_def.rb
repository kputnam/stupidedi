module Stupidedi
  module Schema

    class AbstractDef

      def usage?
        false
      end

      def definition?
        true
      end

      #
      #########################################################################

      # Is this an {InterchangeDef}?
      def interchange?
        false
      end

      # Is this an {FunctionalGroupDef}?
      def functional_group?
        false
      end

      # Is this an {TransactionSetDef}?
      def transaction_set?
        false
      end

      # Is this a {TableDef}?
      def table?
        false
      end

      # Is this a {LoopDef}?
      def loop?
        false
      end

      # Is this a {SegmentDef}?
      def segment?
        false
      end

      # Is this a {AbstractElementDef}?
      def element?
        false
      end

      # Is this a {CompositeElementDef}?
      def composite?
        false
      end

      # Is this a component {SimpleElementDef}?
      def component?
        false
      end

      # Is this a {RepeatedElementDef}?
      def repeated?
        false
      end

      # Is this a non-component {SimpleElementDef}?
      def simple?
        false
      end
    end

  end
end
