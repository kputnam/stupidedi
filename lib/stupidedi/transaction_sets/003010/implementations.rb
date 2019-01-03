# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyTen
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

        autoload :RA820, "stupidedi/transaction_sets/003010/implementations/RA820"
        autoload :PO850, "stupidedi/transaction_sets/003010/implementations/PO850"
        autoload :PC860, "stupidedi/transaction_sets/003010/implementations/PC860"
        autoload :PS830, "stupidedi/transaction_sets/003010/implementations/PS830"
      end
    end
  end
end
