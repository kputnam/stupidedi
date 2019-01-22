# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X223A1
          warn "DEPRECATION WARNING: #{self}::HC837 is deprecated, use X223A2::HC837 instead"

          # @deprecated Use X223A2::HC837 instead
          HC837 = X223A2::HC837
        end
      end
    end
  end
end
