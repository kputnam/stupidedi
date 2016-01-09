module Stupidedi
  using Refinements

  class Config

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
      include Inspect
      
      def initialize
        @table = Hash.new
      end

      def customize(&block)
        tap(&block)
      end

      def defined_at?(x)
        @table.defined_at?(x)
      end

      #
      # @example
      #   table = InterchangeConfig.new
      #
      #   table.register("00602") { SixOhTwo::InterchangeDef }
      #   table.register("00501") { FiveOhOne::InterchangeDef }
      #   table.register("00401") { FourOhOne::InterchangeDef }
      #   table.register("00304") { ThreeOhFour::InterchangeDef }
      #
      # @return [void]
      def register(version, definition = nil, &constructor)
        if block_given?
          @table[version] = constructor
        else
          @table[version] = definition
        end
      end

      # @return [InterchangeDef]
      def at(version)
        x = @table[version]
        x.is_a?(Proc) ? x.call : x
      end

      # @return [void]
      def pretty_print(q)
        q.text "InterchangeConfig"
        q.group(2, "(", ")") do
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
