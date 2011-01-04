module Stupidedi
  module Values

    class StringVal < SimpleElementVal

      class Empty < StringVal
        def empty?
          true
        end

        def present?
          false
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "StringVal.empty#{def_id}"
        end

        def ==(other)
          other.is_a?(self.class)
        end
      end

      class NonEmpty < StringVal
        attr_reader :delegate

        def initialize(delegate, element_def)
          @delegate = delegate
          super(element_def)
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "StringVal.value#{def_id}(#{@delegate})"
        end

        def empty?
          false
        end

        def present?
          true
        end

        # Beware, not commutative
        #   StringVal.value('XX') == 'XX'
        #                   'XX' != StringVal.value('XX')
        def ==(other)
          if other.is_a?(self.class)
            delegate == other.delegate
          else
            delegate == other
          end
        end
      end

    end

    # Constructors
    class << StringVal
      def empty(element_def = nil)
        StringVal::Empty.new(element_def)
      end

      # Convert data read from ElementReader
      def value(string, element_def)
        StringVal::NonEmpty.new(string, element_def)
      end

      # Convert a ruby String value
      def from_string(string, element_def = nil)
        value(string, element_def)
      end
    end

    # Prevent direct instantiation of abstract class StringVal
    StringVal.eigenclass.send(:protected, :new)
    StringVal::Empty.eigenclass.send(:public, :new)
    StringVal::NonEmpty.eigenclass.send(:public, :new)

  end
end
