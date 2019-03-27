# frozen_string_literal: true
module Stupidedi
  module Contrib
    warn "DEPRECATION WARNING: #{self} is deprecated, use Stupidedi::TransactionSets"

    module TwoThousandOne
      # @deprecated Use Stupidedi::TransactionSets::TwoThousandOne::Standards
      TransactionSets = Stupidedi::TransactionSets::TwoThousandOne::Standards

      # @deprecated Use Stupidedi::TransactionSets::TwoThousandOne::Implementations
      Guides          = Stupidedi::TransactionSets::TwoThousandOne::Implementations
    end

    module ThirtyTen
      # @deprecated Use Stupidedi::TransactionSets::ThirtyTen::Standards
      TransactionSets = Stupidedi::TransactionSets::ThirtyTen::Standards

      # @deprecated Use Stupidedi::TransactionSets::ThirtyTen::Implementations
      Guides          = Stupidedi::TransactionSets::ThirtyTen::Implementations
    end

    module ThirtyForty
      # @deprecated Use Stupidedi::TransactionSets::ThirtyForty::Standards
      TransactionSets = Stupidedi::TransactionSets::ThirtyForty::Standards

      # @deprecated Use Stupidedi::TransactionSets::ThirtyForty::Implementations
      Guides          = Stupidedi::TransactionSets::ThirtyForty::Implementations
    end

    module ThirtyFifty
      # @deprecated Use Stupidedi::TransactionSets::ThirtyFifty::Standards
      TransactionSets = Stupidedi::TransactionSets::ThirtyFifty::Standards

      # @deprecated Use Stupidedi::TransactionSets::ThirtyFifty::Implementations
      Guides          = Stupidedi::TransactionSets::ThirtyFifty::Implementations
    end

    module FortyTen
      # @deprecated Use Stupidedi::TransactionSets::FortyTen::Standards
      TransactionSets = Stupidedi::TransactionSets::FortyTen::Standards

      # @deprecated Use Stupidedi::TransactionSets::FortyTen::Guides
      Guides = Stupidedi::TransactionSets::FortyTen::Implementations
    end
  end
end
