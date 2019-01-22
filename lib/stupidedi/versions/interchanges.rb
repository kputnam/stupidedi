# frozen_string_literal: true
module Stupidedi
  module Versions
    warn "DEPRECATION WARNING: #{self}::Interchanges is deprecated, use Stupidedi::Interchanges instead"
    Interchanges = Stupidedi::Interchanges
  end
end
