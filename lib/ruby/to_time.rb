# frozen_string_literal: true

module Stupidedi
  module Refinements

    refine Time do
      # @return [Time]
      def to_time
        self
      end
    end

    class << Time
      public :parse
    end

    refine String do
      def to_time
        Time.parse(self)
      end
    end

  end
end
