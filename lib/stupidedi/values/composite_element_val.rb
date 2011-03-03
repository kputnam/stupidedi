module Stupidedi
  module Values

    # @see X222 B.1.1.3.3 Composite Data Structure
    class CompositeElementVal < AbstractVal
      attr_reader :element_def
      alias_method :definition, :element_def

      attr_reader :component_element_vals

      def initialize(element_def, component_element_vals)
        @element_def, @component_element_vals =
          element_def, component_element_vals

      # Type check disabled as an optimization, no "client code" is expected to
      # directly construct CompositeElementVal values anyways.
      #
      # unless element_def.is_a?(Definitions::CompositeElementDef)
      #   raise TypeError,
      #     "First argument must be a kind of CompositeElementDef"
      # end
      end

      # True if all component elements are empty
      def empty?
        @component_element_vals.all?(&:empty?)
      end

      # Returns the component element value (some kind of {SimpleElementVal}) at
      # the given index +n+, with numbering starting at zero
      def [](n)
        @component_element_vals[n]
      end

      # @private
      def ==(other)
        other.definition == @element_def and
        other.component_element_vals == @component_element_vals
      end

      # @private
      def pretty_print(q)
        q.text("CompositeElementVal[#{element_def.try(:id)}]")
        q.group(1, "(", ")") do
          q.breakable ""
          @component_element_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @private
      def append(element_val)
        self.class.new(element_def, element_val.snoc(@component_element_vals))
      end

      # @private
      def prepend(element_val)
        self.class.new(element_def, element_val.cons(@component_element_vals))
      end

      # @private
      def repeated
        RepeatedElementVal.new([self], element_def)
      end
    end

  end
end
