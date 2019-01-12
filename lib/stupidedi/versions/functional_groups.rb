# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      warn "#{self} is deprecated, use Stupidedi::TransactionSets::*::Standards instead"

      module TwoThousandOne
      end

      module ThirtyTen
      end

      module ThirtyForty
      end

      module ThirtyFifty
      end

      module FortyTen
        # @deprecated Use Stupidedi::TransactionSets::FortyTen::Standards
        TransactionSetDefs = Stupidedi::TransactionSets::FortyTen::Standards
      end

      module FiftyTen
        # @deprecated Use Stupidedi::TransactionSets::FiftyTen::Standards
        TransactionSetDefs = Stupidedi::TransactionSets::FiftyTen::Standards
      end
    end
  end
end
