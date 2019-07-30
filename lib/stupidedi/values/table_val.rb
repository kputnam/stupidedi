# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Values
    class TableVal < AbstractVal
      include SegmentValGroup

      # @return [TableDef]
      attr_reader :definition

      def_delegators :definition, :descriptor

      # @return [Array<SegmentVal, LoopVal>]
      attr_reader :children

      def_delegators "@children.head", :position

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [TableVal]
      def copy(changes = {})
        TableVal.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
      end

      # (see AbstractVal#table?)
      # @return true
      def table?
        true
      end

      # :nocov:
      # @return [void]
      def pretty_print(q)
        id = @definition.try do |d|
          ansi.bold("[#{d.id.to_s}]")
        end

        q.text(ansi.table("TableVal#{id}"))
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
      # :nocov:

      # :nocov:
      # @return [String]
      def inspect
        ansi.table("Table") + "(#{@children.map(&:inspect).join(", ")})"
      end
      # :nocov:

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == @definition and
          other.children   == @children)
      end
    end
  end
end
