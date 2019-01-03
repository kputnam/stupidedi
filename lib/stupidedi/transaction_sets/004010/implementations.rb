# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
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

        autoload :AR943, "stupidedi/transaction_sets/004010/implementations/AR943"
        autoload :FA997, "stupidedi/transaction_sets/004010/implementations/FA997"
        autoload :GF990, "stupidedi/transaction_sets/004010/implementations/GF990"
        autoload :IM210, "stupidedi/transaction_sets/004010/implementations/IM210"
        autoload :OW940, "stupidedi/transaction_sets/004010/implementations/OW940"
        autoload :PO850, "stupidedi/transaction_sets/004010/implementations/PO850"
        autoload :PS830, "stupidedi/transaction_sets/004010/implementations/PS830"
        autoload :QM214, "stupidedi/transaction_sets/004010/implementations/QM214"
        autoload :RE944, "stupidedi/transaction_sets/004010/implementations/RE944"
        autoload :SH856, "stupidedi/transaction_sets/004010/implementations/SH856"
        autoload :SM204, "stupidedi/transaction_sets/004010/implementations/SM204"
        autoload :SQ866, "stupidedi/transaction_sets/004010/implementations/SQ866"
        autoload :SS862, "stupidedi/transaction_sets/004010/implementations/SS862"
        autoload :SW945, "stupidedi/transaction_sets/004010/implementations/SW945"

        module X091A1
          autoload :HP835, "stupidedi/transaction_sets/004010/implementations/X091A1-HP835"
        end
      end
    end
  end
end
