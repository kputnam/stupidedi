module Stupidedi
  module Envelope

    #
    # @see X12.5.pdf 3.2.1 Basic Interchange Service Request
    #
    class InterchangeVal < Values::AbstractVal
      include Values::SegmentValGroup

      # @return [InterchangeDef]
      attr_reader :definition

      # @return [Array<SegmentVal, FunctionalGroupVal>]
      attr_reader :child_vals

      # @return [#segment, #element, #repetition, #component]
      abstract :separators

      def initialize(definition, child_vals)
        @definition, @child_vals =
          definition, child_vals
      end

      # @return [InterchangeVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:child_vals, @child_vals)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @child_vals.select{|x| x.is_a?(Values::SegmentVal) }
      end

      # @return [InterchangeVal]
      def append(child_val)
        copy(:child_vals => child_val.snoc(@child_vals))
      end
      alias append_segment append
      alias append_functional_group_val append

      # @return [InterchangeVal]
      def append!(child_val)
        @child_vals = child_val.snoc(@child_vals)
        self
      end
      alias append_segment! append!
      alias append_functional_group_val! append!

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}]" }
        q.text "InterchangeVal#{id}"
        q.group 2, "(", ")" do
          q.breakable ""
          @child_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.child_vals == @child_vals
      end
    end

  end
end
