module Stupidedi
  module Schema

    #
    #
    #
    class CodeList
      delegate :at, :defined_at?, :to => :@hash

      def initialize(hash)
        @hash = hash
      end

      # @return [Array<String>]
      def codes
        @hash.keys
      end
    end

    class << CodeList
      def build(hash)
        CodeList.new(hash)
      end

      def external(id)
      end
    end

  end
end
