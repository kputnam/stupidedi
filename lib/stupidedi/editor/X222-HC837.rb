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

      def critique(st, acc)
        acc.tap { critique_st(st, acc) }
      end

    private

      # The X222 implementation guide places constraints on the interchange
      # header and trailer that are not modeled in Guide::X222, because the
      # scope is limited to the contents of the transaction set envelope.
      def critique_isa(isa, acc)
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
      def critique_gs(gs, acc)
        # ... However these are all handled generically in TransactionSetEd
        # and are driven by the definition of the transaction set.
      end

      def critique_st(st, acc)
        st.parent.tap do |gs|
          gs.parent.tap do |isa|
            critique_isa(isa, acc)
          end
          critique_gs(gs, acc)
        end
      end

      # IK403 "I10" element must not be present has action "E"

      # X222.074.1000A.NM104.010
      # X222.074.1000A.NM105.020
      # X222.074.1000A.NM109.070
      # X222.076.1000A.PER02.020
      # X222.076.1000A.PER02.040
      # X222.076.1000A.PER05.020
      # X222.076.1000A.PER07.030
      # X222.074.1000B.NM109.050
      # X222.081.2000A.HL01.040
      # X222.083.2000A.PRV03.020  *
      # X222.084.2000A.CUR.010    * Medicare specific
      # X222.084.2000A.CUR.010    * Medicare specific
      # X222.087.2010AA.NM108.010 * Trailblazer specific
      # X222.087.2010AA.NM108.020 * Medicare specific (except Trailblazer)
      # X222.087.2010AA.NM109.030
      # X222.087.2010AA.NM109.040
      # X222.087.2010AA.N302.060  * "Post Office Box", "P.O. Box", "PO Box", "Lock Box", "Lock Bin"

    end

  end
end
