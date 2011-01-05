module Stupidedi
  module FiftyTen
    module Base

      #
      # Abstract class that describes a common interface between simple and composite element definitions
      #
      class ElementDef
        attr_reader \
          :id,
          :name,
          :purpose

        def initialize(id, name, purpose)
          @id, @name, @purpose = id, name, purpose
        end

        def simple_use(requirement_designator, repetition_count)
          SimpleElementUse.new(self, requirement_designator, repetition_count)
        end

        def writer(interchange_header)
          raise NoMethodError, "Method writer(interchange_header) must be implemented in subclass"
        end

        def reader(input, interchange_header)
          raise NoMethodError, "Method reader(input, interchange_header) must be implemented in subclass"
        end

        def empty
          raise NoMethodError, "Method empty must be implemented in subclass"
        end

        def simple?
          raise NoMethodError, "Method simple? must be implemented in subclass"
        end

        def composite?
          not simple?
        end

        def inspect
          "#<ElementDef #{id} #{self.class.name.split('::').last}>"
        end
      end

      #
      # Element definition that roughly corresponds to a "native type" like string, enum, etc
      #
      class SimpleElementDef < ElementDef
        attr_reader \
          :min_length,
          :max_length

        def initialize(id, name, purpose, min_length, max_length)
          super(id, name, purpose)
          @min_length = min_length
          @max_length = max_length
        end

        def component_use(requirement_designator)
          ComponentElementUse.new(self, requirement_designator)
        end

        def inspect
          "#<SimpleElementDef #{id.inspect} #{self.class.name.split('::').last} (#{@min_length}/#{@max_length})>"
        end

        def reader(input, interchange_header)
          SimpleElementReader.new(input, interchange_header, self)
        end

        def empty
          self.class.empty(self)
        end

        def simple?
          true
        end

        def parse(string)
          self.class.parse(string, self)
        end
      end

      class << SimpleElementDef

      private

        def failure(message)
          Either.failure(message)
        end

        def success(value)
          Either.success(value)
        end
      end

      # Element definition that roughly corresponds to a "struct" with only "native type" fields
      class CompositeElementDef < ElementDef
        attr_reader :component_element_uses

        def initialize(id, name, purpose, *component_element_uses)
          super(id, name, purpose)
          @component_element_uses = component_element_uses
        end

        def tail
          self.class.new(id, name, purpose, *@component_element_uses.tail)
        end

        # NOTE: method component_use is not implemented, because composite elements
        # cannot be nested within other composite elements. It is however, implemented
        # in SimpleElementDef, because components of a composite element are indeed
        # merely simple elements.

        def reader(input, interchange_header)
          CompositeElementReader.new(input, interchange_header, self)
        end

        def empty
          @component_element_uses.map{|e| e.element_def.empty }
        end

        def simple?
          false
        end

        def inspect
          "#<CompositeElementDef #{id.inspect}>"
        end

      end

    end
  end
end
