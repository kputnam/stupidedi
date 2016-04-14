# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Values

    class AbstractElementVal < AbstractVal

      # (see AbstractVal#element?)
      # @return true
      def element?
        true
      end

      # (see AbstractVal#size)
      def size
        0
      end
    end

  end
end
