module Stupidedi
  module Editor

    class InterchangeAcknowledger

      def initialize(input, builder)
        @builder = builder
        @input   = input
      end

      def generate
        @builder.TA1(
          isa.element(13),
          isa.element(9),
          isa.element(10),
          acknowledgement_code,
          note_code)
        # 000: No error
        # 001: The Interchange Control Number in the Header and Trailer Do Not Match. The Value From the Header is Used in the Acknowledgement
        # 002: This Standard as Noted in the Control Standards Identifier is Not Supported
        # 003: This Version of the Controls is Not Supported
        # 004: The Segment Terminator is Invalid
        # 009: Unknown Interchange Receiver ID
        # 016: Invalid Interchange Standards Identifier Value
        # 021: Invalid Number of Included Groups Value
        # 022: Invalid Control Characters
        # 023: Improper (Premature) End-of-File (Transmission)
        # 024: Invalid Interchange Content (ex Invalid GS Segment)
        # 025: Duplicate Interchange Control Numbers
        # 028: Invalid Date in Deferred Delivery Request
        # 029: Invalid Time in Deferred Delivery Request
        # 030: Invalid Delivery Time Code in Deferred Delivery Request
        # 031: Invalid Grade of Service
      end

      def validate(isa)
        # If we're not already positioned on the ISA segment, fast-forward
        # to the next occurrence of the ISA segment. When there are no more
        # occurrences... @todo
        isa.segment.each do |s|
          unless s.node.id == :ISA
            isa.find(:ISA).each do |m|
              isa = m
            end
          end
        end

        edit(:ISA01) do
          isa.element(1).each do |e|
            if e.node.empty?
              ta105(e, "010", "must be present")
            elsif not %w(00 03).include?(e.node)
              ta105(e, "010", "has an invalid value")
            end
          end
        end

        edit(:ISA02) do
          isa.element(2).each do |e|
            if e.node.empty?
              ta105(e, "011", "must be present")
            elsif e.node.length != 10
              ta105(e, "011", "must have exactly 10 characters")
            elsif badchars?(e.node)
              ta105(e, "011", "has unacceptable AN characters")
            end
          end
        end

        edit(:ISA03) do
          isa.element(3).each do |e|
            if e.node.empty?
              ta105(e, "012", "must be present")
            elsif not %w(00 01).include?(e.node)
              ta105(e, "012", "has an invalid value")
            end
          end
        end

        edit(:ISA04) do
          isa.element(4).each do |e|
            if e.node.empty?
              ta105(e, "013", "must be present")
            elsif e.node.length != 10
              ta105(e, "013", "must have exactly 10 characters")
            elsif badchars?(e.node)
              ta105(e, "013", "has unacceptable AN characters")
            end
          end
        end

        edit(:ISA05) do
          isa.element(5).each do |e|
            if e.node.empty?
              ta105(e, "005", "must be present")
            elsif not %w(27 28 ZZ).include?(e.node)
              ta105(e, "005", "has an invalid value")
            end
          end
        end

        edit(:ISA06) do
          isa.element(6).each do |e|
            if e.node.empty?
              ta105(e, "006", "must be present")
            elsif badchars?(e.node)
              ta105(e, "006", "has unacceptable AN characters")
            end
          end
        end

        edit(:ISA07) do
          isa.element(7).each do |e|
            if e.node.empty?
              ta105(e, "007", "must be present")
            elsif not %w(27 28 ZZ).include?(e.node)
              ta105(e, "007", "has an invalid value")
            end
          end
        end

        edit(:ISA08) do
          isa.element(8).each do |e|
            if e.node.empty?
              ta105(e, "008", "must be present")
            elsif e.node.length != 15
              ta105(e, "008", "must have exactly 15 characters")
            end
          end
        end

        edit(:ISA09) do
          isa.element(9).each do |e|
            if e.node.empty?
              ta105(e, "014", "must be present")
            elsif e.node.valid?
              ta105(e, "014", "must be a valid date in YYMMDD format")
            else
              # Convert to a proper 4-digit year, by making the assumption
              # that the date is less than 20 years old. Note we have to use
              # Object#send to work around an incorrectly declared private
              # method that wasn't fixed until after Ruby 1.8
              date = e.node.oldest(Time.now.utc.send(:to_date) << 12*30)

              if date.to_time > Time.now.utc
                ta105(e, "014", "must not be a future date")
              end
            end
          end
        end

        edit(:ISA10) do
          isa.element(10).each do |e|
            if e.node.empty?
              ta105(e, "015", "must be present")
            elsif e.node.valid?
              ta105(e, "015", "must be a valid time in HHMM format")
            else
              isa.element(9).each do |f|
                date = f.node.oldest(Time.now.utc.send(:to_date) << 12*30)

                if e.node.to_time(date) > Time.now.utc
                  ta105(e, "015", "must not be a future time")
                end
              end
            end
          end
        end

        edit(:ISA11) do
          isa.element(11).each do |e|
            if e.node.empty?
              ta105(e, "026", "must be present")
            elsif e.node.length != 1
              ta105(e, "026", "must have exactly 1 character")
            end
          end
        end

        edit(:ISA12) do
          isa.element(12).each do |e|
            if e.node.empty?
              ta105(e, "017", "must be present")
            elsif e.node != "00501"
              ta105(e, "017", "must be '00501'")
            end
          end
        end

        edit(:ISA13) do
          isa.element(13).each do |e|
            if e.node.empty?
              ta105(e, "018", "must be present")
            elsif e.node.valid?
              ta105(e, "018", "must be numeric")
            elsif e.node <= 0
              ta105(e, "018", "must be positive")
            elsif e.node.length != 9
              ta105(e, "018", "must have exactly 9 characters")
            end
          end
        end

        edit(:ISA14) do
          isa.element(14).each do |e|
            if e.node.empty?
              ta105(e, "019", "must be present")
            elsif not %w(0 1).include?(e.node)
              ta105(e, "019", "has an invalid value")
            end
          end
        end

        edit(:ISA15) do
          isa.element(15).each do |e|
            if e.node.empty?
              ta105("020", "must be present")
            elsif %w(P T).include?(e.node)
              ta105("020", "has an invalid value")
            end
          end
        end

        edit(:ISA16) do
          isa.element(16).each do |e|
            if e.node.empty?
              ta105(e, "027", "must be present")
            elsif badchars?(e.node)
              ta105(e, "027", "has unacceptable AN characters")
            else
              isa.element(11).each do |f|
                if e.node == f.node
                  ta105(e, "027", "must be distinct from repetition separator")
                end
              end
            end
          end
        end

        m, gss = isa.find(:GS), []
        # Collect all the GS segments within this interchange
        while m.defined?
          m = m.flatmap do |m|
            gss << m
            m.find(:GS)
          end
        end

        m, ieas = isa.find(:IEA), []
        # Collect all the IEA segments within this interchange
        while m.defined?
          m = m.flatmap do |m|
            ieas << m
            m.find(:IEA)
          end
        end

        edit(:IEA) do
          if ieas.empty?
            isa.segment.each do |s|
              ta105(s, "023", "missing IEA segment")
            end
          elsif ieas.length > 1
            ieas.tail.each do |m|
              m.segment.each do |s|
                ta105(s, "024", "only one IEA segment is allowed")
              end
            end
          end
        end

        edit(:IEA01) do
          ieas.head.element(1).each do |e|
            if e.node.empty?
              ta105(e, "021", "must be present")
            elsif e.node.invalid?
              ta105(e, "021", "has an invalid value")
            elsif e.node != gss.length
              ta105(e, "021", "must equal number of functional groups")
            end
          end
        end if ieas.length == 1

        edit(:IEA02) do
          ieas.head.element(2).each do |e|
            if e.node.empty?
              ta105(e, "001", "must be present")
            else
              isa.element(13).each do |f|
                if e.node != f.node
                  ta105("001", "must match interchange header's control number")
                end
              end
            end
          end
        end if ieas.length == 1

      end
    end

  end
end
