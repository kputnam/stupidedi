# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          # NOTE: This definition is not usable as-is, because it references
          # segments that we don't have definitions for. The HB270 and HB271
          # *standards* refer to these, but the *implementation guide* doesn't
          # use or include definitions for these: LUI, VEH, PID, PDR, PDP, EM,
          # SD1, PKD, PCT.
          #
          # Furthermore, the 2120 NM1 loop is in conflict with the 2100 NM1
          # loop because both don't have any constraints (the implementation
          # guides do have the necessary constraints).
          HB271 = d::TransactionSetDef.build("HB", "271",
            "Eligibility, Coverage, or Benefit Information",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BHT.use(200, r::Mandatory, d::RepeatCount.bounded(1))),

            d::TableDef.detail("Table 2 - Detail",
              d::LoopDef.build("2000", d::RepeatCount.unbounded,
                s:: HL.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
                s::TRN.use(200, r::Optional,  d::RepeatCount.bounded(9)),
                s::AAA.use(250, r::Optional,  d::RepeatCount.bounded(9)),

                d::LoopDef.build("2100", d::RepeatCount.unbounded,
                  # This NM1 needs to have a constraint on NM1-01 to avoid
                  # ambiguity with 2120 NM1, but the particular constraints
                  # need to be specified in the implementation guide
                  s::NM1.use( 300, r::Mandatory, d::RepeatCount.bounded(1)),
                  s::REF.use( 400, r::Optional,  d::RepeatCount.bounded(9)),
                  s:: N2.use( 500, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N3.use( 600, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N4.use( 700, r::Optional,  d::RepeatCount.bounded(1)),
                  s::PER.use( 800, r::Optional,  d::RepeatCount.bounded(3)),
                  s::AAA.use( 850, r::Optional,  d::RepeatCount.bounded(9)),
                  s::PRV.use( 900, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DMG.use(1000, r::Optional,  d::RepeatCount.bounded(1)),
                  s::INS.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: HI.use(1150, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTP.use(1200, r::Optional,  d::RepeatCount.bounded(9)),
                # s::LUI.use(1250, r::Optional,  d::RepeatCount.bounded(9)),
                  s::MPI.use(1275, r::Optional,  d::RepeatCount.bounded(9)),

                  d::LoopDef.build("2110", d::RepeatCount.unbounded,
                    s:: EB.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                    s::HSD.use(1350, r::Optional,  d::RepeatCount.bounded(9)),
                    s::REF.use(1400, r::Optional,  d::RepeatCount.bounded(9)),
                    s::DTP.use(1500, r::Optional,  d::RepeatCount.bounded(20)),
                    s::AAA.use(1600, r::Optional,  d::RepeatCount.bounded(9)),
                  # s::VEH.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::PID.use(1800, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::PDR.use(1900, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::PDP.use(2000, r::Optional,  d::RepeatCount.bounded(1)),
                    s::LIN.use(2100, r::Optional,  d::RepeatCount.bounded(1)),
                  # s:: EM.use(2200, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::SD1.use(2300, r::Optional,  d::RepeatCount.bounded(1)),
                  # s::PKD.use(2400, r::Optional,  d::RepeatCount.bounded(1)),
                    s::MSG.use(2500, r::Optional,  d::RepeatCount.bounded(10)),

                    d::LoopDef.build("2115", d::RepeatCount.unbounded,
                      s::III.use(2600, r::Optional,  d::RepeatCount.bounded(1)),
                      s::DTP.use(2700, r::Optional,  d::RepeatCount.bounded(5)),
                      s::AMT.use(2800, r::Optional,  d::RepeatCount.bounded(5)),
                    # s::PCT.use(2900, r::Optional,  d::RepeatCount.bounded(5)),

                      d::LoopDef.build("2117", d::RepeatCount.unbounded,
                        s:: LQ.use(3000, r::Optional,  d::RepeatCount.bounded(1)),
                        s::AMT.use(3100, r::Optional,  d::RepeatCount.bounded(5)))),
                      # s::PCT.use(3200, r::Optional,  d::RepeatCount.bounded(5)))),

                    d::LoopDef.build("2120 LS", d::RepeatCount.bounded(1),
                      s:: LS.use(3300, r::Optional,  d::RepeatCount.bounded(1)),

                      # d::LoopDef.build("2120", d::RepeatCount.unbounded,
                      #   # This NM1 needs to have a constraint on NM1-01 to avoid
                      #   # ambiguity with 2100 NM1, but the particular constraints
                      #   # need to be specified in the implementation guide
                      #   s::NM1.use(3400, r::Optional,  d::RepeatCount.bounded(1)),
                      #   s:: N2.use(3500, r::Optional,  d::RepeatCount.bounded(1)),
                      #   s:: N3.use(3600, r::Optional,  d::RepeatCount.bounded(1)),
                      #   s:: N4.use(3700, r::Optional,  d::RepeatCount.bounded(1)),
                      #   s::PER.use(3800, r::Optional,  d::RepeatCount.bounded(3)),
                      #   s::PRV.use(3900, r::Optional,  d::RepeatCount.bounded(1))),

                      s:: LE.use(4000, r::Optional,  d::RepeatCount.bounded(1))))))),

            d::TableDef.summary("Table 3 - Summary",
              s:: SE.use(4100, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end
