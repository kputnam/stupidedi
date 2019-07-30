# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module FourOhOne
      module ElementDefs
        t = Versions::FortyTen::ElementTypes
        c = Interchanges::Common::ElementTypes
        s = Schema

        I01 = t::ID.new(:I01, "Authorization Information Qualifier",      2,  2,
          s::CodeList.build(
            "00" => "No Authorization Information Present (No Meaningful Information in I02)",
            "03" => "Additional Data Identification"))
        I02 = c::SpecialAN.new(:I02, "Authorization Information",        10, 10)
        I03 = t::ID.new(:I03, "Security Information Qualifier",           2,  2,
          s::CodeList.build(
            "00" => "No Security Information (No Meaningful Information in I04)",
            "01" => "Password"))
        I04 = c::SpecialAN.new(:I04, "Security Information",             10, 10)
        I05 = t::ID.new(:I05, "Interchange ID Qualifier",                 2,  2,
          s::CodeList.build(
            "01" => "Duns (Dun & Bradstreet)",
            "02" => "SCAC (Standard Carrier Alpha Code)",
            "12" => "Phone (Telephone Companies)",
            "14" => "Duns Plus Suffix",
            "20" => s::CodeList.external("121"),
            "27" => "Carrier Identification Number as assigned by Health Care Financing Administration (HCFA)",
            "28" => "Fiscal Intermediary Identification Number as assigned by Health Care Financing Administration (HCFA)",
            "29" => "Medicare Provider and Supplier Identification Number as assigned by Health Care Financing Administration (HCFA)",
            "30" => "US Federal Tax Identification Number",
            "33" => "National Association of Insurance Commissioners Company Code (NAIC)",
            "ZZ" => "Mutually Defined"))
        I06 = c::SpecialAN.new(:I06, "Interchange Sender ID",            15, 15)
        I07 = c::SpecialAN.new(:I07, "Interchange Receiver ID",          15, 15)
        I08 = t::DT.new(:I08, "Interchange Date",                         6,  6)
        I09 = t::TM.new(:I09, "Interchange Time",                         4,  4)
        I10 = t::ID.new(:I10, "Interchange Control Standards Identifier", 1,  1,
          s::CodeList.build(
            "U" => "U.S. EDI Community of ASC X12, TDCC, and UCS"))
        I11 = t::ID.new(:I11, "Interchange Control Version Number",       5,  5,
          s::CodeList.build(
            "00401" => "Draft Standards for Trial Use Approved for Publication by ASC X12 Procedures Review Board through October 1997"))
        I12 = t::Nn.new(:I12, "Interchange Control Number",               9,  9, 0)
        I13 = t::ID.new(:I13, "Acknowledgment Requested",                 1,  1,
          s::CodeList.build(
            "0" => "No Interchange Acknowledgment Requested",
            "1" => "Interchange Acknowledgment Requested (TA1)"))
        I14 = t::ID.new(:I14, "Interchange Usage Indicator",              1,  1,
          s::CodeList.build(
            "P" => "Production Data",
            "T" => "Test Data"))
        I15 = c::Separator.new(:I15, "Component Element Separator",       1,  1)
        I16 = t::Nn.new(:I16, "Number of Included Functional Groups",     1,  5, 0)
        I17 = t::ID.new(:I17, "Interchange Acknowledgement Code",         1,  1,
          s::CodeList.build(
            "A" => "The Transmitted Interchange Control Structure Header and Trailer Have Been Received and Have No Errors",
            "E" => "The Transmitted Interchange Control Structure Header and Trailer Have Been Received and Are Accepted But Errors Are Noted. This Means the Sender Must Not Resend the Data.",
            "R" => "The Transmitted Interchange Control Structure Header and Trailer are Rejected Because of Errors"))
        I18 = t::ID.new(:I18, "Interchange Note Code",                    3,  3,
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
