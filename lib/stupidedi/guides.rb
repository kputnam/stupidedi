# frozen_string_literal: true
module Stupidedi
  module Guides
    warn "DEPRECATION WARNING: #{self} is deprecated, use Stupidedi::TransactionSets::*::Implementations"

    # @deprecated Use Stupidedi::TransactionSets::FiftyTen::Implementations
    FiftyTen = Stupidedi::TransactionSets::FiftyTen::Implementations

    # @deprecated Use Stupidedi::TransactionSets::FortyTen::Implementations
    FortyTen = Stupidedi::TransactionSets::FortyTen::Implementations
  end
end
