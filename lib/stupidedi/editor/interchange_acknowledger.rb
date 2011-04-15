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
        # 005: Invalid Interchange ID Qualifier for Sender
        # 006: Invalid Interchange Sender ID
        # 007: Invalid Interchange ID Qualifier for Receiver
        # 008: Invalid Interchange Receiver ID
        # 009: Unknown Interchange Receiver ID
        # 010: Invalid Authorization Information Qualifier Value
        # 011: Invalid Authorization Information Value
        # 012: Invalid Security Information Qualifier Value
        # 013: Invalid Security Information Value
        # 014: Invalid Interchange Date Value
        # 015: Invalid Interchange Time Value
        # 016: Invalid Interchange Standards Identifier Value
        # 017: Invalid Interchange Version ID Value
        # 018: Invalid Interchange Control Number Value
        # 019: Invalid Acknowledgement Requested Value
        # 020: Invalid Test Indicator Value
        # 021: Invalid Number of Included Groups Value
        # 022: Invalid Control Characters
        # 023: Improper (Premature) End-of-File (Transmission)
        # 024: Invalid Interchange Content (ex Invalid GS Segment)
        # 025: Duplicate Interchange Control Numbers
        # 026: Invalid Data Structure Separator
        # 027: Invalid Component Element Separator
        # 028: Invalid Date in Deferred Delivery Request
        # 029: Invalid Time in Deferred Delivery Request
        # 030: Invalid Delivery Time Code in Deferred Delivery Request
        # 031: Invalid Grade of Service
      end

      def validate(machine)
        machine.segment.map do |s|
          case s.id
          when :ISA
            edit("ISA01") do
              if s.element(1).empty?
                TA105("010", "ISA01 must be present")
              elsif not %w(00 03).include?(s.element(1))
                TA105("010", "ISA01 has an invalid value")
              end
            end

            edit("ISA02") do
              if s.element(2).empty?
                TA105("011", "ISA02 must be present")
              elsif s.element(2).length != 10
                TA105("011", "ISA02 must have exactly 10 characters")
              elsif badchars?(s.element(2))
                TA105("011", "ISA02 has unacceptable AN characters")
              end
            end

            edit("ISA03") do
              if s.element(3).empty?
                TA105("ISA03 must be present")
              elsif not %w(00 01).include?(s.element(3))
                TA105("012", "ISA03 has an invalid value")
              end
            end

            edit("ISA04") do
              if s.element(4).empty?
                TA105("ISA04 must be present")
              elsif s.element(4).length != 10
                TA105("013", "ISA04 must have exactly 10 characters")
              elsif badchars?(s.element(4))
                TA105("013", "ISA04 has unacceptable AN characters")
              end
            end

            edit("ISA05") do
              if s.element(5).empty?
                TA105("005", "ISA05 must be present")
              elsif not %w(27 28 ZZ).include?(e.element(5))
                TA105("005", "ISA05 has an invalid value")
              end
            end

            edit("ISA06") do
              if s.element(6).empty?
                TA105("006", "ISA06 must be present")
              elsif badchars?(s.element(6))
                TA105("006", "ISA06 has unacceptable AN characters")
              end
            end

            edit("ISA07") do
              if s.element(7).empty?
                TA105("007", "ISA07 must be present")
              elsif not %w(27 28 ZZ).include?(s.element(7))
                TA105("007", "ISA07 has an invalid value")
              end
            end

            edit("ISA08") do
              if s.element(8).empty?
                TA105("008", "ISA08 must be present")
              elsif s.element(8).length != 15
                TA105("008", "ISA08 must have exactly 15 characters")
              end
            end

            edit("ISA09") do
              if s.element(9).empty?
                TA105("014", "ISA09 must be present")
              elsif s.element(9).valid?
                TA105("014", "ISA09 must be a valid date in YYMMDD format")
              else
                # Convert to a proper 4-digit year, by making the assumption
                # that the date is less than 20 years old. Note we have to use
                # Object#send to work around an incorrectly declared private
                # method that wasn't fixed until after Ruby 1.8
                date = s.element(9).oldest(Time.now.utc.send(:to_date) << 12*30)

                if date.to_time > Time.now.utc
                  TA105("014", "ISA09 must not be a future date")
                end
              end
            end

            edit("ISA10") do
              if s.element(10).empty?
                TA105("015", "ISA10 must be present")
              elsif s.element(10).valid?
                TA105("015", "ISA10 must be a valid time in HHMM format")
              elsif s.element(10).to_time(date) > Time.now.utc
                TA105("015", "ISA10 must not be a future time")
              end
            end

            edit("ISA11") do
              if s.element(11).empty?
                TA105("024", "ISA11 must be present")
              elsif s.element(11).length != 1
                TA105("024", "ISA11 must have exactly 1 character")
              end
            end

            edit("ISA12") do
              if s.element(12).empty?
                TA105("017", "ISA12 must be present")
              elsif s.element(12) != "00501"
                TA105("017", "ISA12 must be '00501'")
              end
            end

            edit("ISA13") do
              if s.element(13).empty?
                TA105("018", "ISA13 must be present")
              elsif s.element(13).valid?
                TA105("018", "ISA13 must be numeric")
              elsif s.element(13) <= 0
                TA105("018", "ISA13 must be positive")
              elsif s.element(13).length != 9
                TA105("018", "ISA13 must have exactly 9 characters")
              end
            end

            edit("ISA14") do
              if s.element(14).empty?
                TA105("019", "ISA14 must be present")
              elsif not %w(0 1).include?(s.element(14))
                TA105("019", "ISA14 has an invalid value")
              end
            end

            edit("ISA15") do
              if s.element(15).empty?
                TA105("020", "ISA15 must be present")
              elsif %w(P T).include?(s.element(15))
                TA105("020", "ISA15 has an invalid value")
              end
            end

            edit("ISA16") do
              if s.element(16).empty?
                TA105("027", "ISA16 must be present")
              elsif badchars?(s.element(16))
                TA105("027", "ISA16 has unacceptable AN characters")
              elsif s.element(16) == s.element(11)
                TA105("027", "ISA16 must be distinct from ISA15")
              end
            end

          when :ISB
          when :ISE
          when :TA1
          when :ISE
          end
        end
      end
    end

  end
end
