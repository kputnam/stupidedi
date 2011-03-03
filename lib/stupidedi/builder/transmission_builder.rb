module Stupidedi
  module Builder

    class TransmissionBuilder
      # @return [Array<Envelope::InterchangeVal>]
      attr_reader :interchanges

      # @return [Envelope::Router]
      attr_reader :router

      def initialize(router)
        @router       = router
        @interchanges = []
      end

      def segment(name, *elements)
        unless name == :ISA
          raise "@todo"
        end

        isa(*elements)
      end

      def isa(*elements)
        # ISA12 Interchange Control Number
        unless elements.defined_at?(11)
          raise "@todo"
        end

        # Envelope::InterchangeDef
        version = @router.interchange.lookup(elements.at(11))

        unless version
          raise "@todo"
        end

        # Construct an empty ISA segment
        isa = version.header_segment_uses.first.definition.empty

        # Populate the ISA's elements
        # @todo: error-check (extra|missing|invalid) elements
        if elements.length < isa.definition.element_uses.length
          isa.definition.element_uses.zip(elements) do |use, value|
            isa = isa.append(use.definition.value(value))
          end
        else
          elements.zip(isa.definition.element_uses) do |value, use|
            isa = isa.append(use.definition.value(value))
          end
        end

        interchange = version.value([isa], [], [])
        @interchanges << interchange

        InterchangeBuilder.new(self, interchange)
      end
    end

  end
end
