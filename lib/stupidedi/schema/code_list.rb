module Stupidedi
  module Schema

    class CodeList
      abstract :external?

      def internal?
        not external?
      end

      #
      #
      #
      class Internal < CodeList

        delegate :at, :defined_at?, :to => :@hash

        def initialize(hash)
          @hash = hash
        end

        # @return [Array<String>]
        def codes
          @hash.keys
        end

        def external?
          false
        end
      end

      #
      #
      #
      class External < CodeList
        attr_reader :id

        def initialize(id)
          @id = id
        end

        def external?
          true
        end
      end
    end

    class << CodeList
      def build(hash)
        CodeList::Internal.new(hash)
      end

      def external(id)
        CodeList::External.new(id)
      end
    end

  end
end
