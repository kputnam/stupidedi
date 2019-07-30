# frozen_string_literal: true
module Stupidedi
  module Refinements
    unless //.respond_to?(:match?)
      refine Regexp do
        def match?(string)
          !!(self =~ string)
        end
      end
    end
  end
end
