module Stupidedi
  module Builder

    class TransmissionBuilder < AbstractState

      # @return [Array<InterchangeVal>]
      attr_reader :value

      # @return [Configuration::RootConfig]
      attr_reader :config

      def initialize(config, interchange_vals)
        @config, @value = config, interchange_vals
      end

      # @return [TransmissionBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:config, @config),
          changes.fetch(:value, @value)
      end

      # @return [TransmissionBuilder]
      def merge(interchange_val)
        copy(:value => interchange_val.snoc(@value))
      end

      # @return [InterchangeBuilder, FailureState]
      def segment(name, elements)
        case name
        when :ISA
          # ISA12 Interchange Control Version Number
          version      = elements.at(11)
          envelope_def = @config.interchange.lookup(version)

          unless envelope_def
            return failure("Unrecognized interchange version #{version.inspect}")
          end

          # Construct an ISA segment
          segment_use = envelope_def.header_segment_uses.head
          segment_val = mksegment(segment_use, elements)

          # Construct an InterchangeVal containing the ISA segment
          interchange_val = envelope_def.value(segment_val)

          step(InterchangeBuilder.start(interchange_val, self))
        else
          failure("Unexpected segment #{name}")
        end
      end

      # @private
      def pretty_print(q)
        q.text("TransmissionBuilder")
        q.group(2, "(", ")") do
          q.breakable ""
          @value.each do |e|
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
      def start(config)
        TransmissionBuilder.new(config, [])
      end
    end

  end
end
