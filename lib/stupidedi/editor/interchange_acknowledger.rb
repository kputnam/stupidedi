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

    end

  end
end
