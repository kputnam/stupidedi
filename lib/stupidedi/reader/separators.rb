module Stupidedi
  module Reader

    #
    # Stores the separators used to tokenize X12 from an input stream and
    # serialize it to an output stream.
    #
    # @see X222.pdf B.1.1.2.5 Delimiters
    #
    class Separators

      # @return [String]
      attr_accessor :component  # :

      # @return [String]
      attr_accessor :repetition # ^

      # @return [String]
      attr_accessor :element    # *

      # @return [String]
      attr_accessor :segment    # ~

      def initialize(component, repetition, element, segment)
        @component, @repetition, @element, @segment =
          component, repetition, element, segment
      end

      # @return [Separators]
      def copy(changes = {})
        Separators.new \
          changes.fetch(:component, @component),
          changes.fetch(:repetition, @repetition),
          changes.fetch(:element, @element),
          changes.fetch(:segment, @segment)
      end

      # Creates a new value that has the separators from `other`, when they
      # are not nil, and will use separators from `self` otherwise.
      def merge(other)
        Separators.new \
          other.component  || @component,
          other.repetition || @repetition,
          other.element    || @element,
          other.segment    || @segment
      end

      # @return [AbstractSet<String>]
      def characters
        chars =
          [@component, @repetition, @element, @segment].select(&:present?)

        Sets.absolute(chars.join.split(//), Reader::C_BYTES.split(//))
      end

      # @return [String]
      def inspect
        "Separators(#{@component.inspect}, #{@repetition.inspect}, #{@element.inspect}, #{@segment.inspect})"
      end
    end

    class << Separators
      # @group Constructors
      #########################################################################

      # @return [Separators]
      def empty
        new(nil, nil, nil, nil)
      end

      # @return [Separators]
      def build(hash)
        Separators.new \
          hash[:component],
          hash[:repetition],
          hash[:element],
          hash[:segment]
      end

      # @endgroup
      #########################################################################
    end

  end
end
