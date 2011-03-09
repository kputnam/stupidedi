module Stupidedi
  module Builder_

    class AbstractState

      abstract :value

      abstract :parent

      abstract :successors, :args => %w(segment_tok)

      abstract :push

      abstract :pop

    private

    end

  end
end
