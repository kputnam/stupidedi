module Stupidedi
  module Values

    # @see X222 B.1.1.3.4 Data Segment
    class SegmentVal < AbstractVal
      # @return [SegmentDef]
      attr_reader :definition

      # @return [Array<ElementVal>]
      attr_reader :element_vals

      # @return [LoopVal, TableVal, FunctionalGroupVal, InterchangeVal]
      attr_reader :parent

      def initialize(definition, element_vals, parent)
        @definition, @element_vals, @parent = definition, element_vals, parent
      end

      # @return [SegmentVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:element_vals, @element_vals),
          changes.fetch(:parent, @parent)
      end

      def empty?
        @element_vals.all?(&:empty?)
      end

      # @return [SimpleElementVal, CompositeElementVal, RepeatedElementVal]
      def at(n)
        raise IndexError unless @definition.nil? or defined_at?(n)

        if @element_vals.defined_at?(n)
          @element_vals.at(n)
        else
          @definition.element_uses.at(n).definition.blank
        end
      end

      def prepend(element_val)
        copy(:element_vals => element_val.cons(@element_vals))
      end

      def append(element_val)
        copy(:element_vals => element_val.snoc(@element_vals))
      end

      def defined_at?(n)
        @definition.try{|d| d.element_uses.defined_at?(n) }
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|s| "[#{s.id}]" }
        q.text("SegmentVal#{id}")
        q.group(2, "(", ")") do
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

      def ==(other)
        other.definition == @definition and
        other.element_vals == @element_vals
      end
    end

  end
end
