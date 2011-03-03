module Stupidedi
  module Values

    # @see X222 B.1.1.3.4 Data Segment
    class SegmentVal < AbstractVal
      attr_reader :segment_def
      alias_method :definition, :segment_def

      attr_reader :element_vals

      def initialize(segment_def, element_vals)
        @segment_def, @element_vals = segment_def, element_vals
      end

      def empty?
        @element_vals.all?(&:empty?)
      end

      def present?
        not empty?
      end

      def [](n)
        @element_vals[n]
      end

      # @private
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

      # @private
      def prepend(element_val)
        self.class.new(segment_def, @element_val.cons(element_vals))
      end

      # @private
      def append(element_val)
        self.class.new(segment_def, @element_vals.snoc(element_val))
      end
    end

    #
    # Constructors
    #
    class << SegmentVal
      def empty(segment_def)
        new(segment_def, segment_def.element_uses.map{|e| e.element_def.empty })
      end
    end

  end
end
