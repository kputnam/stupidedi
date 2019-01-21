# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module TwoThousandOne
      module Implementations
        module SegmentReqs
          Required    = Common::Implementations::SegmentReqs::Required
          Situational = Common::Implementations::SegmentReqs::Situational
        end

        module ElementReqs
          Required    = Common::Implementations::ElementReqs::Required
          Situational = Common::Implementations::ElementReqs::Situational
          NotUsed     = Common::Implementations::ElementReqs::NotUsed
        end

        #utoload :FA997, "stupidedi/transaction_sets/002001/implementations/FA997"
        autoload :PO830, "stupidedi/transaction_sets/002001/implementations/PO830"
        autoload :SH856, "stupidedi/transaction_sets/002001/implementations/SH856"
      end
    end
  end
end
