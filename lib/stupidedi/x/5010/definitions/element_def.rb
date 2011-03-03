module Stupidedi
  module FiftyTen
    module Definitions

      #
      # Abstract class that describes a common interface between simple and
      # composite element definitions
      #
      # @abstract
      #
      class ElementDef

        # Element identifier from the X12 Element Dictionary (for instance,
        # "E128")
        #
        # @return [String]
        attr_reader :id

        # Element name from the X12 Element Dictionary (for instance "Reference
        # Identification Qualifier")
        #
        # @return [String]
        attr_reader :name

        # Element purpose from the X12 Element Dictionary (for instance "Code
        # qualifying the Reference Identification")
        #
        # @return [String]
        attr_reader :purpose

        # @param [String] id Element identifier from the X12 Element Dictionary
        #   (instance "E128")
        #
        # @param [String] name Element name from the X12 Element Dictionary
        #   (for instance "Reference Identification Qualifier")
        #
        # @param [String] purpose Element purpose from the X12 Element
        #   Dictionary (eg "Code qualifying the Reference Identification")
        def initialize(id, name, purpose)
          @id, @name, @purpose = id, name, purpose
        end

        # Creates a SimpleElementUse that describes the use of the simple or
        # composite element when the parent structure is a {SegmentDef}
        #
        # @param [Designations::ElementRequirement] requirement_designator
        #   Indicates if an occurence of this element is mandatory or optinal
        #
        # @param [Designations::ElementRepetition] repetition_count Indicates
        #   how many times this element is allowed to repeat
        #
        # @return [SimpleElementUse]
        def simple_use(requirement_designator, repetition_count)
          SimpleElementUse.new(self, requirement_designator, repetition_count)
        end

        # @abstract
        def writer(interchange_header)
          raise NoMethodError, "Method writer must be implemented in subclass"
        end

        # Creates a {Reader::TokenReader} that can parse the given +input+ using
        # this element definition
        #
        # @abstract
        #
        # @param [Input::AbstractInput, String] input The unparsed input stream
        # @param [Interchange::FiveOhOne::InterchangeHeader] interchange_header
        #
        # @return [Readers::ElementReader]
        def reader(input, interchange_header)
          raise NoMethodError, "Method reader must be implemented in subclass"
        end

        # Creates an empty element value using this element definition
        #
        # @abstract
        # @return [Values::SimpleElementVal, Values::CompositeElementVal]
        def empty
          raise NoMethodError, "Method empty must be implemented in subclass"
        end

        # True if this is a {SimpleElementDef}
        #
        # @abstract
        # @return [Boolean]
        def simple?
          raise NoMethodError, "Method simple? must be implemented in subclass"
        end

        # True if this is a {CompositeElementDef}
        #
        # @return [Boolean]
        def composite?
          not simple?
        end

        # @return [String]
        def inspect
          "#<ElementDef #{id} #{self.class.name.split('::').last}>"
        end
      end

      #
      # Element definition that roughly corresponds to a "native type". Simple
      # elements are the most smallest unit of meaning
      #
      class SimpleElementDef < ElementDef
        # Minimum permissable length in characters. Note that different data
        # types ignore certain characters (like decimal points) when calculating
        # lengths
        #
        # @return [Integer]
        attr_reader :min_length

        # Maximum permissable length in characters. Note that different data
        # types ignore certain characters (like decimal points) when calculating
        # lengths
        #
        # @return [Integer]
        attr_reader :max_length

        # @param [Integer] min_length Minimum permissable length in characters.
        # @param [Integer] max_length Maximum permissable length in characters.
        # @see ElementDef#initialize
        def initialize(id, name, purpose, min_length, max_length)
          super(id, name, purpose)
          @min_length = min_length
          @max_length = max_length
        end

        # Creates a ComponentElementUse that describes the use of this element
        # when the parent structure is a {SegmentDef}
        #
        # @param [Designations::ElementRequirement] requirement_designator
        #   Indicates if an occurence of this element is mandatory or optinal
        #
        # @return [CompositeElementUse]
        def component_use(requirement_designator)
          ComponentElementUse.new(self, requirement_designator)
        end

        # @private
        def inspect
          subtype = self.class.name.split('::').last
          "#<SimpleElementDef #{id} #{subtype} (#{@min_length}/#{@max_length})>"
        end

        # Creates a Readers::SimpleElementReader that can parse the given
        # +input+ according to the element definition
        #
        # @param [Input::AbstractInput, String] input the unparsed input stream
        # @param [Interchange::FiveOhOne::InterchangeHeader] interchange_header
        #
        # @return [Readers::SimpleElementReader]
        def reader(input, interchange_header)
          Readers::SimpleElementReader.new(input, interchange_header, self)
        end

        # Create an empty SimpleElementVal from this definition
        #
        # @return [Values::SimpleElementVal]
        def empty
          self.class.empty(self)
        end

        # Always +true+
        def simple?
          true
        end

        # Convert the given +string+ to a SimpleElementVal. The default
        # implementation defers to the class method {SimpleElementDef.parse},
        # which defers to the subclass's implementation
        #
        # @param [String] string the String representation of an element value
        # @return [Either::Success<Values::SimpleElementVal>,
        #          Either::Failure<String>]
        def parse(string)
          self.class.parse(string, self)
        end
      end

      class << SimpleElementDef
        # ...
        #
        # @abstract
        # @return [SimpleElementVal]
        def parse(string, instance = nil)
          raise NoMethodError, "Method parse must be implemented in subclass"
        end

      private

        def failure(message)
          Either.failure(message)
        end

        def success(value)
          Either.success(value)
        end
      end

      #
      # Element definition that roughly corresponds to a "struct" with only
      # "native type" fields
      #
      # @note The +component_use+ method is not implemented, because composite
      # elements cannot be nested within other composite elements. However, it
      # is implemented in {SimpleElementDef}, because components of a composite
      # element are indeed merely simple elements
      #
      class CompositeElementDef < ElementDef
        # List of {ComponentElementUse} that describes each component element
        # and its requirement designator
        attr_reader :component_element_uses

        # @param [Integer] min_length Minimum permissable length in characters.
        # @param [Integer] max_length Maximum permissable length in characters.
        # @see ElementDef#initialize
        def initialize(id, name, purpose, *component_element_uses)
          super(id, name, purpose)
          @component_element_uses = component_element_uses
        end

        def reader(input, interchange_header)
          Readers::CompositeElementReader.new(input, interchange_header, self)
        end

        # Create an empty CompositeElementVal from this definition
        def empty
          Values::CompositeElementVal.new(self, @component_element_uses.map{|e| e.element_def.empty })
        end

        def simple?
          false
        end

        # @private
        def inspect
          "#<CompositeElementDef #{id}>"
        end

        # @private
        def tail
          self.class.new(id, name, purpose, *@component_element_uses.tail)
        end
      end

    end
  end
end
