module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.3 Composite Data Structure
    #
    class CompositeElementVal < AbstractVal

      # @return [CompositeElementDef]
      attr_reader :definition

      # @return [Array<SimpleElementVal>]
      attr_reader :children
      alias component_vals children

      # @return [SegmentVal]
      attr_reader :parent

      # @return [CompositeElementUse]
      attr_reader :usage

      def initialize(definition, children, parent, usage)
        @definition, @children, @parent, @usage =
          definition, children, parent, usage

        # Delay re-parenting until the entire value tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @children = children.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [CompositeElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent),
          changes.fetch(:usage, @parent)
      end

      def empty?
        @children.all?(&:empty?)
      end

      # @return [SimpleElementVal]
      def at(n)
        if @definition.component_element_uses.defined_at?(n)
          if @children.defined_at?(n)
            @children.at(n)
          else
            @definition.component_element_uses.at(n).empty
          end
        else
          raise IndexError
        end
      end

      # @return [CompositeElementVal]
      def append(component_val)
        copy(:children => component_val.snoc(@children))
      end
      alias append_component append

      # @return [CompositeElementVal]
      def append!(component_val)
        @children = component_val.snoc(@children)
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
            @children.each do |e|
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
        other.definition == @definition and
        other.children == @children
      end
    end

  end
end
