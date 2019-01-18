# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X222
          warn "#{self}::HC837P is deprecated, use X22A1::HC837 instead"

          # @deprecated
          HC837P = X222A1::HC837
        end
      end
    end
  end
end
