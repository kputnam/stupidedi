module Stupidedi
  module Builder

    class TransmissionBuilder < AbstractState
      # @return [Array<InterchangeVal>]
      attr_reader :interchange_vals

      # @return [Envelope::Router]
      attr_reader :router

      def initialize(router, interchange_vals)
        @router, @interchange_vals = router, interchange_vals
      end

      def stuck?
        false
      end

      # @return [TransmissionBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:router, @router),
          changes.fetch(:interchange_vals, @interchange_vals)
      end

      # @return [TransmissionBuilder]
      def append(interchange_val)
        copy(:interchange_vals => interchange_val.snoc(@interchange_vals))
      end

      def segment(name, elements)
        case name
        when :ISA
          # ISA12 Interchange Control Version Number
          version      = elements.at(11)
          envelope_def = @router.interchange.lookup(version)

          unless envelope_def
            return failure("Unrecognized interchange version #{version.inspect}")
          end

          # Construct an ISA segment
          segment_use = envelope_def.header_segment_uses.head
          segment_val = construct(segment_use, elements)
          interchange_val = envelope_def.value(segment_val.cons, [], [])

          step(InterchangeBuilder.start(interchange_val, self))
        else
          failure("Unexpected segment #{name}")
        end
      end

      def pretty_print(q)
        q.text("TransmissionBuilder")
        q.group(2, "(", ")") do
          q.breakable ""
          @interchange_vals.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.text("InterchangeVal[#{e.definition.id}]")
          end
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
