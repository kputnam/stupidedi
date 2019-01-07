# frozen_string_literal: true
module Stupidedi
  module Schema
    class AbstractUse
      def usage?
        true
      end

      def definition?
        true
      end

      #
      #########################################################################

      # Is this a {SegmentUse}?
      def segment?
        false
      end

      # Is this a {AbstractElementUse}?
      def element?
        false
      end

      # Is this a {CompositeElementUse}?
      def composite?
        false
      end

      # Is this a component {SimpleElementUse}?
      def component?
        false
      end

      # Is this a repeatable {AbstractUse}?
      def repeated?
        false
      end

      # Is this a non-component {SimpleElementUse}?
      def simple?
        false
      end

      # The definitions for these types, like InterchangeDef aren't reused, so
      # they don't have corresponding AbstractUse subclasses.
      #########################################################################

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
    end
  end
end
