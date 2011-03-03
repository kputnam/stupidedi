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
    end

    class << FunctionalGroupBuilder
      def start(functional_group_val, predecessor)
      end
    end

  end
end
