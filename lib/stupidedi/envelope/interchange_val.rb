module Stupidedi
  module Envelope

    #
    # @see X12.5 3.2.1 Basic Interchange Service Request
    #
    class InterchangeVal < Values::AbstractVal
      include Values::SegmentValGroup

      # @return [InterchangeDef]
      attr_reader :definition

      # @return [Array<SegmentVal, FunctionalGroupVal>]
      attr_reader :children

      # @return [#segment, #element, #repetition, #component]
      abstract :separators

      def initialize(definition, children)
        @definition, @children =
          definition, children

      # @header_segment_vals   = header_segment_vals.map{|x| x.copy(:parent => self) }
      # @trailer_segment_vals  = trailer_segment_vals.map{|x| x.copy(:parent => self) }
      # @functional_group_vals = functional_group_vals.map{|x| x.copy(:parent => self) }
      end

      # @return [InterchangeVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(Values::SegmentVal) }
      end

      # @return [InterchangeVal]
      def append(child)
        copy(:children => child.snoc(@children))
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}]" }
        q.text "InterchangeVal#{id}"
        q.group 2, "(", ")" do
          q.breakable ""
          @children.each do |e|
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
        other.children   == @children
      end
    end

  end
end
