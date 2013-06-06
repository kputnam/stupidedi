module Stupidedi
  module Editor

    class X12 < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      def critique(st, acc)
        acc.tap do
          critique_st(st, acc)

        # st.find(:SE).tap do |se|
        #   st.distance(se).tap do |n|
        #     n.times { st.next.tap{|z| z }}
        #   end
        # end

        end
      end

    private

      def critique_isa(isa, acc)
        edit(:ISA07) do
          isa.element(7).tap do |e|
            if e.node.present? and e.node.valid?
              unless %w(02 ZZ).include?(e.node)
                acc.ta105(e, "R", "005", "must be '02', or 'ZZ'")
              end
            end
          end
        end

        edit(:ISA12) do
          isa.element(12).tap do |e|
            if e.node.present? and e.node.valid?
              unless e.node == "00401"
                acc.ta105(e, "R", "017", "must be '00401'")
              end
            end
          end
        end
      end

      def critique_gs(gs, acc)
      end

      def critique_st(st, acc)
        st.parent.tap do |gs|
          gs.parent.tap do |isa|
            critique_isa(isa, acc)
          end

          critique_gs(gs, acc)
        end
      end

      def critique_nm1(nm1, acc)
        edit(:NM1) do
          # Organization/last name
          nm1.element(3).tap do |e|
            if e.node.blank? and e.node.usage.optional?
              acc.warn(e, "optional element is not present")
            end
          end

          # Non-person entity
          if nm1.element(2).select{|e| e.node == "2" }.defined?
            # First name
            nm1.element(4).tap do |e|
              if e.node.present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "505", "must not be present when NM102 is 2")
              end
            end

            # Middle name
            nm1.element(5).tap do |e|
              if e.node.present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "514", "must not be present when NM102 is 2")
              end
            end

            # Prefix name
            nm1.element(6).tap do |e|
              if e.node.present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "125", "must not be present when NM102 is 2")
              end
            end

            # Suffix name
            nm1.element(7).tap do |e|
              if e.node.present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "125", "must not be present when NM102 is 2")
              end
            end
          end

          # Person
          if nm1.element(2).select{|e| e.node == "1" }.defined?
            # First name
            nm1.element(4).tap do |e|
              if e.node.blank? and e.node.usage.optional?
                acc.warn(e, "optional element is not present")
              end
            end

            # Middle name
            nm1.element(5).tap do |e|
              if e.node.blank? and e.node.usage.optional?
                acc.warn(e, "optional element is not present")
              end
            end

            # Prefix name
            nm1.element(6).tap do |e|
              if e.node.blank? and e.node.usage.optional?
                acc.warn(e, "optional element is not present")
              end
            end

            # Suffix name
            nm1.element(7).tap do |e|
              if e.node.blank? and e.node.usage.optional?
                acc.warn(e, "optional element is not present")
              end
            end
          end
        end
      end

      def critique_n3(n3, acc)
        edit(:N3) do
          n3.element(2).tap do |e|
            if e.node.usage.optional?
              unless n3.element(1).reject(&:blank?).defined?
                # Second address line (N302) shouldn't be present if the
                # first (N301) isn't also present
                acc.warn(e, "second address line present without first line")
              end
            end
          end
        end
      end

    end

  end
end
