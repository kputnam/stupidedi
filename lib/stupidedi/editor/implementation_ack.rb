# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Editor

    # Generates an FA 999 acknowledgement
    class ImplementationAck

      def initialize(zipper, builder)
        @builder = builder
        @zipper  = zipper
      end

      def generate
        @builder.ST("999", @builder.blank, "005010X231")

        # GS01, GS06, and GS08 must all be present and valid. It is not clear
        # how to respond when these elements are not valid (eg not an allowed
        # value, not a number, too longo too short, etc) because copying the
        # value to AK1 generates an invalid AK1 segment.
        @builder.AK1(gs.element(1), # GS01: Functional Identifier
                     gs.element(6), # GS06: Group Control Number
                     gs.element(8)) # GS08: Industry Identifier

          # ST01, ST02, and ST03 must all be present and valid. Like the AK1/GS
          # paradox, there isn't a way to generate a valid response when the
          # elements being acknowledged are not valid.
          @builder.AK2(st.element(1), # ST01: Transaction Set Identifier Code
                       st.element(2), # ST02: Transaction Set Control Number
                       st.element(3)) # ST03: Implementation Guide Version

            # M ID(2/3), M N0(1/10), O AN(1/4), O ID(1/3)
            @builder.IK3(segment_id, segment_pos, loop_id, error_code)
            #  1: Unrecoginzed segment ID
            #  2: Unexpected segment
            #  3: Required segment missing
            #  4: Loop occurs over maximum times
            #  5: Segment exceeds maximum use
            #  6: Segment not defined in transaction set
            #  7: Segment not in proper sequence
            #  8: Segment has data element errors
            # I4: Implementation "not used" segment present
            # I6: Implementation situationally required segment missing
            # I7: Implementation loop occurs under minimum times
            # I8: Implementation segment below minimum use
            # I9: Implementation situationally "not used" segment present

          ### Required when IK304 = "I..."
          ##@builder.CTX(
          ##  @builder.composite("SITUATIONAL TRIGGER"),
          ##  segment_id,
          ##  segment_pos,
          ##  loop_id,
          ##  # Following two composites are required if the failed requirement
          ##  # relates to an individual element, otherwise do not send
          ##  @builder.composite(element_pos, component_pos, repeated_pos),
          ##  @builder.composite(element_ref, component_ref))

          ##@builder.CTX(
          ### @builder.composite("TRN02", trn.element(2))
          ### @builder.composite("NM109", nm1.element(9))
          ### @builder.composite("ENT01", ent.element(1))
          ### @builder.composite("REF02", ref.element(2))
          ### @builder.composite("CLM01", clm.element(1)))

              # M C030, O N0(1/4), M ID(1/3), O AN(1/99)
              @builder.IK4(
                @builder.composite(element_pos, component_pos, repeated_pos),
                element_ref,
                error_code,
                element_data)
              # Required when IK304 = "8"
              #   1: Required data element missing
              #   2: Conditional required data element missing
              #   3: Too many data elements
              #   4: Data element too short
              #   5: Data element too long
              #   6: Invalid character in data element
              #   7: Invalid code value
              #   8: Invalid date
              #   9: Invalid time
              #  10: Exclusion condition violated
              #  12: Too many repetitions
              #  13: Too many components
              # I10: Implementation "not used" data element present
              # I11: Implementation too few repetitions
              # I12: Implementation pattern match failure
              # I13: Implementation situationally "not used" data element present
              #  I6: Code value not used in implementation
              #  I9: Implementation situationally required data element missing

            ### Required when IK404 = "I..."
            ##@builder.CTX(
            ##  @builder.composite("SITUATIONAL TRIGGER"),
            ##  segment_id,
            ##  segment_pos,
            ##  loop_id,
            ##  @builder.composite(element_pos, component_pos, repeated_pos),
            ##  @builder.composite(element_ref, component_ref))


          @builder.IK5(
            acknowledgement_code,
            error_code,
            error_code,
            error_code,
            error_code,
            error_code)
          # A: Accepted
          # E: Accepted but errors were noted
          # R: Rejected
          #
          #  1: Transaction set not supported
          #  2: Transaction set trailer missing
          #  3: Transaction set control number in header and trailer do not match
          #  4: Number of included segments does not match actual count
          #  5: One or more segments in error
          #  6: Missing or invalid transaction set identifier
          #  7: Missing or invalid transaction set control number
          # 17: Security not supported
          # 18: Transaction set not in functional group
          # 19: Invalid transaction set implementation convention reference
          # 23: Transaction set control number not unique within the functional group
          # I5: Implementation one or more segments in error
          # I6: Implementation convention not supported

        @builder.AK9(
          acknowledgement_code,
          included_count,
          received_count,
          accepted_count,
          error_code,
          error_code,
          error_code,
          error_code,
          error_code)
        # A: Accepted
        # E: Accepted, but errors were found
        # P: Partially accepted, at least one transaction set was rejected
        # R: Rejecetd
        #
        #  1: Funcitonal group not supported
        #  2: Functional group version not supported
        #  3: Funcitonal group trailer missing
        #  4: Group control number in the functional group header and trailer do not agree
        #  5: Number of included transaction sets does not match actual count
        #  6: Group control number violates syntax
        # 16: Security not supported
        # 19: Functional group control number not unique within interchange

        @builder.ST(count, @builder.blank)
      end

    private

      def validate(node)
        if node.element?
          if node.simple?
            unless node.valid?
              # 6: Invalid character in data element
              # 8: Invalid date
              # 9: Invalid time
            end
              #   3: Too many data elements
              # I10: Implementation "not used" data element present
              # I11: Implementation too few repetitions
              # I12: Implementation pattern match failure
              #  I6: Code value not used in implementation

            if node.empty?
              #   1: Required data element missing
              #   2: Conditional required data element missing
              #  I9: Implementation situationally required data element missing
            else
              #  10: Exclusion condition violated
              # I13: Implementation situationally "not used" data element present

              if node.too_long?
                # 5: Data element too long
              elsif node.too_short?
                # 4: Data element too short
              end

              # 7: Invalid code value
              unless node.allowed?
              end
            end
          elsif node.repeated?
              # 12: Too many repetitions
          elsif node.composite?
              # 13: Too many components
          end
        elsif node.segment?
          if node.valid?
          else
            #  1: Unrecoginzed segment ID
            #  2: Unexpected segment
            #  6: Segment not defined in transaction set
            #  7: Segment not in proper sequence
            # I4: Implementation "not used" segment present
          end
            #  3: Required segment missing
            #  4: Loop occurs over maximum times
            #  5: Segment exceeds maximum use
            #  8: Segment has data element errors
            # I6: Implementation situationally required segment missing
            # I7: Implementation loop occurs under minimum times
            # I8: Implementation segment below minimum use
            # I9: Implementation situationally "not used" segment present
        end
      end
    end

  end
end
