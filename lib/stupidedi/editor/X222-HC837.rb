module Stupidedi
  module Editor

    class X222 < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      def validate(st, acc)
        acc.tap { validate_st(st, acc) }
      end

    private

      # The X222 implementation guide places constraints on the interchange
      # header and trailer that are not modeled in Guide::X222, because the
      # scope is limited to the contents of the transaction set envelope.
      def validate_isa(isa, acc)
        edit(:ISA05) do
          isa.element(5).tap do |e|
            if e.node.present? and e.node.valid?
              unless %w(27 28 ZZ).include?(e.node)
                acc.ta105(e, "R", "005", "must be '27', '28', or 'ZZ'")
              end
            end
          end
        end

        edit(:ISA07) do
          isa.element(7).tap do |e|
            if e.node.present? and e.node.valid?
              unless %w(27 28 ZZ).include?(e.node)
                acc.ta105(e, "R", "005", "must be '27', '28', or 'ZZ'")
              end
            end
          end
        end

        edit(:ISA12) do
          isa.element(12).tap do |e|
            if e.node.present? and e.node.valid?
              unless e.node == "00501"
                acc.ta105(e, "R", "017", "must be '00501'")
              end
            end
          end
        end
      end

      # The X222 implementation guide places constraints on the functional
      # group header and trailer that are not modeled in Guide::X222, because
      # the scope is limited to the contents of the transaction set envelope.
      def validate_gs(gs, acc)
        # ... However these are all handled generically in TransactionSetEd
        # and are driven by the definition of the transaction set.
      end

      def validate_st(st, acc)
        st.parent.tap do |gs|
          gs.parent.tap do |isa|
            validate_isa(isa, acc)
          end
          validate_gs(gs, acc)
        end
      end

    end

  end
end
