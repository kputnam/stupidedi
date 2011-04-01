module Stupidedi
  module Envelope

    #
    # @see X12-5.pdf 3.2.1 Basic Interchange Service Request
    # @see X222.pdf B.1.1.4.1 Interchange Control Structures
    #
    class InterchangeVal < Values::AbstractVal
      include Values::SegmentValGroup
      include Color

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
        InterchangeVal.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # (see AbstractVal#interchange?)
      # @return true
      def interchange?
        true
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(Values::SegmentVal) }
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try do |d|
          ansi.bold("[#{d.id.to_s}]")
        end

        q.text(ansi.envelope("InterchangeVal#{id}"))
        q.group(2, "(", ")") do
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
        ansi.envelope("Interchange") << "(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == @definition and
          other.children   == @children)
      end
    end

  end
end
