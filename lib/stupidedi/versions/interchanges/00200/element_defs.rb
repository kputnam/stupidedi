module Stupidedi
  module Versions
    module Interchanges
      module TwoHundred

        #
        # @see FunctionalGroups::FortyTen::ElementTypes
        # @see Schema::CodeList
        #
        module ElementDefs

          # Import definitions of DT, R, ID, Nn, AN, TM, and SimpleElementDef
          t = FunctionalGroups::FortyTen::ElementTypes
          s = Schema

          # Namespace workaround for SpecialAN inner classes
          T = t

          # Fun (stupid) problem. The specifications declare ISA02 and ISA04 are
          # required elements, but they only have "meaningful information" when
          # ISA01 and ISA03 qualifiers aren't "00".
          #
          # Without specifications regarding what should be entered in these
          # required elements, our best option is to defer to convention, which
          # seems to be that these elements should have 10 spaces -- which means
          # they're blank. So we can't really make these elements required! Even
          # stupider, these are the only blank elements that should be written
          # out space-padded to the min_length -- every other element should be
          # collapsed to an empty string.
          #
          # So this "Special" class overrides to_x12 for empty values, but it
          # otherwise looks and acts like a normal AN and StringVal
          class SpecialAN < t::AN
            def companion
              SpecialVal
            end

            class SpecialVal < T::StringVal
              class Empty < T::StringVal::Empty
                # @return [String]
                def to_x12
                  " " * definition.min_length
                end
              end

              class NonEmpty < T::StringVal::NonEmpty
                def too_short?
                  false
                end
              end
            end
          end

          class SeparatorElementVal < Values::SimpleElementVal

            delegate :to_s, :length, :to => :@value

            def initialize(value, usage, position)
              @value = value
              super(usage, position)
            end

            # @return [SeparatorElementVal]
            def copy(changes = {})
              SeparatorElementVal.new \
                changes.fetch(:value, @value),
                changes.fetch(:usage, usage),
                changes.fetch(:position, position)
            end

            def valid?
              true
            end

            def empty?
              @value.blank?
            end

            def too_short?
              @value.length < 1
            end

            def too_long?
              @value.length > 1
            end

            def separator?
              true
            end

            # @return [String]
            def to_x12
              @value.to_s
            end

            def inspect
              id = definition.try{|d| ansi.bold("[#{d.id}]") }
              ansi.element("SeparatorElementVal.value#{id}") << "(#{@value || "nil"})"
            end
          end

          class << SeparatorElementVal
            # @group Constructors
            ###################################################################

            # @raise NoMethodError
            def empty(usage, position)
              SeparatorElementVal.new(nil, usage, position)
            end

            # @return [SeparatorElementVal]
            def value(character, usage, position)
              SeparatorElementVal.new(character, usage, position)
            end

            # @return [SeparatorElementVal]
            def parse(character, usage, position)
              SeparatorElementVal.new(character, usage, position)
            end

            # @endgroup
            ###################################################################
          end

          I01 = t::ID.new(:I01, "Authorization Information Qualifier",    2,  2,
            s::CodeList.build(
              "00" => "No Authorization Information Present (No Meaningful Information in I02)",
            # "01" => "UCS Communications ID",
            # "02" => "EDX Communications ID",
              "03" => "Additional Data Identification"))
            # "04" => "Rail Communication ID",
            # "05" => "Deparment of Defense (DoD) Communication Identifier",
            # "06" => "United States Federal Government Communication Identifier"))

          I02 = SpecialAN.new(:I02, "Authorization Information",             10, 10)

          I03 = t::ID.new(:I03, "Security Information Qualifier",         2,  2,
            s::CodeList.build(
              "00" => "No Security Information (No Meaningful Information in I04)",
              "01" => "Password"))

          I04 = SpecialAN.new(:I04, "Security Information",                  10, 10)

          I05 = t::ID.new(:I05, "Interchange ID Qualifier",               2,  2,
            s::CodeList.build(
              "01" => "Duns (Dun & Bradstreet)",
              "02" => "SCAC (Standard Carrier Alpha Code)",
            # "03" => "FMC (Federal Maritime Commission)",
            # "04" => "IATA (International Air Transport Association)",
            # "07" => s::CodeList.external("583"),
            # "08" => "UCC EDI Communications ID (Comm ID)",
            # "09" => "X.121 (CCITT)",
            # "10" => s::CodeList.external("350"),
            # "11" => "DEA (Drug Enforcement Administration)",
              "12" => "Phone (Telephone Companies)",
            # "13" => "UCS Code (The UCS Code is a Code Used for UCS Transmissions; it includes the Area Code and Telephone Number of a Modem; it Does Not Include Punctation, Blanks, or Access Code)",
              "14" => "Duns Plus Suffix",
            # "15" => "Petroleum Accountants Society of Canada Company Code",
              "16" => "Duns Number With 4-Character Suffix",
            # "17" => "American Bankers Association (ABA) Transit Routing Number (Including Check Digit, 9 Digit)",
            # "18" => s::CodeList.external("420"),
            # "19" => s::CodeList.external("421"),
              "20" => s::CodeList.external("121"),
            # "21" => s::CodeList.external("422"),
            # "22" => s::CodeList.external("423"),
            # "23" => s::CodeList.external("424"),
            # "24" => s::CodeList.external("425"),
            # "25" => s::CodeList.external("426"),
            # "26" => s::CodeList.external("296", "300"),
              "27" => "Carrier Identification Number as assigned by Health Care Financing Administration (HCFA)",
              "28" => "Fiscal Intermediary Identification Number as assigned by Health Care Financing Administration (HCFA)",
              "29" => "Medicare Provider and Supplier Identification Number as assigned by Health Care Financing Administration (HCFA)",
              "30" => "US Federal Tax Identification Number",
            # "31" => "Jurisdiction Identification Number Plus 4 as assigned by the Interational Association of Industrial Accident Boards and Commissions (IAIABC)",
            # "32" => "US Federal Employer Identification Number (FEIN)",
              "33" => "National Association of Insurance Commissioners Company Code (NAIC)",
            # "34" => "Medicaid Provider and Supplier Identification Number as assigned by individual State Medicaid Agencies in conjunction with Health Care Financing Administration (HCFA)",
            # "35" => "Statistics Canada Canadian College Student Information System Institution Codes",
            # "36" => s::CodeList.external("300"),
            # "37" => s::CodeList.external("573"),
            # "38" => s::CodeList.external("862"),
            # "AM" => s::CodeList.external("497"),
            # "NR" => "National Retail Merchants Association (NRMA) Assigned",
            # "SA" => s::CodeList.external("851"),
            # "SN" => s::CodeList.external("42"),
              "ZZ" => "Mutually Defined"))

          I06 = SpecialAN.new(:I06, "Interchange Sender ID",                 15, 15)
          I07 = SpecialAN.new(:I07, "Interchange Receiver ID",               15, 15)
          I08 = t::DT.new(:I08, "Interchange Date",                       6,  6)
          I09 = t::TM.new(:I09, "Interchange Time",                       4,  4)

          I10 = t::ID.new(:I10, "Interchange Control Standards Identifier", 1, 1,
            s::CodeList.build(
              "U" => "U.S. EDI Community of ASC X12, TDCC, and UCS"))

          I11 = t::ID.new(:I11, "Interchange Control Version Number",     5,  5,
            s::CodeList.build(
              "00200" => "Standard Issued as ANSI X12.5-1987",
              "00301" => "Draft Standard for Trial Use Approved for Publication by ASC X12 Procedures Review Board Through October 1990",
              "00304" => "Draft Standards for Trial Use Approved for Publication by ASC X12 Procedures Review Board through October 1993",
              "00305" => "Draft Standards for Trial Use Approved for Publication by ASC X12 Procedures Review Board through October 1994",
              "00401" => "Draft Standards for Trial Use Approved for Publication by ASC X12 Procedures Review Board through October 1997"))

          I12 = t::Nn.new(:I12, "Interchange Control Number",             9,  9, 0)

          I13 = t::ID.new(:I13, "Acknowledgment Requested",               1,  1,
            s::CodeList.build(
              "0" => "No Interchange Acknowledgment Requested",
              "1" => "Interchange Acknowledgment Requested (TA1)",
              "2" => "Interchange Acknowledgment Requested only when Interchange is \"Rejected Because Of Errors\"",
              "3" => "Interchange Acknowledgment Requested only when Interchange is \"Rejected Because Of Errors\" or \"Accepted but Errors are Noted\""
              ))

          I14 = t::ID.new(:I14, "Interchange Usage Indicator",            1,  1,
            s::CodeList.build(
            # "I" => "Information",
              "P" => "Production Data",
              "T" => "Test Data"))

          I15 = Class.new(t::SimpleElementDef) do
            def companion
              SeparatorElementVal
            end
          end.new(:I15, "Component Element Separator",                    1,  1)

          I16 = t::Nn.new(:I16, "Number of Included Functional Groups",   1,  5, 0)

          I17 = t::ID.new(:I17, "Interchange Acknowledgement Code",       1,  1,
            s::CodeList.build(
              "A" => "The Transmitted Interchange Control Structure Header and Trailer Have Been Received and Have No Errors",
              "E" => "The Transmitted Interchange Control Structure Header and Trailer Have Been Received and Are Accepted But Errors Are Noted. This Means the Sender Must Not Resend the Data.",
              "R" => "The Transmitted Interchange Control Structure Header and Trailer are Rejected Because of Errors"))

          I18 = t::ID.new(:I18, "Interchange Note Code",                  3,  3,
            s::CodeList.build(
              "000" => "No error",
              "001" => "The Interchange Control Number in the Header and Trailer Do Not Match. The Value From the Header is Used in the Acknowledgement",
              "002" => "This Standard as Noted in the Control Standards Identifier is Not Supported",
              "003" => "This Version of the Controls is Not Supported",
              "004" => "The Segment Terminator is Invalid",
              "005" => "Invalid Interchange ID Qualifier for Sender",
              "006" => "Invalid Interchange Sender ID",
              "007" => "Invalid Interchange ID Qualifier for Receiver",
              "008" => "Invalid Interchange Receiver ID",
              "009" => "Unknown Interchange Receiver ID",
              "010" => "Invalid Authorization Information Qualifier Value",
              "011" => "Invalid Authorization Information Value",
              "012" => "Invalid Security Information Qualifier Value",
              "013" => "Invalid Security Information Value",
              "014" => "Invalid Interchange Date Value",
              "015" => "Invalid Interchange Time Value",
              "016" => "Invalid Interchange Standards Identifier Value",
              "017" => "Invalid Interchange Version ID Value",
              "018" => "Invalid Interchange Control Number Value",
              "019" => "Invalid Acknowledgement Requested Value",
              "020" => "Invalid Test Indicator Value",
              "021" => "Invalid Number of Included Groups Value",
              "022" => "Invalid Control Characters",
              "023" => "Improper (Premature) End-of-File (Transmission)",
              "024" => "Invalid Interchange Content (ex Invalid GS Segment)",
              "025" => "Duplicate Interchange Control Numbers",
              "026" => "Invalid Data Structure Separator",
              "027" => "Invalid Component Element Separator",
              "028" => "Invalid Date in Deferred Delivery Request",
              "029" => "Invalid Time in Deferred Delivery Request",
              "030" => "Invalid Delivery Time Code in Deferred Delivery Request",
              "031" => "Invalid Grade of Service"))

        end
      end
    end
  end
end
