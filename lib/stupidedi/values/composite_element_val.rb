module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.3 Composite Data Structure
    #
    class CompositeElementVal < AbstractVal

      # @return [CompositeElementDef]
      attr_reader :definition

      # @return [Array<SimpleElementVal>]
      attr_reader :component_vals

      # @return [SegmentVal]
      attr_reader :parent

      # @return [CompositeElementUse]
      attr_reader :usage

      def initialize(definition, component_vals, parent, usage)
        @definition, @component_vals, @parent, @usage =
          definition, component_vals, parent, usage

        # Delay re-parenting until the entire value tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @component_vals = component_vals.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [CompositeElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:component_vals, @component_vals),
          changes.fetch(:parent, @parent),
          changes.fetch(:usage, @parent)
      end

      def empty?
        @component_vals.all?(&:empty?)
      end

      # @return [SimpleElementVal]
      def at(n)
        if @definition.component_element_uses.defined_at?(n)
          if @component_vals.defined_at?(n)
            @component_vals.at(n)
          else
            @definition.component_element_uses.at(n).empty
          end
        else
          raise IndexError
        end
      end

      # @return [CompositeElementVal]
      def append(component_val)
        copy(:component_vals => component_val.snoc(@component_vals))
      end
      alias append_component append

      # @return [CompositeElementVal]
      def append!(component_val)
        @component_vals = component_val.snoc(@component_vals)
        self
      end
      alias append_component! append!

      # @return [RepeatedElementVal]
      def repeated
        RepeatedElementVal.new(@definition, [self], @parent)
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}: #{d.name}]" }
        q.text("CompositeElementVal#{id}")

        if empty?
          q.text ".empty"
        else
          q.group(2, "(", ")") do
            q.breakable ""
            @component_vals.each do |e|
              unless q.current_group.first?
                q.text ", "
                q.breakable
              end
              q.pp e
            end
          end
        end
      end

      # @return [Boolean]
      def ==(other)
        other.definition     == @definition and
        other.component_vals == @component_vals
      end
    end

  end
end
