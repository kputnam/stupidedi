module Stupidedi
  module Envelope

    #
    # X12 standards are released three times yearly. The version codes sent in
    # the GS08 and ST03 elements encode the version (eg 004, 005), the release
    # (eg 0040, 0050), the subrelease (00501, 00602) and the level (eg 005010)
    #
    # The release schedules look like this:
    #
    #           Approved by     Available       Ballot Results  Available for
    # Version   Subcommitees    for Ballot      Approved        Distribution
    # -------------------------------------------------------------------------
    #  005010     Feb 03          Jun 03          Oct 03          Jan 04
    #  005011     Jun 03          Oct 04          Feb 04          Mar 04
    #  005012     Oct 03          Feb 04          Jun 04          Jul 04
    #
    #  005020     Feb 04          Jun 04          Oct 04          Jan 05
    #  005021     Jun 04          Oct 04          Feb 05          Mar 05
    #  005022     Oct 04          Feb 05          Jun 05          Jul 05
    #
    # @see http://www.disa.org/x12org/subcommittees/dev/pdf/X12RELEASESCHED.pdf
    #
    # @see X222.pdf B.1.1.3.13 Functional Group
    # @see X222.pdf B.1.1.4.2 Functional Groups
    #
    class FunctionalGroupDef
      include Inspect

      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUses>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUses>]
      attr_reader :trailer_segment_uses

      # @return [Array<SegmentUses>]
      attr_reader :transaction_set_uses

      def initialize(id, header_segment_uses, trailer_segment_uses)
        @id, @header_segment_uses, @trailer_segment_uses =
          id, header_segment_uses, trailer_segment_uses

        @header_segment_uses  = header_segment_uses.map{|x| x.copy(:parent => self) }
        @trailer_segment_uses = trailer_segment_uses.map{|x| x.copy(:parent => self) }
      end

      # @return [FunctionalGroupDef]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      # @return [SegmentUse]
      def entry_segment_use
        @header_segment_uses.head
      end

      # @return [Array<SegmentUse>]
      def segment_uses
        @__segment_uses ||= @header_segment_uses + @trailer_segment_uses
      end

      # @return [FunctionalGroupVal]
      def empty
        FunctionalGroupVal.new(self, [], [])
      end

      # @return [void]
      def pretty_print(q)
        q.text("FunctionalGroupDef")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          unless q.current_group.first?
            q.text ","
            q.breakable
          end
          q.text "... (TRANSACTION SETS) ..."

          @trailer_segment_uses.each do |e|
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
