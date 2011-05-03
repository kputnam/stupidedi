module Stupidedi
  module Values

    class AbstractElementVal < AbstractVal

      # (see AbstractVal#element?)
      # @return true
      def element?
        true
      end

      def size
        0
      end
    end

  end
end
