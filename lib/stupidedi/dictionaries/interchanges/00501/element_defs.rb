module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        #
        # @see FunctionalGroups::FiftyTen::ElementTypes
        # @see Schema::CodeList
        #
        module ElementDefs

          # Import definitions of B, DT, R, ID, Nn, AN, TM, and SimpleElementDef
          t = FunctionalGroups::FiftyTen::ElementTypes
          s = Schema

          class SeparatorElementVal < Values::SimpleElementVal

            delegate :to_s, :to => :@value

            def initialize(value, definition, usage)
              @value = value
              super(definition, usage)
            end

            # @return [SeparatorElementVal]
            def copy(changes = {})
              SeparatorElementVal.new \
                changes.fetch(:value, @value),
                changes.fetch(:definition, definition),
                changes.fetch(:usage, usage)
            end

            def inspect
              id = definition.try{|d| "[#{d.id}]" }
              "SeparatorElementVal.value#{id}(#{@value})"
            end
          end

          class << SeparatorElementVal

            ###################################################################
            # @group Constructor Methods

            # @raise NoMethodError
            def empty(definition, usage)
              raise NoMethodError, "@todo"
            end

            # @return [SeparatorElementVal]
            def value(character, definition, usage)
              SeparatorElementVal.new(character, definition, usage)
            end

            # @return [SeparatorElementVal]
            def parse(character, definition, usage)
              SeparatorElementVal.new(character, definition, usage)
            end

            # @endgroup
            ###################################################################
          end

          I01 = t::ID.new(:I01, "Authorization Information Qualifier",    2,  2,
            s::CodeList.build(
              "00" => "No Authorization Information Present (No Meaningful Information in I02)",
              "03" => "Additional Data Identification"))

          I02 = t::AN.new(:I02, "Authorization Information",             10, 10)

          I03 = t::ID.new(:I03, "Security Information Qualifier",         2,  2,
            s::CodeList.build(
              "00" => "No Security Information (No Meaningful Information in I04)",
              "01" => "Password"))

          I04 = t::AN.new(:I04, "Security Information",                  10, 10)

          I05 = t::ID.new(:I05, "Interchange ID Qualifier",               2,  2,
            s::CodeList.build(
              "01" => "Duns (Dun & Bradstreet)",
              "02" => "SCAC (Standard Carrier Alpha Code)",
              "03" => "FMC (Federal Maritime Commission)",
              "04" => "IATA (International Air Transport Association)",
              "07" => "Global Location Number (GLN)",
              "08" => "UCC EDI Communications ID (Comm ID)",
              "09" => "X.121 (CCITT)",
              "10" => "Department of Defense (DoD) Activity Address Code",
              "11" => "DEA (Drug Enforcement Administration)",
              "12" => "Phone (Telephone Companies)",
              "13" => "UCS Code (The UCS Code is a Code Used for UCS Transmissions; it includes the Area Code and Telephone Number of a Modem; it Does Not Include Punctation, Blanks, or Access Code)",
              "14" => "Duns Plus Suffix",
              "15" => "Petroleum Accountants Society of Canada Company Code",
              "16" => "Duns Number With 4-Character Suffix",
              "17" => "American Bankers Association (ABA) Transit Routing Number (Including Check Digit, 9 Digit)",
              "18" => "Association of American Railroads (AAR) Standard Distribution Code",
              "19" => "EDI Council of Australia (EDICA) Communications ID Number (COMM ID)",
              "20" => s::CodeList.external("121"),
              "21" => "Integrated Postsecondary Education Data System, or (IPEDS)",
              "22" => "Federal Interagency Commission on Education, or FICE",
              "23" => "National Center for Education Statistics Common Core of Data 12-Digit Number of Pre-K-Grade 12 institutes, or NCES",
              "24" => "The College Board's Admission Testing Program 4-Digit Code of Postsecondary Institutes, or ATP",
              "25" => "ACT, Inc. 4-Digit Code of Postsecondary Institutions",
              "26" => "Statistics of Canada List of Postsecondary Institutions",
              "27" => "Carrier Identification Number as assigned by Health Care Financing Administration (HCFA)",
              "28" => "Fiscal Intermediary Identification Number as assigned by Health Care Financing Administration (HCFA)",
              "29" => "Medicare Provider and Supplier Identification Number as assigned by Health Care Financing Administration (HCFA)",
              "30" => "US Federal Tax Identification Number",
              "31" => "Jurisdiction Identification Number Plus 4 as assigned by the Interational Association of Industrial Accident Boards and Commissions (IAIABC)",
              "32" => "US Federal Employer Identification Number (FEIN)",
              "33" => "National Association of Insurance Commissioners Company Code (NAIC)",
              "34" => "Medicaid Provider and Supplier Identification Number as assigned by individual State Medicaid Agencies in conjunction with Health Care Financing Administration (HCFA)",
              "35" => "Statistics Canada Canadian College Student Information System Institution Codes",
              "36" => "Statistics Canada University Student Information System Instution Codes",
              "37" => "Society of Property Information Compilers and Analysts",
              "38" => "The College Board and ACT, Inc 6-Digit Code List of Secondary Information",
              "AM" => "Association Mexicana del Codigo de Producto (AMECOP) Communication ID",
              "NR" => "National Retail Merchants Association (NRMA) Assigned",
              "SA" => "User Identification Number as assigned by the Safety and Fitness Electronic Records (SAFER) System",
              "SN" => "Standard Address Number",
              "ZZ" => "Mutually Defined"))

          I06 = t::AN.new(:I06, "Interchange Sender ID",                 15, 15)
          I07 = t::AN.new(:I07, "Interchange Receiver ID",               15, 15)
          I08 = t::DT.new(:I08, "Interchange Date",                       6,  6)
          I09 = t::TM.new(:I09, "Interchange Time",                       4,  4)

          I11 = t::ID.new(:I11, "Interchange Control Version Number",     5,  5,
            s::CodeList.build(
              "00501" => "Standards Approved for Publication by ASC X12 Procedures Review Board through October 2003"))

          I12 = t::Nn.new(:I12, "Interchange Control Number",             9,  9, 0)

          I13 = t::ID.new(:I13, "Acknowledgment Requested",               1,  1,
            s::CodeList.build(
              "0" => "No Interchange Acknowledgment Requested",
              "1" => "Interchange Acknowledgment Requested (TA1)"))

          I14 = t::ID.new(:I14, "Interchange Usage Indicator",            1,  1,
            s::CodeList.build(
              "I" => "Information",
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
              "010" => "Invalid Interchange Time Value Invalid Interchange Time Value",
              "011" => "Invalid Interchange Time Value",
              "012" => "Invalid Interchange Time Value",
              "013" => "Invalid Interchange Time Value Invalid Interchange Time Value",
              "014" => "Invalid Interchange Time Value",
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

          I65 = Class.new(t::SimpleElementDef) do
            def companion
              SeparatorElementVal
            end
          end.new(:I65, "Repetition Separator",                           1,  1)

        end
      end
    end
  end
end
