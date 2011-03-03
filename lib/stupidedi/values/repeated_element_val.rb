module Stupidedi
  module Values

    # @see X222 B.1.1.3.2 Repeating Data Elements
    class RepeatedElementVal < AbstractVal
      attr_reader :element_def
      alias_method :definition, :element_def

      attr_reader :element_vals

      def initialize(element_vals, element_def)
        @element_vals, @element_def = element_vals, element_def
      end

      def length
        @element_vals.length
      end

      # Returns the occurence at the given index. Numbering begins at zero.
      def [](n)
        @element_vals[n]
      end

      def empty?
        @element_vals.all?(&:empty?)
      end

      # True if any occurences are present
      def present?
        not empty?
      end

      # @private
      def ==(other)
        other.element_def == @element_def and
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

      # Creates a new {RepeatedElementVal} with the given element value
      # appended to the end of the list of occurences
      #
      # @note Intended for use by {SegmentReader}
      # @private
      def append(element_val)
        self.class.new(element_val.snoc(@element_vals), element_def)
      end

      # Creates a new {RepeatedElementVal} with the given element value
      # prepended to the end of the list of occurences
      #
      # @note Intended for use by {SegmentReader}
      # @private
      def prepend(element_val)
        self.class.new(element_val.cons(@element_vals), element_def)
      end
    end

  end
end
