module Stupidedi
  module Envelope

    #
    # @see X222.pdf B.1.1.3.13 Functional Group
    # @see X222.pdf B.1.1.4.2 Functional Groups
    #
    class FunctionalGroupVal < Values::AbstractVal
      include Values::SegmentValGroup
      include Color

      # @return [FunctionalGroupDef]
      attr_reader :definition

      # @return [Array<SegmentVal, TransactionSetVal>]
      attr_reader :children

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [FunctionalGroupVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(Values::SegmentVal) }
      end

      # @return [String, nil]
      def version
        if at(6) == "X"
          at(7).to_s.slice(0, 3)
        end
      end

      # @return [String, nil]
      def release
        if at(6) == "X"
          at(7).to_s.slice(0, 4)
        end
      end

      # @return [String, nil]
      def subrelease
        if at(6) == "X"
          at(7).to_s.slice(0, 5)
        end
      end

      # @return [String, nil]
      def implementation
        if at(6) == "X"
          at(7).to_s.slice(6, 4)
        end
      end

      # @return [Module]
      def segment_dict
        @definition.segment_dict
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try do |d|
          ansi.bold("[#{d.id.to_s}]")
        end

        q.text(ansi.envelope("FunctionalGroupVal#{id}"))
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
        ansi.envelope("Group") << "(#{@children.map(&:inspect).join(', ')})"
      end

      def ==(other)
        eql?(other) or
          (other.definition == @definition or
           other.children   == @children)
      end
    end

  end
end
