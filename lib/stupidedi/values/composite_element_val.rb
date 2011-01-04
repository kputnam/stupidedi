module Stupidedi
  module Values

    class CompositeElementVal
      attr_reader :element_def, :component_element_vals

      def initialize(element_def, component_element_vals)
        @element_def, @component_element_vals = element_def, component_element_vals
      end

      def empty?
        @component_element_vals.all?{|e| e.empty? }
      end

      def length
        @component_element_vals.length
      end

      def [](n)
        @component_element_vals[n]
      end

      def present?
        @component_element_vals.any?{|e| e.present? }
      end

      def append(component)
        self.class.new(element_def, @component_element_vals + [component])
      end

      def prepend(component)
        self.class.new(element_def, component.cons(@component_element_vals))
      end

      def repeated
        RepeatedElementVal.new([self], element_def)
      end

      def ==(other)
        other.component_element_vals == @component_element_vals
      end

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
