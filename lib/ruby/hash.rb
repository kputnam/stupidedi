module Stupidedi
  module Refinements
    refine Hash do
      alias defined_at? include?
      alias at []
    end
  end
end
