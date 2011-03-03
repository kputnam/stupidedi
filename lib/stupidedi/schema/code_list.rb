module Stupidedi
  module Schema

    #
    #
    #
    class CodeList

      # @return [Hash]
      attr_reader :storage

      delegate :at, :defined_at?, :to => :@storage

      def initialize(codes)
        @codes = codes
      end

      # @return [Array<String>]
      def codes
        @storage.keys
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
