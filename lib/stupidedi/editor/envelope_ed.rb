module Stupidedi
  module Editor

    #
    # Generates TA1, IK502, and AK905 results
    #
    class EnvelopeEd < AbstractEd

      declare :ISA01, :ISA02, :ISA03, :ISA04, :ISA05, :ISA06,
              :ISA07, :ISA08, :ISA09, :ISA10, :ISA11, :ISA12,
              :ISA13, :ISA14, :ISA15, :ISA16
      declare :IEA01, :IEA02, :IEA

      declare :GS, :GS01, :GS02, :GS03, :GS04, :GS05, :GS06, :GS07, :GS08
      declare :GE, :GE01, :GE02

      declare :ST, :ST01, :ST02, :ST03
      declare :SE, :SE01, :ST02

      def validate(m, received = Time.now.utc)
        # 000: No error
        # 002: This Standard as Noted in the Control Standards Identifier is Not Supported
        # 003: This Version of the Controls is Not Supported
        # 004: The Segment Terminator is Invalid
        # 009: Unknown Interchange Receiver ID
        # 016: Invalid Interchange Standards Identifier Value
        # 022: Invalid Control Characters
        # 025: Duplicate Interchange Control Numbers
        # 028: Invalid Date in Deferred Delivery Request
        # 029: Invalid Time in Deferred Delivery Request
        # 030: Invalid Delivery Time Code in Deferred Delivery Request
        # 031: Invalid Grade of Service
        @acc = ResultSet.new
        validate_isa(m, received)
      end

    private

      def badchars?(e)
        # @todo: this should be configurable, since some trading parters will
        # permit extended chars and others won't

        false
      end

      def validate_isa(isa, received)
        edit(:ISA01) do
          isa.element(1).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "010", "must be present")
            elsif not %w(00 03).include?(e.node)
              @acc.ta105(e, "R", "010", "has an invalid value")
            end
          end
        end

        edit(:ISA02) do
          isa.element(2).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "011", "must be present")
            elsif e.node.length != 10
              @acc.ta105(e, "R", "011", "must have exactly 10 characters")
            elsif badchars?(e.node)
              @acc.ta105(e, "R", "011", "has unacceptable AN characters")
            end
          end
        end

        edit(:ISA03) do
          isa.element(3).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "012", "must be present")
            elsif not %w(00 01).include?(e.node)
              @acc.ta105(e, "R", "012", "has an invalid value")
            end
          end
        end

        edit(:ISA04) do
          isa.element(4).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "013", "must be present")
            elsif e.node.length != 10
              @acc.ta105(e, "R", "013", "must have exactly 10 characters")
            elsif badchars?(e.node)
              @acc.ta105(e, "R", "013", "has unacceptable AN characters")
            end
          end
        end

        edit(:ISA05) do
          isa.element(5).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "005", "must be present")
            elsif not %w(27 28 ZZ).include?(e.node)
              @acc.ta105(e, "R", "005", "has an invalid value")
            end
          end
        end

        edit(:ISA06) do
          isa.element(6).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "006", "must be present")
            elsif badchars?(e.node)
              @acc.ta105(e, "R", "006", "has unacceptable AN characters")
            end
          end
        end

        edit(:ISA07) do
          isa.element(7).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "007", "must be present")
            elsif not %w(27 28 ZZ).include?(e.node)
              @acc.ta105(e, "R", "007", "has an invalid value")
            end
          end
        end

        edit(:ISA08) do
          isa.element(8).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "008", "must be present")
            elsif e.node.length != 15
              @acc.ta105(e, "R", "008", "must have exactly 15 characters")
            end
          end
        end

        edit(:ISA09) do
          isa.element(9).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "014", "must be present")
            elsif e.node.invalid?
              @acc.ta105(e, "R", "014", "must be a valid date in YYMMDD format")
            else
              # Convert to a proper 4-digit year, by making the assumption
              # that the date is less than 20 years old. Note we have to use
              # Object#send to work around an incorrectly declared private
              # method that wasn't fixed until after Ruby 1.8
              date = e.node.oldest(received.send(:to_date) << 12*30)

              if date > received.send(:to_date)
                @acc.ta105(e, "R", "014", "must not be a future date")
              end
            end
          end
        end

        edit(:ISA10) do
          isa.element(10).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "015", "must be present")
            elsif e.node.invalid?
              @acc.ta105(e, "R", "015", "must be a valid time in HHMM format")
            else
              isa.element(9).each do |f|
                date = f.node.oldest(received.send(:to_date) << 12*30)

                if e.node.to_time(date) > received
                  @acc.ta105(e, "R", "015", "must not be a future time")
                end
              end
            end
          end
        end

        edit(:ISA11) do
          isa.element(11).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "026", "must be present")
            elsif e.node.length != 1
              @acc.ta105(e, "R", "026", "must have exactly 1 character")
            end
          end
        end

        edit(:ISA12) do
          isa.element(12).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "017", "must be present")
            elsif e.node != "00501"
              @acc.ta105(e, "R", "017", "must be '00501'")
            end
          end
        end

        edit(:ISA13) do
          isa.element(13).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "018", "must be present")
            elsif e.node.invalid?
              @acc.ta105(e, "R", "018", "must be numeric")
            elsif e.node <= 0
              @acc.ta105(e, "R", "018", "must be positive")
          # elsif e.node.length != 9
          #   @acc.ta105(e, "R", "018", "must have exactly 9 characters")
            end
          end
        end

        edit(:ISA14) do
          isa.element(14).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "019", "must be present")
            elsif not %w(0 1).include?(e.node)
              @acc.ta105(e, "R", "019", "has an invalid value")
            end
          end
        end

        edit(:ISA15) do
          isa.element(15).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "020", "must be present")
            elsif not %w(P T).include?(e.node)
              @acc.ta105(e, "R", "020", "has an invalid value")
            end
          end
        end

        edit(:ISA16) do
          isa.element(16).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "027", "must be present")
            elsif badchars?(e.node)
              @acc.ta105(e, "R", "027", "has unacceptable AN characters")
            else
              isa.element(11).each do |f|
                if e.node == f.node
                  @acc.ta105(e, "R", "027", "must be distinct from repetition separator")
                end
              end
            end
          end
        end

        m, gs06s = isa.find(:GS), Hash.new{|h,k| h[k] = [] }
        # Collect all the GS06 elements within this interchange
        while m.defined?
          m = m.flatmap do |m|
            validate_gs(m, received)

            m.element(6).each{|e| gs06s[e.node.to_s] << e }
            m.find(:GS)
          end
        end

        edit(:GS) do
          if gs06s.blank?
            isa.segment.each{|s| @acc.ta105(s, "R", "024", "missing GS segment") }
          end
        end

        edit(:GS06) do
          gs06s.each do |number, es|
            next if number.blank?
            es.tail.each do |e|
              @acc.ak905(e, "R", "19", "must be unique within interchange")
            end
          end
        end

        iea = isa.find(:IEA)
        # @acc.ta105(s, "024", "only one IEA segment is allowed")

        edit(:IEA) do
          unless iea.defined?
            isa.segment.each{|s| @acc.ta105(s, "023", "missing IEA segment") }
          end
        end

        edit(:IEA01) do
          iea.flatmap{|x| x.element(1) }.each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "021", "must be present")
            elsif e.node.invalid?
              @acc.ta105(e, "R", "021", "has an invalid value")
            elsif e.node != gs06s.length
              @acc.ta105(e, "R", "021", "must equal the number of functional groups")
            end
          end
        end

        edit(:IEA02) do
          iea.flatmap{|x| x.element(2) }.each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "001", "must be present")
            else
              isa.element(13).each do |f|
                if e.node != f.node
                  @acc.ta105(e, "R", "001", "must match interchange header control number")
                end
              end
            end
          end
        end
      end

      def validate_gs(gs, received)
        edit(:GS01) do
          gs.element(1).each do |e|
            if e.node.blank?
              @acc.ak905(e, "R", "1", "must be present")
            else
              # @todo: the allowed value depends on the child transaction set
            end
          end
        end

        edit(:GS02) do
          gs.element(2).each do |e|
            if e.node.blank?
              @acc.ak905(e, "R", "14", "must be present")
            elsif not e.node.length.between?(2, 15)
              @acc.ak905(e, "R", "14", "must have 2-15 characters")
            elsif badchars?(e.node)
              @acc.ak905(e, "R", "14", "has unacceptable AN characters")
            end
          end
        end

        edit(:GS03) do
          gs.element(3).each do |e|
            if e.node.blank?
              @acc.ak905(e, "R", "13", "must be present")
            elsif not e.node.length.between?(2, 15)
              @acc.ak905(e, "R", "13", "must have 2-15 characters")
            elsif badchars?(e.node)
              @acc.ak905(e, "R", "13", "has unacceptable AN characters")
            end
          end
        end

        edit(:GS04) do
          gs.element(4).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "024", "must be present")
            elsif e.node.invalid?
              @acc.ta105(e, "R", "024", "must be a valid date in CCYYMMDD format")
            elsif e.node > received.send(:to_date)
              @acc.ta105(e, "R", "024", "must not be a future date")
            end
          end
        end

        edit(:GS05) do
          gs.element(5).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "024", "must be present")
            elsif e.node.invalid?
              @acc.ta105(e, "R", "024", "must be a valid time in HHMM format")
            else
              gs.element(4).each do |f|
                if e.node.to_time(f.node) > received
                  @acc.ta105(e, "R", "024", "must not be a future date")
                end
              end
            end
          end
        end

        edit(:GS06) do
          gs.element(6).each do |e|
            if e.node.blank?
              @acc.ak905(e, "R", "6", "must be present")
            elsif e.node.invalid?
              @acc.ak905(e, "R", "6", "has an invalid value")
            elsif e.node < 0
              @acc.ak905(e, "R", "6", "must be positive")
            elsif e.node > 999_999_999
              @acc.ak905(e, "R", "6", "is too long")
            end
          end
        end

        edit(:GS07) do
          gs.element(7).each do |e|
            if e.node.blank?
              @acc.ta105(e, "R", "024", "must be present")
            elsif e.node != "X"
              @acc.ta105(e, "R", "024", "has an invalid value")
            end
          end
        end

        edit(:GS08) do
          gs.element(8).each do |e|
            if e.node.blank?
              @acc.ak905(e, "R", "2", "must be present")
            else
              # @todo: the allowed value depends on the child transaction set
            end
          end
        end

        m, st02s = gs.find(:ST), Hash.new{|h,k| h[k] = [] }
        # Collect all the ST02 elements within this functional group
        while m.defined?
          m = m.flatmap do |m|
            validate_st(m)

            m.element(2).each{|e| st02s[e.node.to_s] << e }
            m.find(:ST)
          end
        end

        edit(:ST) do
          if st02s.empty?
            gs.segment.each{|s| @acc.ik502(s, "R", "1", "missing ST segment") }
          end
        end

        edit(:ST02) do
          st02s.each do |number, es|
            next if number.blank?
            es.tail.each do |e|
              @acc.ik502(e, "R", "23", "must be unique within functional group")
            end
          end
        end

        ge = gs.find(:GE)

        edit(:GE) do
          unless ge.defined?
            gs.segment.each{|s| @acc.ak905(s, "R", "3", "missing GE segment") }
          end
        end

        edit(:GE01) do
          ge.flatmap{|x| x.element(1) }.each do |e|
            if e.node.empty?
              @acc.ak905(e, "R", "5", "must be present")
            elsif e.node.invalid?
              @acc.ak905(e, "R", "5", "must be numeric")
            elsif e.node != st02s.length
              @acc.ak905(e, "R", "5", "must equal the number of transactions")
            end
          end
        end

        edit(:GE02) do
          ge.flatmap{|x| x.element(2) }.each do |e|
            if e.node.empty?
              @acc.ak905(e, "R", "4", "must be present")
            else
              gs.element(6).each do |f|
                if e.node != f.node
                  @acc.ak905(e, "R", "4", "must match functional group header control number")
                end
              end
            end
          end
        end
      end

      def validate_st(st)
        edit(:ST01) do
          st.element(1).each do |e|
            if e.node.blank?
              @acc.ik502(e, "R", "6", "must be present")
            elsif e.node != "837"
              @acc.ik502(e, "R", "6", "must be '837'")
            end
          end
        end

        edit(:ST02) do
          st.element(2).each do |e|
            if e.node.blank?
              @acc.ik502(e, "R", "7", "must be present")
            end
          end
        end

        se = st.find(:SE)

        edit(:SE) do
          unless se.defined?
            st.segment.each{|s| @acc.ik502(s, "R", "2", "missing SE segment") }
          end
        end

        edit(:SE01) do
          se.flatmap{|x| x.element(1) }.each do |e|
            if e.node.empty?
              @acc.ik502(e, "R", "4", "must be present")
            elsif e.node.invalid?
              @acc.ik502(e, "R", "4", "must be numeric")
            else
            # st.distance(:SE).each do |d|
            #   unless e.node == d + 1
            #     ak502(e, "R", "4", "must equal the transaction segment count")
            #   end
            # end
            end
          end
        end

        edit(:SE02) do
          se.flatmap{|x| x.element(2) }.each do |e|
            if e.node.empty?
              @acc.ik502(e, "R", "3", "must be present")
            else
              st.element(2).each do |f|
                if e.node != f.node
                  @acc.ik502(e, "R", "3", "must equal transaction header control number")
                end
              end
            end
          end
        end
      end

    end

  end
end
