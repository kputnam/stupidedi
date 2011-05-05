module Stupidedi
  module Editor

    class EnvelopeEd < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      # @return [ResultSet]
      def validate(isa)
        ResultSet.new.tap{|acc| edit_isa(isa, acc) }
      end

    private

      def edit_isa(isa, acc)
        isa.segment.tap do |x|
          unless x.node.invalid?
            envelope_def = x.node.definition.parent.parent

            if config.editor.defined_at?(envelope_def)
              editor = config.editor.at(envelope_def)
              editor.new(config, received).validate(isa, acc)
            end
          else
            acc.ta105(x, "R", "003", x.node.reason)
          end
        end
      end

    end

  end
end
