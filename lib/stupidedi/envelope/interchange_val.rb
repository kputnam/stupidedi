module Stupidedi
  module Envelope

    #
    # @see X12.5 3.2.1 Basic Interchange Service Request
    #
    class InterchangeVal < Values::AbstractVal
      include Values::SegmentValGroup

      # @return [InterchangeDef]
      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :header_segment_vals

      # @return [Array<FunctionalGroupVal>]
      attr_reader :functional_group_vals

      # @return [Array<SegmentVal>]
      attr_reader :trailer_segment_vals

      # @return [#segment, #element, #repetition, #component]
      abstract :separators

      def initialize(definition, header_segment_vals, functional_group_vals, trailer_segment_vals)
        @definition, @header_segment_vals, @functional_group_vals, @trailer_segment_vals =
          definition, header_segment_vals, functional_group_vals, trailer_segment_vals

      # @header_segment_vals   = header_segment_vals.map{|x| x.copy(:parent => self) }
      # @trailer_segment_vals  = trailer_segment_vals.map{|x| x.copy(:parent => self) }
      # @functional_group_vals = functional_group_vals.map{|x| x.copy(:parent => self) }
      end

      # @return [InterchangeVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:header_segment_vals, @header_segment_vals),
          changes.fetch(:functional_group_vals, @functional_group_vals),
          changes.fetch(:trailer_segment_vals, @trailer_segment_vals)
      end

      def reparent!
        @header_segment_vals.each{|x| x.reparent!(self) }
        @trailer_segment_vals.each{|x| x.reparent!(self) }
        @functional_group_vals.each{|x| x.reparent!(self) }
        return self
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @header_segment_vals + @trailer_segment_vals
      end

      # @return [InterchangeVal]
      def append_header_segment(segment_val)
        copy(:header_segment_vals => segment_val.snoc(@header_segment_vals))
      end

      # @return [InterchangeVal]
      def append_functional_group(functional_group_val)
        copy(:functional_group_vals => functional_group_val.snoc(@functional_group_vals))
      end

      # @return [InterchangeVal]
      def append_trailer_segment(segment_val)
        copy(:trailer_segment_vals => segment_val.snoc(@trailer_segment_vals))
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}]" }
        q.text "InterchangeVal#{id}"
        q.group 2, "(", ")" do
          q.breakable ""
          @header_segment_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
          @functional_group_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
          @trailer_segment_vals.each do |e|
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
        other.definition            == @definition and
        other.header_segment_vals   == @header_segment_vals and
        other.trailer_segment_vals  == @trailer_segment_vals and
        other.functional_group_vals == @functional_group_vals
      end
    end

  end
end
