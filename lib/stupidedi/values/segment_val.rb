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

      # @return [SegmentUse]
      attr_reader :usage

      def initialize(definition, element_vals, parent, usage)
        @definition, @element_vals, @parent, @usage =
          definition, element_vals, parent, usage

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @element_vals = element_vals.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [SegmentVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:element_vals, @element_vals),
          changes.fetch(:parent, @parent),
          changes.fetch(:usage, @usage)
      end

      def empty?
        @element_vals.all?(&:empty?)
      end

      def defined_at?(n)
        @definition.try{|d| d.element_uses.defined_at?(n) }
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

      # @return [SegmentVal]
      def append_element(element_val)
        copy(:element_vals => element_val.snoc(@element_vals))
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}: #{d.name}]" }

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

      # @private
      def ==(other)
        other.definition   == @definition and
        other.element_vals == @element_vals
      end
    end

  end
end
