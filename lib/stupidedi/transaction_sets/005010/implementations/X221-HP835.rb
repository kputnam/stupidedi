# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Implementations
        module X221
          warn "DEPRECATION WARNING: #{self}::HP835 is deprecated, use X221A1::HP835 instead"

          # @deprecated Use X221A1::HP835 instead
          HP835 = X221A1::HP835
        end
      end
    end
  end
end
