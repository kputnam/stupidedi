module Stupidedi
  module Envelope

    class Router
      # @return [InterchangeRouter]
      attr_reader :interchange

      # @return [FunctionalGroupRouter]
      attr_reader :functional_group

      # @return [TransactionSetRouter]
      attr_reader :transaction_set

      def initialize
        @interchange      = InterchangeRouter.new
        @functional_group = FunctionalGroupRouter.new
        @transaction_set  = TransactionSetRouter.new
      end

      # @private
      def pretty_print(q)
        q.text "TransactionSetRouter"
        q.group 2, "(", ")" do
          q.breakable ""

          q.pp @interchange
          q.text ","
          q.breakable

          q.pp @functional_group
          q.text ","
          q.breakable

          q.pp @transaction_set
        end
      end

      #
      # The interchange control segments (ISA/ISE) are versioned independently
      # from the functional group segments (GS/GE). Because different interchange
      # versions can have unique grammars, this table serves as an indirection.
      #
      # Opinion: The interchange version is encoded within the ISA segment, whose
      # definition is recursively dependent on the interchange version. Worse yet,
      # the version is encoded as the fourteenth element (in versions 00501 and
      # 00401), instead of say, the 1st element.
      #
      # This seems to indicate the versioning was an afterthought. The same
      # thought process was applied when versioning the functional group segments,
      # which has the version encoded in GS08.
      #
      # The best we can do to cope with this is to presume the ISA and GS segments
      # have an underlying grammar that won't change between versions. We do this
      # by parsing 12 things following "ISA", using the 12th thing as the version
      # number, and then starting over at "ISA" and parsing with actual grammar.
      # Then the grammar can specify which elements specify delimiters and all the
      # other parts of the interchange header, like the TA1 segment.
      #
      class InterchangeRouter
        def initialize
          @table = Hash.new
        end

        # @example
        #   table = InterchangeRouter.new
        #
        #   table.register(SixOhTwo::InterchangeDef,    "00602")
        #   table.register(FiveOhOne::InterchangeDef,   "00501")
        #   table.register(FourOhOne::InterchangeDef,   "00401")
        #   table.register(ThreeOhFour::InterchangeDef, "00304")
        #
        def register(definition, version = definition.id)
          @table[version] = definition
        end

        # @param version  ISA12
        def lookup(version)
          @table[version]
        end

        # @private
        def pretty_print(q)
          q.text "InterchangeRouter"
          q.group 2, "(", ")" do
            q.breakable ""
            @table.keys.each do |e|
              unless q.current_group.first?
                q.text ","
                q.breakable
              end
              q.pp e
            end
          end
        end
      end

      #
      # The functional group segments (GS/GE) and the segments contained by that
      # functional group are versioned separately from the interchange control
      # segments (ISA/ISE). The functional group version is informally referred to
      # as the EDI version (5010, 4010, etc). Each version indicates the segment
      # dictionary being used and the grammar of the functional group, though only
      # the GS and GE segments are described in the HIPAA guides.
      #
      # Because the interchange and functional group are versioned independently,
      # it may be possible, for instance, to send a 4010 transaction set within a
      # 5010 envelope, depending on forward- and backward-comatibility.
      #
      class FunctionalGroupRouter
        def initialize
          @table = Hash.new
        end

        # @example
        #   table = InterchangeRouter.new
        #
        #   table.register(FiftyTen,    "005010")
        #   table.register(FourtyTen,   "004010")
        #   table.register(ThirtyForty, "003040")
        #
        def register(definition, version = definition.id)
          @table[version] = definition
        end

        def lookup(version)
          @table[version]
        end

        # @private
        def pretty_print(q)
          q.text "FunctionalGroupRouter"
          q.group 2, "(", ")" do
            q.breakable ""
            @table.keys.each do |e|
              unless q.current_group.first?
                q.text ","
                q.breakable
              end
              q.pp e
            end
          end
        end
      end

      #
      # The implementation version specified in GS08 and ST03 indicates which
      # implementation guide governs the transaction. Because each guide may
      # define multiple transaction sets (eg X212 and X279), the functional code
      # and transaction set code are needed to lookup a definition.
      #
      # In english, we can't just look at ST01 and link "837" to our definition of
      # 837P from the HIPAA guide.
      #
      class TransactionSetRouter
        def initialize
          @table = Hash.new
        end

        # @example
        #   table = TransactionSetRouter.new(functional_group_implementation)
        #
        #   table.register(Hipaa::X212::HR276, "X212", "HR", "276")
        #   table.register(Hipaa::X212::HN277, "X212", "HN", "277")
        #
        #   table.register(Hipaa::X217::HI278, "X217", "HI", "278")
        #   table.register(Hipaa::X218::820RA, "X218", "RA", "820")
        #   table.register(Hipaa::X220::BE834, "X220", "BE", "834")
        #   table.register(Hipaa::X221::HP835, "X221", "HP", "835")
        #
        #   table.register(Hipaa::X222::HC837, "X222", "HC", "837")
        #   table.register(Hipaa::X223::HC837, "X223", "HC", "837")
        #   table.register(Hipaa::X224::HC837, "X224", "HC", "837")
        #
        #   table.register(Hipaa::X230::FA997, "X230", "FA", "997")
        #   table.register(Hipaa::X231::FA999, "X231", "FA", "999")
        #
        #   table.register(Hipaa::X279::HS270, "X279", "HS", "270")
        #   table.register(Hipaa::X279::HB271, "X279", "HB", "271")
        #
        #   table.register(Standards::HR276, nil, "HR", "276")
        #   table.register(Standards::HS270, nil, "HS", "270")
        #   table.register(Standards::HB271, nil, "HB", "271")
        #   table.register(Standards::HN277, nil, "HN", "277")
        #   table.register(Standards::HI278, nil, "HI", "278")
        #   table.register(Standards::820RA, nil, "RA", "820")
        #   table.register(Standards::BE834, nil, "BE", "834")
        #   table.register(Standards::HP835, nil, "HP", "835")
        #   table.register(Standards::HC837, nil, "HC", "837")
        #   table.register(Standards::FA997, nil, "FA", "997")
        #   table.register(Standards::FA999, nil, "FA", "999")
        #
        def register(definition, version, function = definition.functional_group, transaction = function.id)
          @table[Array[version, function, transaction]] = definition
        end

        # @param version      ST03 or GS08
        # @param function     GS01
        # @param transaction  ST01
        def lookup(version, function, transaction)
          @table[Array[version, function, transaction]]
        end

        # @private
        def pretty_print(q)
          q.text "TransactionSetRouter"
          q.group 2, "(", ")" do
            q.breakable ""
            @table.keys.each do |e|
              unless q.current_group.first?
                q.text ","
                q.breakable
              end
              q.pp e
            end
          end
        end
      end
    end

  end
end
