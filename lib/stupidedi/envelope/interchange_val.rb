module Stupidedi
  module Envelope

    #
    # @note: This is similar to a LoopVal or TableVal, because it contains
    # a sequence of SegmentVals (ISA, ISB, ISE, TA1, etc) followed by sequence
    # of children segment groups -- in this case FunctionalGroupVal instead of
    # sub-LoopVals.
    #
    # One possible problem with this implementation is that there isn't a place
    # to store the sequence of segments following the child FunctionalGroupVals.
    # Because the 00401 and 00501 envelopes only have the IEA segment following
    # the child FunctionalGroupVals, we don't actually need to account for it --
    # the contents of the IEA segment can be entirely derived from the segments
    # preceeding it.
    #
    # @see X12.5 3.2.1 Basic Interchange Service Request
    #
    class InterchangeVal
      include Values::SegmentValGroup

      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :segment_vals

      # @return [Array<FunctionalGroupVal>]
      attr_reader :functional_group_vals

      # @return [#segment, #element, #repetition, #component]
      abstract :separators

      def initialize(definition, segment_vals, functional_group_vals)
        @definition, @segment_vals, @functional_group_vals =
          definition, segment_vals, functional_group_vals

        @segment_vals = segment_vals.map{|x| x.copy(:parent => self) }
        @functional_group_vals = functional_group_vals.map{|x| x.copy(:parent => self) }
      end

      # @return [InterchangeVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:segment_vals, @segment_vals),
          changes.fetch(:functional_group_vals, @functional_group_vals)
      end

      def empty?
        @segment_vals.all(&:empty?) and @functional_group_vals.all(&:empty?)
      end

      def append(val)
        if val.is_a?(FunctionalGroupVal)
          copy(:functional_group_vals => val.snoc(@functional_group_vals))
        else
          copy(:segment_vals => val.snoc(@segment_vals))
        end
      end

      def prepend(val)
        if val.is_a?(FunctionalGroupVal)
          copy(:functional_group_vals => val.cons(@functional_group_vals))
        else
          copy(:segment_vals => val.cons(@segment_vals))
        end
      end

      # @private
      def pretty_print(q)
        id = @definiton.try{|i| "[#{i.id}]" }
        q.text("InterchangeVal#{id}")
        q.group(1, "(", ")") do
          q.breakable ""
          @segment_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @private
      def ==(other)
        other.definition == @definition and
        other.segment_vals == @segment_vals
      end
    end

  end
end
