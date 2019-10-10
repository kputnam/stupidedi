# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyFifty
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

        autoload :PO850, "stupidedi/transaction_sets/003050/implementations/PO850"
      end
    end
  end
end
