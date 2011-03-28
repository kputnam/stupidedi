module Stupidedi
  module Editor

    #
    #
    #
    class FunctionalGroup

      def initialize(functional_group_val)
        config = Config.new
        config.interchange.register("00501") do
          Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef
        end

        config.functional_group.register("005010") do
          Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef
        end

        config.transaction_set.register("005010X231", "FA", "999") do
          Stupidedi::Guides::FiftyTen::X231::FA999
        end

        @builder  = Builder::BuilderDsl.new(config)
        @envelope = functional_group_val
      end

      def generate
        @builder.ISA("00", @builder.blank,
                     "00", @builder.blank,
                     "ZZ", "SUBMITTER ID",
                     "ZZ", "RECEIVER ID",
                     Time.now.utc,
                     Time.now.utc,
                     @builder.blank,
                     "00501",
                     123456789,
                     "1", "P", @builder.blank)

        @builder. GS("FA", "SENDER ID", "RECEIVER ID",
                     Time.now.utc, Time.now.utc,
                     234567890, "X", "005010X231")

        @builder. ST("999", 345678901, "005010X231")

        gs = @envelope.at(:GS).first
        gs = @envelope.at(:GE).first

        @builder.AK1(gs.at(0), # GS01: Functional Identifier Code
                     gs.at(5), # GS06: Group Control Number
                     gs.at(7)) # GS08: Industry Identifier Code

        received = 0
        accepted = 0
        numbers  = []

        @envelope.children.each do |node|
          next unless node.is_a?(Envelope::TransactionSetVal)
          received += 1
          accepted += 1

          # 1:  Transaction Set Not Supported
          # 6:  Missing or Invalid Transaction Set Identifier
          # I6: Implementation Convention Not Supported
          # 19: Invalid Transaction Set Implementation Convention Reference

          # 4:  Number of Included Segments Does Not Match Actual Content
          # 5:  One or More Segments in Error
          # 18: Transaction Set not in Functional Group
          # I5: Implementation One or More Segments In Error
          # 17: Security Not Supported

          st = node.at(:ST).first
          se = node.at(:SE).first

          @builder.AK2(st.at(0),  # ST01: Transaction Set Identifier Code
                       st.at(1),  # ST02: Transaction Set Control Number
                       st.at(2))  # ST03: Implementation Guide Version

          # First segment (ST) is numbered 1
          segment_pos = 0

          node.children.each do |s|
            segment_pos += 1

            # 1:  Unrecognized segment ID
            # 2:  Unexpected segment
            # 3:  Required Segment Missing
            # 4:  Loop Occurs Over Maximum Times
            # 5:  Segment Exceeds Maximum Use
            # 6:  Segment Not in Defined Transaction Set
            # 7:  Segment Not in Proper Sequence
            # 8:  Segment Has Data Element Errors
            # I4: Implementation 'Not Used' Segment Present
            # I6: Implementation Dependent Segment Missing
            # I7: Implementation Loop Occurs Under Minimum Times
            # I8: Implementation Segment Below Minimum Use
            # I9: Implementation Dependent 'Not Used' Segment Present
            @builder.IK3(s.id,        # Segment ID Code
                         segment_pos, # Segment Position in Transaction Set
                         nil,         # Loop Identifier Code
                         nil)         # Implementation Segment Syntax Error

            # Situational implementation guide segment-level triggers
            @builder.CTX(@builder.composite("SITUATIONAL TRIGGER"),
                         segment_id,
                         segment_pos,
                         ls.at(0),
                         @builder.composite(element_pos, component_pos, repeated_pos)
                         @builder.composite(element_id, component_id))

            # 269: TRN02
            # 270: TRN02
            # 271: TRN02
            # 274: NM109
            # 275: NM109 PATIENT NAME
            # 276: TRN02
            # 277: TRN02
            # 278: NM109 SUBSCRIBER NAME
            # 820: ENT01
            # 834: REF02 SUBSCRIBER NUMBER
            # 835: TRN02
            # 837: CLM01
            @builder.CTX(@builder.composite("CLM01", ""))

            s.children.each do |e|
              # 1:   Required Data Element Missing
              # 2:   Conditional Required Data Element Missing
              # 3:   Too Many Data Elements
              # 4:   Data Element Too Short
              # 5:   Data Element Too Long
              # 6:   Invalid Character In Data Element
              # 7:   Invalid Code Value
              # 8:   Invalid Date
              # 9:   Invalid Time
              # 10:  Exclusion Conditional Violated
              # 12:  Too Many Repetitions
              # 13:  Too Many Components
              # I6:  Code Value Not Used in Implementation
              # I9:  Implementation Dependent Data Element Missing
              # I10: Implementation 'Not Used' Data Element Present
              # I11: Implementation Too Few Repetitions
              # I12: Implementation Pattern Match Failure
              # I13: Implementation Dependent 'Not Used' Data Element Present
              @builder.IK4(@builder.composite(element_pos, component_pos, repeated_pos),
                           element_id,
                           nil, # Implementation Data Element Syntax Error
                           "")  # Copy of Bad Dala Element

              # Situational implementation guide element-level triggers
              @builder.CTX(@builder.composite("SITUATIONAL TRIGGER"),
                           segment_id,
                           segment_pos,
                           ls.at(0),
                           @builder.composite(element_pos, component_pos, repeated_pos)
                           @builder.composite(element_id, component_id))
            end
          end

          errors  = []
          errors << "7" if st.at(1).blank?
          errors << "2" if se.blank?
          errors << "3" if errors.blank? and st.at(1) != se.at(1)

          unless st.at(1).blank?
            errors  << "23" if numbers.include?(st.at(1).to_s)
            numbers << st.at(1).to_s
          end

          # A: Accepted
          # E: Accepted But Errors Were Reported
          # R: Rejected
          @builder.IK5("R", *errors.take(5))
        end

        # 1:  Functional Group Not Supported
        # 2:  Functional Group Version Not Supported

        # 5:  Number of Included Transaction Sets Does Not Match Actual Count
        # 16: Security Not Supported
        # 19: Functional Group Control Number not Unique within Interchange

        errors = []
        errors << "6" if gs.at(5).blank?
        errors << "3" if ge.blank?
        errors << "4" if errors.blank? and gs.at(5) != ge.at(0)

        # A: Accepted
        # E: Accepted, But Errors Were Noted
        # P: Partially Accepted, At Least One Transaction Set Was Rejected
        # R: Rejected
        @builder.AK9("P", received, received, accepted, *errors.take(5))
        @builder. SE(0, 345678901)
        @builder. GE(1, 234567890)
        @builder.ISE(1, 123456789)
      end
    end

  end
end
