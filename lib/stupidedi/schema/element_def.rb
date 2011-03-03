module Stupidedi
  module Schema

    # @see X222 B.1.1.3.1 Data Element
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

      def simple_use(requirement, repeat_count, parent = nil)
        SimpleElementUse.new(self, requirement, repeat_count, parent)
      end

      def component_use(requirement, parent = nil)
        ComponentElementUse.new(self, requirement, parent)
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
      attr_reader :element_uses

      # @return [Array<SyntaxNote>]
      attr_reader :syntax_notes

      # @return [CompositeElementUse]
      attr_reader :parent

      def initialize(id, name, description, element_uses, syntax_notes, parent = nil)
        @id, @name, @description, @element_uses, @syntax_notes, @parent =
          id, name, description, element_uses, syntax_notes, parent

        @element_uses = @element_uses.map{|x| x.copy(:parent => self) }
        @syntax_notes = @syntax_notes.map{|x| x.copy(:parent => self) }
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:name, @name),
          changes.fetch(:description, @description),
          changes.fetch(:element_uses, @element_uses),
          changes.fetch(:syntax_notes, @syntax_notes),
          changes.fetch(:parent, @parent)
      end

      def simple?
        false
      end

      def composite?
        true
      end

      def simple_use(requirement, repeat_count, parent = nil)
        CompositeElementUse.new(self, requirement, repeat_count, parent)
      end

      # @return [CompositeElementVal]
      def value(component_element_vals, parent = nil, usage = nil)
        Values::CompositeElementVal.new(self, (component_element_vals || []), parent, usage)
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
          @element_uses.each do |e|
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
      def build(id, name, description, *args)
        element_uses = args.take_while{|x| x.is_a?(ElementUse) }
        syntax_notes = args.drop(element_uses.length)

        new(id, name, description, element_uses, syntax_notes, parent = nil)
      end
    end

  end
end
