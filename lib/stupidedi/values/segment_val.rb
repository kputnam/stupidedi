module Stupidedi
  module Values

    class SegmentVal
      attr_reader :segment_def, :element_vals

      def initialize(segment_def, element_vals)
        @segment_def, @element_vals = segment_def, element_vals
      end

      def empty?
        @element_vals.all?(&:empty?)
      end

      def present?
        @element_vals.any?(&:present?)
      end

      def [](n)
        @element_vals[n]
      end

      def prepend(element_val)
        self.class.new(segment_def, element_val.cons(element_vals))
      end

      def append(element_val)
        self.class.new(segment_def, @element_vals + [element_val])
      end

      def pretty_print(q)
        q.text("SegmentVal[#{segment_def.try(:id)}]")
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

    # Constructors
    class << SegmentVal
      def empty(segment_def)
        new(segment_def, segment_def.element_uses.map{|e| e.element_def.empty })
      end
    end

  end
end
