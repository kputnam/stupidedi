module Stupidedi
  module Builder

    class TransmissionBuilder
      attr_reader :interchange_vals

      def initialize(router, interchange_vals)
        @router, @interchange_vals = router, interchange_vals
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:router, @router),
          changes.fetch(:interchange_vals, @interchange_vals)
      end

      def append(interchange_val)
        copy(:interchange_vals => interchange_val.snoc(@interchange_vals))
      end

      def segment(name, *elements)
        case name
        when :ISA
          # ISA12 Interchange Control Version Number
          version    = elements.at(11))
          envelope_def = @router.interchange.lookup(version)

          unless envelope_def
            fail "Unrecognized interchange version #{version.inspect}"
          end

          # Construct an ISA segment
          segment_def = envelope_def.header_segment_uses.head.definition
          segment_val = construct(segment_def, elements)
          interchange_val = version.value(segment_val.cons, [], [])

          branch InterchangeBuilder.start(interchange_val, self)
        else
          fail "Interchange must begin with the ISA segment"
        end
      end
    end

    class << TransmissionBuilder
      def start(router)
        TransmissionBuilder.new(router, [])
      end
    end

  end
end
