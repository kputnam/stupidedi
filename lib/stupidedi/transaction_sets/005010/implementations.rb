# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
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

        module X212
          autoload :HR276,  "stupidedi/transaction_sets/005010/implementations/X212-HR276"
        end

        module X214
          autoload :HN277,  "stupidedi/transaction_sets/005010/implementations/X214-HN277"
        end

        module X220
          autoload :BE834,  "stupidedi/transaction_sets/005010/implementations/X220-BE834"
        end

        module X220A1
          autoload :BE834,  "stupidedi/transaction_sets/005010/implementations/X220A1-BE834"
        end

        module X221
          autoload :HP835,  "stupidedi/transaction_sets/005010/implementations/X221-HP835"
        end

        module X221A1
          autoload :HP835,  "stupidedi/transaction_sets/005010/implementations/X221A1-HP835"
        end

        module X222
          autoload :HC837P,  "stupidedi/transaction_sets/005010/implementations/X222-HC837P"
        end

        module X222A1
          autoload :HC837P,  "stupidedi/transaction_sets/005010/implementations/X222A1-HC837P"
        end

        module X223
          autoload :HC837I,  "stupidedi/transaction_sets/005010/implementations/X223-HC837I"
        end

        module X231
          autoload :FA999,  "stupidedi/transaction_sets/005010/implementations/X231-FA999"
        end

        module X231A1
          autoload :FA999,  "stupidedi/transaction_sets/005010/implementations/X231A1-FA999"
        end

        module X279
          autoload :HS270,  "stupidedi/transaction_sets/005010/implementations/X279-HS270"
          autoload :HB271,  "stupidedi/transaction_sets/005010/implementations/X279-HB271"
        end

        module X279A1
          autoload :HS270,  "stupidedi/transaction_sets/005010/implementations/X279A1-HS270"
          autoload :HB271,  "stupidedi/transaction_sets/005010/implementations/X279A1-HB271"
        end
      end
    end
  end
end
