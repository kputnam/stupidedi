module Stupidedi
  module Envelope

    #
    # @see X12-5.pdf 3.2.1 Basic Interchange Service Request
    # @see X222.pdf B.1.1.4.1 Interchange Control Structures
    #
    class InterchangeVal < Values::AbstractVal
      include Values::SegmentValGroup
      include Inspect

      # @return [InterchangeDef]
      attr_reader :definition

      # @return [Array<SegmentVal, FunctionalGroupVal>]
      attr_reader :children

      # @return [#segment, #element, #repetition, #component]
      abstract :separators

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [InterchangeVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # @return false
      def leaf?
        false
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(Values::SegmentVal) }
      end

      # @return [InterchangeVal]
      def append(child_val)
        copy(:children => child_val.snoc(@children))
      end
      alias append_segment append
      alias append_functional_group_val append

      # @return [InterchangeVal]
      def append!(child_val)
        @children = child_val.snoc(@children)
        self
      end
      alias append_segment! append!
      alias append_functional_group_val! append!

      # @return [void]
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

      # @return [String]
      def inspect
        "InterchangeVal(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.children == @children
      end
    end

  end
end
