module Stupidedi
  module Builder

    class FunctionalGroupBuilder < AbstractState
      def initialize(position, functional_group_val, predecessor)
         @position, @functional_group_val, @predecessor =
           position, functional_group_val, predecessor
      end

      def stuck?
        false
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:functional_group_val, @functional_group_val),
          changes.fetch(:predecessor, @predecessor)
      end

      # @private
      def pretty_print(q)
        q.text("InterchangeBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @functional_group_val
        end
      end
    end

    class << FunctionalGroupBuilder
      def start(functional_group_val, predecessor)
        position = functional_group_val.definition.header_segment_uses.head.position
        new(position, functional_group_val, predecessor)
      end
    end

  end
end
