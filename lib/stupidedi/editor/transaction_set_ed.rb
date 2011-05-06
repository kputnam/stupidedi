module Stupidedi
  module Editor

    class TransactionSetEd < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      def validate(st, acc)
        st.parent.tap do |gs|
          gs.parent.tap do |isa|
            validate_isa(isa, acc)
          end

          validate_gs(gs, acc)
        end

        acc.tap { validate_st(st, acc) }
      end

    private

      # Performs validations using the definition of the given ISA segment
      def validate_isa(isa, acc)
        isa.segment.tap do |x|
          envelope_def = x.node.definition.parent.parent

          # ...
        end
      end

      # Performs validations using the definition of the given GS segment
      def validate_gs(gs, acc)
        gs.segment.tap do |x|
          envelope_def = x.node.definition.parent.parent

          # ...
        end
      end

      # Performs validations using the definition of the given ST segment
      def validate_st(st, acc)
        st.segment.tap do |x|
          envelope_def = x.node.definition.parent.parent.parent

          # Transaction Set Identifier Code
          st.element(1).tap do |e|
            if e.node.present? and e.node.valid?
              unless e.node == envelope_def.id
                acc.ik502(e, "R", "6", "is not an allowed value")
              end
            end
          end

          st.parent.tap do |gs|
            # Functional Identifier Code
            gs.element(1).tap do |e|
              if e.node.present? and e.node.valid?
                unless e.node == envelope_def.functional_group
                  acc.ak905(e, "R", "1", "is not an allowed value")
                end
              end
            end
          end

          if config.editor.defined_at?(envelope_def)
            editor = config.editor.at(envelope_def)
            editor.new(config, received).validate(st, acc)
          end
        end
      end

      # IK304 "3"   Segment must be present
      # IK304 "I6"  Segment must be present
      # IK304 "5"   Segment occurs too many times
      # IK304 "4"   Loop occurs too many times
      # IK304 "I7"  Loop must be present
      #
      # IK403 "1"   Element must be present
      # IK403 "I10" Element must not be present
      # IK403 "2"   Element must be present if other element(s) is (not) present
      # IK403 "6"   Element must contain at least one character
      # IK403 "4"   Element value is too short
      # IK403 "5"   Element value is too long
      # IK403 "6"   Element has invalid characters
      # IK403 "7"   Invalid code value
      # IK403 "8"   Invalid date
      # IK403 "9"   Invalid time

    end

  end
end

