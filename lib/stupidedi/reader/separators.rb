module Stupidedi
  module Reader

    class Separators
      attr_accessor :component  # :
      attr_accessor :repetition # ^
      attr_accessor :element    # *
      attr_accessor :segment    # ~

      def initialize(component, repetition, element, segment)
        @component, @repetition, @element, @segment =
          component, repetition, element, segment
      end

      # @return [Separators]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:component, @component),
          changes.fetch(:repetition, @repetition),
          changes.fetch(:element, @element),
          changes.fetch(:segment, @segment)
      end

      def merge(other)
        copy \
          :component  => other.component  || @component,
          :repetition => other.repetition || @repetition,
          :element    => other.element    || @element,
          :segment    => other.segment    || @segment
      end

      def inspect
        "Separators(#{@component.inspect}, #{@repetition.inspect}, #{@element.inspect}, #{@segment.inspect})"
      end
    end

    class << Separators
      def empty
        Separators.new(nil, nil, nil, nil)
      end
    end

  end
end
