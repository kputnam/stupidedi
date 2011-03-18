module Stupidedi
  module Schema

    #
    # @see X222 B.1.1.3.1 Data Element
    #
    class SimpleElementDef
      # @return [String]
      abstract :id

      # @return [String]
      abstract :name

      # @return [String]
      abstract :description

      # @return [SimpleElementUse, ComponentElementUse]
      abstract :parent

      # @return [SimpleElementVal]
      abstract :empty

      # @return [SimpleElementVal]
      abstract :value, :args => %w(object)

      def simple?
        true
      end

      def composite?
        false
      end

      # @return [SimpleElementUse]
      def simple_use(requirement, repeat_count, parent = nil)
        SimpleElementUse.new(self, requirement, repeat_count, Sets.universal, parent)
      end

      # @return [ComponentElementUse]
      def component_use(requirement, parent = nil)
        ComponentElementUse.new(self, requirement, Sets.universal, parent)
      end
    end

    # @see X222 B.1.1.3.3 Composite Data Structure
    class CompositeElementDef
      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :description

      # @return [Array<ComponentElementUse>]
      attr_reader :component_uses

      # @return [Array<SyntaxNote>]
      attr_reader :syntax_notes

      # @return [CompositeElementUse]
      attr_reader :parent

      def initialize(id, name, description, component_uses, syntax_notes, parent)
        @id, @name, @description, @component_uses, @syntax_notes, @parent =
          id, name, description, component_uses, syntax_notes, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @component_uses = @component_uses.map{|x| x.copy(:parent => self) }
          @syntax_notes   = @syntax_notes.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [ElementDef]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:name, @name),
          changes.fetch(:description, @description),
          changes.fetch(:component_uses, @component_uses),
          changes.fetch(:syntax_notes, @syntax_notes),
          changes.fetch(:parent, @parent)
      end

      def simple?
        false
      end

      def composite?
        true
      end

      # @return [CompositeElementUse]
      def simple_use(requirement, repeat_count, parent = nil)
        CompositeElementUse.new(self, requirement, repeat_count, parent)
      end

      # @return [CompositeElementVal]
      def value(component_vals, parent = nil, usage = nil)
        Values::CompositeElementVal.new(self, component_vals || [], parent, usage)
      end

      # @return [CompositeElementVal]
      def empty(parent = nil, usage = nil)
        Values::CompositeElementVal.new(self, [], parent, usage)
      end

      # @private
      def pretty_print(q)
        q.text("CompositeElementDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @component_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << CompositeElementDef
      # @return [CompositeElementDef]
      def build(id, name, description, *args)
        component_uses = args.take_while{|x| x.is_a?(ElementUse) }
        syntax_notes   = args.drop(component_uses.length)

        new(id, name, description, component_uses, syntax_notes, parent = nil)
      end
    end

  end
end
