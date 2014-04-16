module Stupidedi
  module Schema

    class CodeList
      include Inspect

      abstract :external?

      def internal?
        not external?
      end

      class Internal < CodeList

        extend Forwardable
        def_delegators :@hash, :at, :defined_at?
        
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

        # Some elements are qualifiers that select which code list
        # is applicable to the qualified element. For instance, the
        # diagnosis codes in the HI segment are qualified by E1270
        # "Code List Qualifier Code", which indicates which code list
        # should be used to validate the E1271's diagnosis code. It
        # maybe ICD-9, ICD-10, etc.
        #
        # @return [AbstractSet<CodeList>]
        def code_lists(subset = Sets.universal)
          related =
            @hash.select do |k, v|
              subset.include?(k) and v.is_a?(Schema::CodeList)
            end

          if subset.finite?
            Sets.build([self]) + related.map{|k,v| v }
          else
            Sets.build([self])
          end
        end
      end

      class External < CodeList

        # @return [String]
        attr_reader :id

        def initialize(id)
          @id = id
        end

        def external?
          true
        end

        def code_lists(values = Sets.universal)
          Sets.build([self])
        end

        def to_str
          "CodeList.external(#{@id})"
        end
      end
    end

    class << CodeList
      # @group Constructors
      #########################################################################

      # @return [CodeList::Internal]
      def build(hash)
        CodeList::Internal.new(hash)
      end

      # @return [CodeList::External]
      def external(id, *ignored)
        CodeList::External.new(id)
      end

      # @endgroup
      #########################################################################
    end

  end
end
