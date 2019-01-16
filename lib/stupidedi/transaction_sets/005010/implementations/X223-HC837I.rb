# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X223
          warn "#{self}::HC837I is deprecated, use X223A2::HC837 instead"

          # @deprecated Use X223A2::HC837 instead
          HC837I = X223A2::HC837
        end
      end
    end
  end
end
