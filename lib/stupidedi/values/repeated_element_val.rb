module Stupidedi
  module Values

    #
    # Represents multiple occurences of an element. If a segment definition
    # allows an element to repeat, its parsed into this structure, even if
    # there's only a single occurrence. This is essentialy a homogenous list of
    # element values that have the same definition.
    #
    class RepeatedElementVal
      attr_reader :element_def

      attr_reader :element_vals

      def initialize(element_vals, element_def)
        @element_vals, @element_def = element_vals, element_def
      end

      def count
        @element_vals.length
      end

      def length
        @element_vals.length
      end

      # Returns the occurence at the given index. Numbering begins at zero.
      def [](n)
        @element_vals[n]
      end

      # True if there are no occurences (or every occurence is empty)
      def empty?
        @element_vals.all?(&:empty?)
      end

      # True if any occurences are present
      def present?
        @element_vals.any?(&:present?)
      end

      # Creates a new {RepeatedElementVal} with the given element appended
      # to the end of the list of occurences
      #
      # @note Intended for use by {SegmentReader}
      # @private
      def append(element)
        self.class.new(@element_vals + [element], element_def)
      end

      # Creates a new {RepeatedElementVal} with the given element prepended to
      # the end of the list of occurences
      #
      # @note Intended for use by {SegmentReader}
      # @private
      def prepend(element)
        self.class.new(element.cons(@element_vals), element_def)
      end

      # @private
      def ==(other)
        other.element_vals == @element_vals
      end

      # @private
      def pretty_print(q)
        q.text("RepeatedElementVal[#{element_def.try(:id)}]")
        q.group(1, "(", ")") do
          q.breakable ""
          @element_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

  end
end
