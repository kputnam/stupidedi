# frozen_string_literal: true
module Stupidedi
  module Refinements

    refine Hash do
      def defined_at?(x)
        include?(x)
      end

      def at(x)
        self[x]
      end
    end

  end
end
