module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module ElementDefs

          t = ElementTypes
          r = ElementReqs
          s = Schema

          E28   = t::Nn.new(:E28  , "Group Control Number"                 , 1, 9, 0)

          E96   = t::Nn.new(:E96  , "Number of Included Segments"          , 1, 10, 0)
          E97   = t::Nn.new(:E97  , "Number of Transaction Sets Included"  , 1, 6, 0)

          E124  = t::AN.new(:E124 , "Application Receiver's Code"          , 2, 15)

          E142  = t::AN.new(:E142 , "Application's Sender Code"            , 2, 15)
          E143  = t::ID.new(:E143 , "Transaction Set Identifier Number"    , 3, 3,
            s::CodeList.build(
              "277" => "Health Care Information Status Notification",
              "835" => "Health Care Claim Payment/Advice",
              "837" => "Health Care Claim"))

          E329  = t::ID.new(:E329 , "Transaction Set Control Number"       , 4, 9)

          E373  = t::DT.new(:E373 , "Date"                                 , 8, 8)

          E337  = t::TM.new(:E337 , "Time"                                 , 4, 8)

          E455  = t::ID.new(:E455 , "Responsible Agency Code"              , 1, 2,
            s::CodeList.build(
              "X" => "Accredited Standards Committee X12"))

          E479  = t::ID.new(:E479 , "Functional Identifier Code"           , 2, 2,
            s::CodeList.build(
              "BE" => "Benefit Enrollment and Maintenance",
              "FA" => "Functional or Implementation Acknowledgment Transaction Sets",
              "HC" => "Health Care Claim",
              "HI" => "Health Care Services Review Information",
              "HN" => "Health Care Information Status Notification",
              "HP" => "Health Care Claim Payment/Advice",
              "HS" => "Eligibility, Coverage or Benefit Inquiry",
              "HR" => "Health Care Claim Status Request",
              "RA" => "Payment Order/Remittance Advice"))

          E480  = t::AN.new(:E480 , "Version / Release / Identifier Code"  , 1, 12,
            s::CodeList.external("881"))

        end
      end
    end
  end
end
