module Stupidedi
  module Editor

    class EnvelopeEd < AbstractEd

      declare :ISA01, :ISA02, :ISA03, :ISA04, :ISA05, :ISA06,
              :ISA07, :ISA08, :ISA09, :ISA10, :ISA11, :ISA12,
              :ISA13, :ISA14, :ISA15, :ISA16

      declare :IEA01, :IEA02, :IEA

      declare :GS, :GS01, :GS02, :GS03, :GS04, :GS05, :GS06, :GS07, :GS08

      declare :GE, :GE01, :GE02

      declare :ST, :ST01, :ST02, :ST03

      declare :SE, :SE01, :ST02

      # @return [Config]
      attr_reader :config

      def initialize(config)
        @config = config
      end

      # @return [ResultSet]
      def validate(isa, received = Time.now.utc)
        # 000: No error

        # 002: This Standard as Noted in the Control Standards Identifier is Not Supported
        #   Check for InvalidEnvelope

        # 003: This Version of the Controls is Not Supported
        #   Check for InvalidEnvelope

        # 004: The Segment Terminator is Invalid
        #   We couldn't have produced a parse tree, StreamReader#next_segment
        #   would have returned an Either.failure<Result.failure>

        # 009: Unknown Interchange Receiver ID
        #   This isn't for Stupidedi to decide

        # 016: Invalid Interchange Standards Identifier Value
        #   Check for InvalidEnvelope

        # 022: Invalid Control Characters
        #   What does this mean? TokenReader ignores control characters anyway,
        #   so there will be no evidence of this in the parse tree

        # 025: Duplicate Interchange Control Numbers
        #   Need to validate the parent, TransmissionVal

        # 028: Invalid Date in Deferred Delivery Request
        # 029: Invalid Time in Deferred Delivery Request
        # 030: Invalid Delivery Time Code in Deferred Delivery Request
        # 031: Invalid Grade of Service
        #   It seems these elements should not be sent to a trading partner,
        #   they are used internally to schedule a delivery. Not sure what to do
        #   about validating them in a general way...

        edit_isa(isa, received, ResultSet.new)
      end

    private

      def an?(e)
        @config.an?(e)
      end

      def edit_isa(isa, received, acc)
        # Authorization Information Qualifier
        edit(:ISA01) do
          isa.element(1).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "010", "must be present")
          # elsif not %w(00 03).include?(e.node)
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "010", "has an invalid value")
            end
          end
        end

        # Authorization Information
        edit(:ISA02) do
          isa.element(2).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "011", "must be present")
          # elsif e.node.length != 10
          #   acc.ta105(e, "R", "011", "must have exactly 10 characters")
            elsif e.node.invalid? or not an?(e.node)
              acc.ta105(e, "R", "011", "is not a valid string")
            end
          end
        end

        # Security Information Qualifier
        edit(:ISA03) do
          isa.element(3).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "012", "must be present")
          # elsif not %w(00 01).include?(e.node)
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "012", "has an invalid value")
            end
          end
        end

        # Security Information
        edit(:ISA04) do
          isa.element(4).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "013", "must be present")
          # elsif e.node.length != 10
          #   acc.ta105(e, "R", "013", "must have exactly 10 characters")
            elsif e.node.invalid? or not an?(e.node)
              acc.ta105(e, "R", "013", "is not a valid string")
            end
          end
        end

        # Interchange ID Qualifier
        edit(:ISA05) do
          isa.element(5).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "005", "must be present")
          # elsif not %w(27 28 ZZ).include?(e.node)
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "005", "has an invalid value")
            end
          end
        end

        # Interchange Sender ID
        edit(:ISA06) do
          isa.element(6).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "006", "must be present")
            elsif e.node.invalid? or not an?(e.node)
              acc.ta105(e, "R", "006", "is not a valid string")
            end
          end
        end

        # Interchange ID Qualifier
        edit(:ISA07) do
          isa.element(7).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "007", "must be present")
          # elsif not %w(27 28 ZZ).include?(e.node)
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "007", "has an invalid value")
            end
          end
        end

        # Interchange Receiver ID
        edit(:ISA08) do
          isa.element(8).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "008", "must be present")
          # elsif e.node.length != 15
          #   acc.ta105(e, "R", "008", "must have exactly 15 characters")
            end
          end
        end

        # Interchange Date
        edit(:ISA09) do
          isa.element(9).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "014", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "014", "is not a valid date")
            else
              # Convert to a proper 4-digit year, by making the assumption
              # that the date is less than 20 years old. Note we have to use
              # Object#send to work around an incorrectly declared private
              # method that wasn't fixed until after Ruby 1.8
              date = e.node.oldest(received.send(:to_date) << 12*30)

              if date > received.send(:to_date)
                acc.ta105(e, "R", "014", "must not be a future date")
              end
            end
          end
        end

        # Interchange Time
        edit(:ISA10) do
          isa.element(10).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "015", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "015", "is not a valid time")
            else
              isa.element(9).tap do |f|
                date = f.node.oldest(received.send(:to_date) << 12*30)

                if e.node.to_time(date) > received
                  acc.ta105(e, "R", "015", "must not be a future time")
                end
              end
            end
          end
        end

        # Repetition Separator
        edit(:ISA11) do
          isa.element(11).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "026", "must be present")
          # elsif e.node.length != 1
          #   acc.ta105(e, "R", "026", "must have exactly 1 character")
            end
          end
        end

        # Interchange Control Number
        edit(:ISA12) do
          isa.element(12).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "017", "must be present")
          # elsif e.node != "00501"
          #   # @todo: These ISA and IEA edits are all 00501-specific
          #   acc.ta105(e, "R", "017", "must be '00501'")
            end
          end
        end

        # Interchange Control Number
        edit(:ISA13) do
          isa.element(13).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "018", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "018", "must be numeric")
            elsif e.node <= 0
              acc.ta105(e, "R", "018", "must be positive")
          # elsif e.node.length != 9
          #   acc.ta105(e, "R", "018", "must have exactly 9 characters")
            end
          end
        end

        # Acknowledgment Requested
        edit(:ISA14) do
          isa.element(14).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "019", "must be present")
          # elsif not %w(0 1).include?(e.node)
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "019", "has an invalid value")
            end
          end
        end

        # Interchange Usage Indicator
        edit(:ISA15) do
          isa.element(15).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "020", "must be present")
          # elsif not %w(P T).include?(e.node)
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "020", "has an invalid value")
            end
          end
        end

        # Component Element Separator
        edit(:ISA16) do
          isa.element(16).tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "027", "must be present")
            elsif e.node.invalid? or not an?(e.node)
              acc.ta105(e, "R", "027", "is not a valid string")
            else
              isa.element(11).tap do |f|
                if e.node == f.node
                  acc.ta105(e, "R", "027", "must be distinct from repetition separator")
                end
              end
            end
          end
        end

        m, gs06s = isa.find(:GS), Hash.new{|h,k| h[k] = [] }
        # Collect all the GS06 elements within this interchange
        while m.defined?
          m = m.flatmap do |m|
            edit_gs(m, received, acc)

            m.element(6).tap{|e| gs06s[e.node.to_s] << e }
            m.find(:GS)
          end
        end

        # @todo: It's probably valid to send an interchange containing only TA1s
        edit(:GS) do
          if gs06s.blank?
            isa.segment.tap{|s| acc.ta105(s, "R", "024", "missing GS segment") }
          end
        end

        # Group Control Number
        edit(:GS06) do
          gs06s.each do |number, es|
            next if number.blank?
            es.tail.each do |e|
              acc.ak905(e, "R", "19", "must be unique within interchange")
            end
          end
        end

        iea = isa.find(:IEA)

        # @todo
        # acc.ta105(s, "024", "only one IEA segment is allowed")

        edit(:IEA) do
          unless iea.defined?
            isa.segment.tap{|s| acc.ta105(s, "023", "missing IEA segment") }
          end
        end

        # Number of Included Functional Groups
        edit(:IEA01) do
          iea.flatmap{|x| x.element(1) }.tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "021", "must be present")
            elsif e.node.invalid?
              acc.ta105(e, "R", "021", "must be numeric")
            elsif e.node != gs06s.length
              acc.ta105(e, "R", "021", "must equal the number of functional groups")
            end
          end
        end

        # Interchange Control Number
        edit(:IEA02) do
          iea.flatmap{|x| x.element(2) }.tap do |e|
            if e.node.blank?
              acc.ta105(e, "R", "001", "must be present")
            else
              isa.element(13).reject{|f| e.node == f.node }.tap do
                acc.ta105(e, "R", "001", "must match interchange header control number")
              end
            end
          end
        end

        return acc
      end

      def edit_gs(gs, received, acc)

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
          # elsif not e.node.length.between?(2, 15)
          #   acc.ak905(e, "R", "14", "must have 2-15 characters")
            elsif e.node.invalid? or not an?(e.node)
              acc.ak905(e, "R", "14", "is not a valid string")
            end
          end
        end

        # Application Receiver's Code
        edit(:GS03) do
          gs.element(3).tap do |e|
            if e.node.blank?
              acc.ak905(e, "R", "13", "must be present")
          # elsif not e.node.length.between?(2, 15)
          #   acc.ak905(e, "R", "13", "must have 2-15 characters")
            elsif e.node.invalid? or not an?(e.node)
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
            elsif e.node > received.send(:to_date)
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
              gs.element(4).tap do |f|
                if e.node.to_time(f.node) > received
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
            elsif e.node.invalid?
              acc.ta105(e, "R", "024", "is not a valid string")
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ta105(e, "R", "024", "has an invalid value")
            end
          end
        end

        # Version/Release/Industry Identifier Code
        edit(:GS08) do
          gs.element(8).tap do |e|
            if e.node.blank?
              acc.ak905(e, "R", "2", "must be present")
            else
              # @todo: The allowed value depends on the child transaction set
            end
          end
        end

        m, st02s = gs.find(:ST), Hash.new{|h,k| h[k] = [] }
        # Collect all the ST02 elements within this functional group
        while m.defined?
          m = m.flatmap do |m|
            edit_st(m, acc)

            m.element(2).tap{|e| st02s[e.node.to_s] << e }
            m.find(:ST)
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

        ge = gs.find(:GE)

        edit(:GE) do
          unless ge.defined?
            gs.segment.tap{|s| acc.ak905(s, "R", "3", "missing GE segment") }
          end
        end

        # Number of Transaction Sets Included
        edit(:GE01) do
          ge.flatmap{|x| x.element(1) }.tap do |e|
            if e.node.empty?
              acc.ak905(e, "R", "5", "must be present")
            elsif e.node.invalid?
              acc.ak905(e, "R", "5", "must be numeric")
            elsif e.node != st02s.length
              acc.ak905(e, "R", "5", "must equal the number of transactions")
            end
          end
        end

        # Group Control Number
        edit(:GE02) do
          ge.flatmap{|x| x.element(2) }.tap do |e|
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

      def edit_st(st, acc)
        # Note that ST is assumed to be the first segment in the transaction,
        # and while it's considered part of an envelope, each transaction set
        # definition can place different constraints on the ST and SE segments.
        #
        # This is why we have to check usage.required? and usage.forbidden? for
        # each element -- it depends on the transaction set definition.

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
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
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
            elsif e.node.usage.allowed_values.exclude?(e.node.to_s)
              acc.ik502(e, "R", "I6", "is not an allowed value")
            end
          end
        end

        se = st.find(:SE)

        edit(:SE) do
          # It seems reasonable enough to assume that SE is a required segment,
          # otherwise it's most likely to be defined incorrectly.
          unless se.defined?
            st.segment.tap{|s| acc.ik502(s, "R", "2", "missing SE segment") }
          end
        end

        edit(:SE01) do
          se.flatmap{|x| x.element(1) }.tap do |e|
            if e.node.empty?
              if e.node.usage.required?
                acc.ik502(e, "R", "4", "must be present")
              end
            elsif e.node.usage.forbidden?
              acc.ik502(e, "R", "4", "must not be present")
            elsif e.node.invalid?
              acc.ik502(e, "R", "4", "must be numeric")
            else
              se.flatmap{|x| st.distance(x) }.tap do |d|
                unless e.node == d + 1
                  acc.ik502(e, "R", "4", "must equal the transaction segment count")
                end
              end
            end
          end
        end

        edit(:SE02) do
          se.flatmap{|x| x.element(2) }.tap do |e|
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

    end

  end
end
