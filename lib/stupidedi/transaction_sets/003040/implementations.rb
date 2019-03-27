# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyForty
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

        #utoload :WA142, "stupidedi/transaction_sets/003040/implementations/WA142"
      end
    end
  end
end
