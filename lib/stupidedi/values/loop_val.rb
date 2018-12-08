# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Values

    #
    # @see X222.pdf B.1.1.3.12.2 Data Segment Groups
    # @see X222.pdf B.1.1.3.12.4 Loops of Data Segments
    #
    class LoopVal < AbstractVal
      include SegmentValGroup

      # @return [LoopDef]
      attr_reader :definition

      # @return [Array<SegmentVal, LoopVal>]
      attr_reader :children

      def_delegators "@children.head", :position

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [LoopVal]
      def copy(changes = {})
        LoopVal.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # (see AbstractVal#loop?)
      # @return true
      def loop?
        true
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try do |d|
          ansi.bold("[#{d.id.to_s}]")
        end

        q.text(ansi.loop("LoopVal#{id}"))
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [String]
      def inspect
        ansi.loop("Loop") + "(#{@children.map(&:inspect).join(', ')})"
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
