module Stupidedi
  module Values

    #
    # Represents an occurence of a composite element. Composite elements are
    # somewhat analagous to "struct" values in C -- except their members must
    # be native types (ie SimpleElementVal), so they cannot be nested
    # recursively. The composite definition (CompositeElementDef) dictates the
    # specific types of each component element.
    #
    class CompositeElementVal
      attr_reader :element_def

      attr_reader :component_element_vals

      def initialize(element_def, component_element_vals)
        @element_def, @component_element_vals =
          element_def, component_element_vals

      # Type check disabled as an optimization, no "client code" is expected to
      # directly construct CompositeElementVal values anyways.
      #
      # unless element_def.is_a?(CompositeElementDef)
      #   raise TypeError,
      #     "First argument must be a kind of CompositeElementDef"
      # end
      end

      # True if all component elements are empty
      def empty?
        @component_element_vals.all?(&:empty?)
      end

      # True if at least one of the component elements is present.
      def present?
        @component_element_vals.any?(&:present?)
      end

      def length
        @component_element_vals.length
      end

      # Returns the component element value (some kind of {SimpleElementVal}) at
      # the given index +n+, with numbering starting at zero
      def [](n)
        @component_element_vals[n]
      end

      # Create a new CompositeElementVal with the given component appended to
      # the list of component elements
      #
      # @note Intended for use by {CompositeElementReader}
      # @private
      def append(component)
        self.class.new(element_def, @component_element_vals + [component])
      end

      # Create a new CompositeElementVal with the given component prepended to
      # the list of component elements.
      #
      # @note Intended for use by {CompositeElementReader}
      # @private
      def prepend(component)
        self.class.new(element_def, component.cons(@component_element_vals))
      end

      # Construct a RepeatedElementVal with this element as its sole element.
      # @note Intended for use by SegmentReader
      # @private
      def repeated
        RepeatedElementVal.new([self], element_def)
      end

      # @private
      def ==(other)
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
    end

  end
end
