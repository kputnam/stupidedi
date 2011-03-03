module Stupidedi
  module Definitions

    class RepetitionMax
      # @return [Boolean]
      abstract :bounded?

      def unbounded?
        not bounded?
      end

      # @return [Integer, nil]
      abstract :bound
    end

  end
end
