module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module ElementDefs

          t = ElementTypes
          r = ElementReqs
          s = Schema

          E375  = t::ID.new(:E375 , "Tariff Service Code"                  , 2, 2)

          E140  = t::ID.new(:E140 , "Standard Carrier Alpha Code"          , 2, 4,
            s::CodeList.build(
              "RBTW" => "RBTW",
              "RBLT" => "RBLT",
              "CHRI" => "CHRI",
              "CHXD" => "CHXD",
              "RBIN" => "RBIN",
              "RBWR" => "RBWR",
              "RBCL" => "RBCL",
              "RBCG" => "RBCG",
              "CHSL" => "CHSL",
              "WGMA" => "WGMA",
              "RBID" => "RBID",
              "RFLB" => "RFLB",
              "RBHD" => "RBHD"))

          E154  = t::ID.new(:E154 , "Standard Point Location Code"         , 6, 9)

          E145  = t::AN.new(:E145 , "Shipment Identification Number"       , 1, 30)

          E146  = t::ID.new(:E146 , "Shipment Method of Payment"           , 2, 2,
            s::CodeList.build(
              "CC" => "Collect",
              "PC" => "Prepaid but Charged to Customer",
              "PP" => "Prepaid (by Seller)",
              "PU" => "Pickup",
              "TP" => "Third Party Pay"))
          
          E147  = t::ID.new(:E147 , "Shipment Qualifier"                   , 1, 1)

          E86   = t::ID.new(:E86  , "Total Equipment"                      , 1, 3)

          E460  = t::ID.new(:E460 , "Shipment Weight Code"                 , 1, 1)

          E501  = t::ID.new(:E501 , "Customes Document Handling Code"      , 2, 2)

          E335  = t::ID.new(:E335 , "Transportation Terms Code"            , 3, 3)

          E591  = t::ID.new(:E591 , "Payment Method Code"                  , 3, 3)

          E353  = t::ID.new(:E353 , "Transaction Set Purpose Code"        , 2, 2,
            s::CodeList.build(
              "00" => "Original",
              "01" => "Cancellation",
              "04" => "Change"))

          E346  = t::ID.new(:E346 , "Application Type"        , 2, 2,
            s::CodeList.build(
              "LT" => "Load Tender - Truckload (TL) Carrier Only",
              "PC" => "Partial Load Tender - Carrier Consolidate",
              "ZZ" => "Mutually Defined"))

          E127  = t::AN.new(:E127 , "Reference Identification"            , 1, 30)

          E128  = t::ID.new(:E128 , "Reference Identification Qualifier"  , 2, 3,
            s::CodeList.build(
              "11" => "Account Number",
              "3Z" => "Customs Broker Reference Number",
              "BM" => "Bill of Ladding Number",
              "CN" => "Carrier's Reference Number (PRO/Invoice)",
              "CO" => "Customer Order Number",
              "CR" => "Customer Reference Number",
              "DO" => "Delivery Order Number",
              "GZ" => "General Ledger Account",
              "IX" => "Item Number",
              "JB" => "Job (Project) Number",
              "KK" => "Delivery Reference",
              "MB" => "Master Bill of Lading",
              "P8" => "Pickup Reference Number",
              "PO" => "Purchase Order Number",
              "QN" => "Stop Sequence Number",
              "SI" => "Shipper's Identifying Number for Shipment (SID)",
              "SN" => "Seal Number",
              "WH" => "Master Reference (Link) Number",
              "ZZ" => "Mutually Defined"))

          E432  = t::ID.new(:E432  , "Date Qualifier"                      , 2, 2,
            s::CodeList.build(
              "37" => "Ship Not Before Date",
              "38" => "Ship Not Later Than Date",
              "53" => "Deliver Not Before Date",
              "54" => "Deliver Not Later Than Date",
              "64" => "Must Respond By"))

          E176  = t::ID.new(:E176 , "Time Qualifier"                      , 1, 2,
            s::CodeList.build(
              "I" => "Ship Not Before Time",
              "K" => "Ship Not Later Than Time",
              "G" => "Deliver Not Before Time",
              "L" => "Deliver Not Later Than Time",
              "1" => "Must Respond By"))

          E623  = t::ID.new(:E623 , "Time Code"                           , 2, 2,
            s::CodeList.build(
              "LT" => "Local Time (Preferred Usage - Exlain in detail)"))

          E133  = t::ID.new(:E133 , "Routing Sequence Code"               , 1, 2,
            s::CodeList.build(
              "B" => "Origin/Delivery Carrier (Any Mode)"))

          E19   = t::AN.new(:E19  , "City Name"                           , 2, 30)

          E91   = t::ID.new(:E91  , "Transportation Method/Type Code"     , 1, 2,
            s::CodeList.build(
              "A" => "Air",
              "H" => "Customer Pickup",
              "M" => "Motor (Common Carrier)",
              "R" => "Rail",
              "S" => "Ocean",
              "U" => "Private Parcel Service",
              "X" => "Intermodal (Piggyback)",
              "LT" => "Less Than Trailer Load (LTL)"))

          E156  = t::ID.new(:E156  , "State or Province Code"              , 2, 2,
            s::CodeList.external("22"))

          E406  = t::Nn.new(:E406  , "Quantity of Pallets Shipped"         , 1, 3, 0)

          E363  = t::ID.new(:E363  , "Note Reference Code"                 , 3, 3,
            s::CodeList.build(
              "ZZZ" => "Mutually Defined"))

          E352  = t::AN.new(:E352  , "Description"                         , 1, 80)

          E98   = t::ID.new(:E98   , "Entity Identifier Code"              , 2, 3,
            s::CodeList.build(
              "BT" => "Bill-to-Party",
              "BY" => "Buying Party (Purchaser)",
              "CN" => "Consignee",
              "SH" => "Shipper",
              "SF" => "Ship From",
              "ST" => "Ship To"))

          E93   = t::AN.new(:E93  , "Name"                                 , 1, 60)

          E66   = t::ID.new(:E66  , "Identification Code Qualifier"        , 2, 3,
            s::CodeList.build(
              "91" => "Assigned by Seller or Seller's Agent (Used when N101 = SF)",
              "92" => "Assigned by Buyer of Buyer's Agent",
              "ZZ" => "Mutually Defined"))

          E67   = t::AN.new(:E67  , "Identification Code"                  , 2, 80)

          E166  = t::AN.new(:E166  , "Address Information"                 , 1, 55)

          E116  = t::ID.new(:E116  , "Postal Code"                         , 3, 15,
            s::CodeList.external("51"),
            s::CodeList.external("166"))

          E26   = t::ID.new(:E26   , "Country Code"                        , 2, 3,
            s::CodeList.external("5"))

          E366  = t::ID.new(:E366 , "Contact Function Code"                , 2, 2,
            s::CodeList.build(
              "CN" => "General Contact",
              "DC" => "Delivery Contact",
              "IC" => "Information Contact",
              "SH" => "Shipper Contact",
              "HM" => "Hazardous Material Contact"))

          E365  = t::ID.new(:E365 , "Communcation Number Qualifier"        , 2, 2,
            s::CodeList.build(
              "EM" => "Electronic Mail",
              "FX" => "Facsimile",
              "TE" => "Telephone"))

          E364  = t::AN.new(:E364  , "Communication Number"                , 1, 80)

          E207  = t::AN.new(:E207  , "Equipment Number"                    , 1, 10)

          E40   = t::ID.new(:E40   , "Equipment Description Code"          , 2, 2,
            s::CodeList.build(
              "FF" => "Frozen Food Trailer",
              "FT" => "Flat Bed Trailer",
              "RC" => "Refrigerated (Reefer) Car",
              "RT" => "Controlled Temperature Trailer (Reefer)",
              "TF" => "Trailer, Try Freight",
              "TL" => "Trailer (not otherwise specified)",
              "TV" => "Truck, Van"))

          E567  = t::Nn.new(:E567  , "Equipment Length"                    , 4, 5, 0)

          E355 = t::ID.new(:E355, "Unit or Basis for Measurement Code"     , 2, 2,
            s::CodeList.build(
              "FA" => "Fahrenheit",
              "CA" => "Case",
              "EA" => "Each",
              "LB" => "Pound",
              "PL" => "Pallet/Unit Load",
              "TK" => "Tank",
              "ZZ" => "Mutually Defined"))

          C001  = Schema::CompositeElementDef.build(:MEA04,
            "Composite Unit of Measure",
            "To identify a composite unit of measure",
            E355.component_use(r::Mandatory, s::RepeatCount.bounded(1)))

          E740  = t:: R.new(:E740 , "Range Minimum"                        , 1, 20)

          E741  = t:: R.new(:E741 , "Range Maximum"                        , 1, 20)

          E225  = t::AN.new(:E225 , "Seal Number"                          , 2, 15)

          E165  = t::Nn.new(:E165 , "Stop Sequence Number"                 , 1, 3, 0)

          E163  = t::ID.new(:E163 , "Stop Reason Code"                     , 2, 2,
            s::CodeList.build(
              "CL" => "Complete Load",
              "CU" => "Complete Unload",
              "PL" => "Part Load",
              "PU" => "Part Unload"))

          E213  = t::Nn.new(:E213 , "Lading Line Item Number"              , 1, 3, 0)

          E79   = t::AN.new(:E79  , "Lading Description"                   , 1, 50)

          E558  = t::ID.new(:E558 , "Reservation Action Code"              , 1, 1,
            s::CodeList.build(
              "A" => "Reservation Accepted",
              "D" => "Reservation Cancelled"))

          E61   = t::AN.new(:E61  , "Free-Form Message"                    , 1, 30)

          E22   = t::AN.new(:E22  , "Commodity Code"                       , 1, 30)

          E23   = t::ID.new(:E23  , "Commodity Code Qualifier"             , 1, 1,
            s::CodeList.build(
              "2" => "Dun's SIC 2+2, Dun & Bradstreet",
              "N" => "National Motor Freight Classification (NMFC)",
              "T" => "Standard Transportation Commidity Code (STCC)",
              "Z" => "Mutually defined"))

          E103  = t::ID.new(:E103 , "Packaging Code"                       , 3, 5,
            s::CodeList.build(
              "AMM" => "Ammo Pack",
              "BAG" => "Bag",
              "BAL" => "Bale",
              "BDL" => "Bundle",
              "BIN" => "Bin",
              "BOT" => "Bottle",
              "BOX" => "Box",
              "BXT" => "Bucket",
              "CAS" => "Case",
              "CRT" => "Crate",
              "CTN" => "Carton",
              "DRM" => "Drum",
              "JAR" => "Jar",
              "KIT" => "Kit",
              "LSE" => "Loose",
              "LUG" => "Lug",
              "PAL" => "Pail",
              "PCK" => "Packed - not otherwise specified",
              "PCS" => "Pieces",
              "PKG" => "Package",
              "PLT" => "Pallet",
              "RCK" => "Rack",
              "REL" => "Reel",
              "ROL" => "Roll",
              "SAK" => "Sack",
              "SHT" => "Sheet",
              "SKD" => "Skid",
              "SKE" => "Skid, elevating or lift truck",
              "SLP" => "Slip Sheet",
              "TBN" => "Tote Bin",
              "TLD" => "Intermodal Trailer/Container Load (Rail)",
              "TRY" => "Tray"))

          E87   = t::AN.new(:E87  , "Marks and Numbers"                    , 1, 48)

          E88   = t::ID.new(:E88  , "Marks and Numbers Qualifier"          , 1, 2,
            s::CodeList.build(
              "UP" => "U.P.C. Consumer Package Code (1-5-5-1)"))

          E187  = t::ID.new(:E187 , "Weight Qualifier"                     , 1, 2,
            s::CodeList.build(
              "G" => "Gross Weight"))

          E188  = t::ID.new(:E188 , "Weight Unit Code"                     , 1, 1,
            s::CodeList.build(
              "L" => "Pounds"))

          E81   = t:: R.new(:E81  , "Weight"                               , 1, 10)

          E80   = t::Nn.new(:E80  , "Lading Quantity"                      , 1, 7, 0)

          E184  = t::ID.new(:E184 , "Volume Unit Qualifier"                , 1, 1,
            s::CodeList.build(
              "E" => "Cubic Feet"))

          E183  = t:: R.new(:E183 , "Volume"                               , 1, 8)

          E277  = t::ID.new(:E277 , "UN/NA Identification Code"            , 6, 6)

          E254  = t::ID.new(:E254 , "Packing Group Code"                   , 1, 3)

          E215  = t::ID.new(:E215 , "Hazardous Classification"             , 1, 30)

          E983  = t::ID.new(:E983 , "Hazardous Class Qualifier"            , 1, 1,
            s::CodeList.build(
              "P" => "Primary",
              "S" => "Secondary"))

          E224  = t::ID.new(:E224 , "Hazardous Material Shipping Name"     , 1, 25)

          E984  = t::ID.new(:E984 , "Hazardous Material Shipping Name Qualifier", 1, 1,
            s::CodeList.build(
              "D" => "Domestic (United States) Shipping Name"))

          E808  = t::ID.new(:E808 , "Hazardous Material Shipping Information Qualifier", 3, 3,
            s::CodeList.build(
              "TEC" => "Technical or Chemical Group Name"))

          E809  = t::AN.new(:E809 , "Hazardous Material Shipment Information", 1, 25)

          E60   = t:: R.new(:E60  , "Freight Rate"                         , 1, 9)

          E122  = t::ID.new(:E122 , "Rate/Value Qualifier"                 , 2, 2,
            s::CodeList.build(
              "FR" => "Flat Rate",
              "PM" => "Per Mile",
              "PL" => "Per Load"))

          E58   = t:: R.new(:E58  , "Charge"                               , 1, 12)

          E74   = t:: R.new(:E74  , "Declared Value"                       , 2, 12)

          E28   = t::Nn.new(:E28  , "Group Control Number"                 , 1, 9, 0)

          E96   = t::Nn.new(:E96  , "Number of Included Segments"          , 1, 10, 0)

          E97   = t::Nn.new(:E97  , "Number of Transaction Sets Included"  , 1, 6, 0)

          E124  = t::AN.new(:E124 , "Application Receiver's Code"          , 2, 15)

          E142  = t::AN.new(:E142 , "Application's Sender Code"            , 2, 15)

          E143  = t::ID.new(:E143 , "Transaction Set Identifier Number"    , 3, 3,
            s::CodeList.build(
              "277" => "Health Care Information Status Notification",
              "835" => "Health Care Claim Payment/Advice",
              "837" => "Health Care Claim",
              "204" => "Motor Carrier Load Tender",
              "990" => "Response to a Load Tender"))

          E329  = t::ID.new(:E329 , "Transaction Set Control Number"       , 4, 9)

          E373  = t::DT.new(:E373 , "Date"                                 , 8, 8)

          E337  = t::TM.new(:E337 , "Time"                                 , 4, 4)

          E455  = t::ID.new(:E455 , "Responsible Agency Code"              , 1, 2,
            s::CodeList.build(
              "X" => "Accredited Standards Committee X12"))

          E479  = t::ID.new(:E479 , "Functional Identifier Code"           , 2, 2,
            s::CodeList.build(
              "BE" => "Benefit Enrollment and Maintenance",
              "FA" => "Functional or Implementation Acknowledgment Transaction Sets",
              "GF" => "Response to a Load Tender",
              "HC" => "Health Care Claim",
              "HI" => "Health Care Services Review Information",
              "HN" => "Health Care Information Status Notification",
              "HP" => "Health Care Claim Payment/Advice",
              "HS" => "Eligibility, Coverage or Benefit Inquiry",
              "HR" => "Health Care Claim Status Request",
              "RA" => "Payment Order/Remittance Advice",
              "SM" => "Motor Carrier Load Tender",
              "TM" => "Motor Carrier Delivery Trailer Manifest",
              "UP" => "Motor Carrier Pick-up Manifest"))

          E480  = t::AN.new(:E480 , "Version / Release / Identifier Code"  , 1, 12,
            s::CodeList.external("881"))

          E999  = t::AN.new(:E999 , "Not Available"                        , 1, 1)

        end
      end
    end
  end
end
