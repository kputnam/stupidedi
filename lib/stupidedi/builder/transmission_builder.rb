module Stupidedi
  module Builder

    class TransmissionBuilder < AbstractBuilder
      def initialize(router)
        @router = router
      end

      def segment(name, *elements)
        case name.to_s.downcase
        when "isa"
          # ISA12 indicates the interchange version
          if version = @router.interchange.lookup(elements.at(11))
            # ...
            InterchangeBuilder.new(@router, version)
          else
            # @todo: Unrecognized interchange version
            self
          end
        else
          # @todo: Interchange must start with the ISA segment
          self
        end
      end
    end

  end
end
