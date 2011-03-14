module Stupidedi
  module Configuration

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
    # @see http://x12.org/rfis/ "Relations Between the ISA and GS Segments.PDF"
    #
    class InterchangeConfig
      def initialize
        @table = Hash.new
      end

      # @example
      #   table = InterchangeConfig.new
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
      def at(version)
        @table[version]
      end

      def defined_at?(version)
        @table.defined_at?(version)
      end

      # @private
      def pretty_print(q)
        q.text "InterchangeConfig"
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
