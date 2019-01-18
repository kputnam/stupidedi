# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X220
          warn "#{self}::BE834 is deprecated, use X220A1::BE834 instead"

          # @deprecated Use X223A2::HC837 instead
          BE834 = X220A1::BE834
        end
      end
    end
  end
end
