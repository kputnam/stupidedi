module Stupidedi
  module Editor

    #
    # Critiques (edits) a "005010" functional groups (GS/GE), then selects the
    # appropriate editor, according to the config, and edits each transaction
    # set (ST/SE)
    #
    class FiftyTenEd < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      def critique(gs, acc)
        acc.tap { critique_gs(gs, acc) }
      end

    private

      def critique_gs(gs, acc)
        # Functional Group Code
        edit(:GS01) do
          gs.element(1).tap do |e|
            if e.node.blank?
              if e.node.usage.required?
                acc.ak905(e, "R", "1", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ak905(e, "R", "1", "must not be present")
            else
              # @todo: The allowed value depends on the child transaction set,
              # but the GS segment is not declared in the transaction set def.
              # Furthermore, the functional group may contain many transaction
              # sets, so we need to check it once we get to the ST segment...
            end
          end
        end

        # Application Sender's Code
        edit(:GS02) do
          gs.element(2).tap do |e|
            if e.node.blank?
              if e.node.usage.required?
                acc.ak905(e, "R", "14", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ak905(e, "R", "14", "must not be present")
            elsif e.node.invalid? or not config.editor.an?(e.node)
              acc.ak905(e, "R", "14", "is not a valid string")
            end
          end
        end

        # Application Receiver's Code
        edit(:GS03) do
          gs.element(3).tap do |e|
            if e.node.blank?
              acc.ak905(e, "R", "13", "must be present")
            elsif e.node.invalid? or not config.editor.an?(e.node)
              acc.ak905(e, "R", "13", "is not a valid string")
            end
          end
        end

        # Date
        edit(:GS04) do
          gs.element(4).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "024", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "024", "is not a valid date")
            elsif e.node > received.utc.send(:to_date)
              acc.ta105(e, "R", "024", "must not be a future date")
            end
          end
        end

        # Time
        edit(:GS05) do
          gs.element(5).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "024", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "024", "is not a valid time")
            else
              gs.element(4).reject{|f| f.node.invalid? }.tap do |f|
                if e.node.to_time(f.node) > received.utc
                  acc.ta105(e, "R", "024", "must not be a future date")
                end
              end
            end
          end
        end

        # Group Control Number
        edit(:GS06) do
          gs.element(6).tap do |e|
            if e.node.blank?
              acc.ak905(e, "R", "6", "must be present")
            elsif e.node.invalid?
              acc.ak905(e, "R", "6", "is not a valid string")
            elsif e.node < 0
              acc.ak905(e, "R", "6", "must be positive")
            elsif e.node > 999_999_999
              acc.ak905(e, "R", "6", "is too long")
            end
          end
        end

        # Responsible Agency Code
        edit(:GS07) do
          gs.element(7).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "024", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "024", "is not a valid string")
            elsif not e.node.allowed?
              acc.ta105(e, "R", "024", "is not an allowed value")
            end
          end
        end

        # Version/Release/Industry Identifier Code
        edit(:GS08) do
          gs.element(8).tap do |e|
            if e.node.blank?
              acc.ak905(e, "R", "2", "must be present")
            end
          end
        end

        st, st02s = gs.find!(:ST), Hash.new{|h,k| h[k] = [] }
        # Collect all the ST02 elements within this functional group
        while st.defined?
          st = st.flatmap do |st|
            critique_st(st, acc)

            st.element(2).
              tap{|e| st02s[e.node.to_s] << e }.
              explain do
                # The #element method failed because this was an invalid ST
                # segment. To workaround that, we can get the SegmentTok and
                # select the ST02 ElementTok (zero-based index)
                st.segment.tap do |s|
                  elements = s.node.segment_tok.element_toks
                  st02s[elements.at(1).value] << s
                end
              end

            st.find!(:ST)
          end
        end

        edit(:ST) do
          if st02s.empty?
            gs.segment.tap{|s| acc.ik502(s, "R", "1", "missing ST segment") }
          end
        end

        edit(:ST02) do
          st02s.each do |number, es|
            next if number.blank?
            es.tail.each do |e|
              acc.ik502(e, "R", "23", "must be unique within functional group")
            end
          end
        end

        edit(:GE) do
          gs.find(:GE).tap do |ge|
            critique_ge(ge, gs, st02s.length, acc)
          end.explain do
            gs.segment.tap{|s| acc.ak905(s, "R", "3", "missing GE segment") }
          end
        end
      end

      def critique_ge(ge, gs, st_count, acc)
        # Number of Transaction Sets Included
        edit(:GE01) do
          ge.element(1).tap do |e|
            if e.node.empty?
              acc.ak905(e, "R", "5", "must be present")
            elsif e.node.invalid?
              acc.ak905(e, "R", "5", "must be numeric")
            elsif e.node != st_count
              acc.ak905(e, "R", "5", "must equal the number of transactions")
            end
          end
        end

        # Group Control Number
        edit(:GE02) do
          ge.element(2).tap do |e|
            if e.node.empty?
              acc.ak905(e, "R", "4", "must be present")
            else
              gs.element(6).reject{|f| e.node == f.node }.tap do |f|
                acc.ak905(e, "R", "4", "must match functional group header control number")
              end
            end
          end
        end
      end

      def critique_st(st, acc)
        st.segment.tap do |x|
          unless x.node.invalid?
            # Invoke a general transaction set editor, which will later
            # dispatch to a guide-specific transaction set editor
            editor = TransactionSetEd.new(config, received)
            editor.critique(st, acc)
          else
            acc.ik502(x, "R", "I6", x.node.reason)
            return
          end
        end

        # Transaction Set Identifier Code
        edit(:ST01) do
          st.element(1).tap do |e|
            if e.node.blank?
              if e.node.usage.required?
                acc.ik502(e, "R", "6", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ik502(e, "R", "6", "must not be present")
            elsif e.node.invalid?
              acc.ik502(e, "R", "6", "is not a valid identifier")
            elsif not e.node.allowed?
              acc.ik502(e, "R", "6", "is not an allowed value")
            end
          end
        end

        # Transaction Set Control Number
        edit(:ST02) do
          st.element(2).tap do |e|
            if e.node.blank?
              if e.node.usage.required?
                acc.ik502(e, "R", "7", "must be present")
              elsif e.node.usage.forbidden?
                acc.ik502(e, "R", "7", "must not be present")
              elsif e.node.invalid?
                acc.ik502(e, "R", "7", "is not a valid string")
              end
            end
          end
        end

        # Implementation Convention Reference
        edit(:ST03) do
          st.element(3).tap do |e|
            if e.node.blank?
              if e.node.usage.required?
                acc.ik502(e, "R", "I6", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ik502(e, "R", "I6", "must not be present")
            elsif e.node.invalid?
              acc.ik502(e, "R", "I6", "is not a valid string")
            elsif not e.node.allowed?
              acc.ik502(e, "R", "I6", "is not an allowed value")
            end
          end
        end

        edit(:SE) do
          st.find(:SE).tap do |se|
            critique_se(se, st, acc)
          end.explain do
            st.segment.tap{|s| acc.ik502(s, "R", "2", "missing SE segment") }
          end
        end
      end

      def critique_se(se, st, acc)
        # Number of Included Segments
        edit(:SE01) do
          se.element(1).tap do |e|
            if e.node.empty?
              if e.node.usage.required?
                acc.ik502(e, "R", "4", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ik502(e, "R", "4", "must not be present")
            elsif e.node.invalid?
              acc.ik502(e, "R", "4", "must be numeric")
            else
              st.distance(se).tap do |d|
                unless e.node == d + 1
                  acc.ik502(e, "R", "4", "must equal the transaction segment count")
                end
              end
            end
          end
        end

        # Transaction Set Control Number
        edit(:SE02) do
          se.element(2).tap do |e|
            if e.node.empty?
              if e.node.usage.required?
                acc.ik502(e, "R", "3", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ik502(e, "R", "3", "must not be present")
            elsif e.node.invalid?
              acc.ik502(e, "R", "3", "is not a valid string")
            else
              st.element(2).reject{|f| f.node == e.node }.tap do
                acc.ik502(e, "R", "3", "must equal transaction header control number")
              end
            end
          end
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
              if e.node.is_present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "505", "must not be present when NM102 is 2")
              end
            end

            # Middle name
            nm1.element(5).tap do |e|
              if e.node.is_present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "514", "must not be present when NM102 is 2")
              end
            end

            # Prefix name
            nm1.element(6).tap do |e|
              if e.node.is_present? and e.node.usage.optional?
                acc.stc01(e, "T", "A8", "125", "must not be present when NM102 is 2")
              end
            end

            # Suffix name
            nm1.element(7).tap do |e|
              if e.node.is_present? and e.node.usage.optional?
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
              unless n3.element(1).relect(&:blank?).defined?
                # Second address line (N302) shouldn't be present if the
                # first (N301) isn't also present
                acc.warn(e, "second address line present without first line")
              end
            end
          end
        end
      end

      def critique_n4(n4, acc)
        edit(:N4) do
          usa_canada =
            n4.element(2).select(&:is_present?).defined? ||
            n4.element(4).select(&:blank?).defined?   ||
            n4.element(4).select{|e| e.node == "US" }.defined? ||
            n4.element(7).select(&:blank?).defined?

          # State or Province Code
          n4.element(2).tap do |e|
            if usa_canada
              if e.node.blank? and e.node.situational?
                # Required
              end
            else
              if e.node.is_present? and e.node.situational?
                # Forbidden
              end
            end
          end

          # Postal Code
          n4.element(3).tap do |e|
            if usa_canada
              # US zipcodes must be 9-digits
            end
          end

          # Country Code
          n4.element(4).tap do |e|
            if usa_canada
              if e.node.is_present? and e.node.situational?
                # Forbidden
              end
            else
              # Country codes 2-digit from ISO 3166
            end
          end

          # Country Subdivision Code
          n4.element(7).tap do |e|
            if usa_canada
              if e.node.is_present? and e.node.situational?
                # Forbidden
              end
            else
              # Country subdivision codes from ISO 3166
            end
          end
        end
      end

    end

  end
end
