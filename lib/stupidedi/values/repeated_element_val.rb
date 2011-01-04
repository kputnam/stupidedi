module Stupidedi
  module Values

    class RepeatedElementVal
      include Enumerable

      attr_reader :element_def, :element_vals

      def initialize(element_vals, element_def)
        @element_vals, @element_def = element_vals, element_def
      end

      def count
        @element_vals.length
      end

      def length
        @element_vals.length
      end

      def [](n)
        @element_vals[n]
      end

      def empty?
        @element_vals.all?(&:empty?)
      end

      def present?
        @element_vals.any?(&:present?)
      end

      def append(element)
        self.class.new(@element_vals + [element], element_def)
      end

      def prepend(element)
        self.class.new(element.cons(@element_vals), element_def)
      end

      def ==(other)
        other.element_vals == @element_vals
      end

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
