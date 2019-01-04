# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    class StateMachine
      include Inspect
      include Navigation
      include Generation
      include Tokenization

      # @return [Config]
      attr_reader :config

      # @return [Array<Zipper::AbstractCursor<StateMachine::AbstractState>>]
      attr_reader :active

      def initialize(config, active)
        @config, @active = config, active
      end

      def copy(changes = {})
        StateMachine.new \
          changes.fetch(:config, @config),
          changes.fetch(:active, @active)
      end

      # @return [Reader::Separators]
      def separators
        @active.head.node.separators
      end

      # @return [void]
      def pretty_print(q)
        q.text "StateMachine[#{@active.length}]"
        q.group 2, "(", ")" do
          q.breakable ""
          @active.each do |s|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp s.node.zipper.node
          end
        end
      end
    end

    class << StateMachine
      # @group Constructors
      #########################################################################

      # @return [StateMachine]
      def build(config, zipper = Zipper::Tree)
        StateMachine.new(config, InitialState.start(zipper).cons)
      end

      # @endgroup
      #########################################################################
    end
  end
end
