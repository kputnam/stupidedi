module Stupidedi
  module Builder

    module Navigation

      # @group Navigating the Tree
      #########################################################################

      # @return [Array<InstructionTable>]
      def successors
        @active.map{|a| a.node.instructions }
      end

      def deterministic?
        @active.length == 1
      end

      # @return [Values::AbstractVal]
      def node
        if deterministic?
          @active.head.node.zipper.node
        end
      end

      def first?
        state = @active.head
        value = @active.head.node.zipper

        until value.root?
          return false unless value.first?
          state = state.up
          value = value.up
        end

        return true
      end

      def last?
        state = @active.head
        value = @active.head.node.zipper

        until value.root?
          return false unless value.last?
          state = state.up
          value = value.up
        end

        return true
      end

      # @return [StateMachine]
      def first
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          until value.node.segment?
            value = value.down
            state = state.down
          end

          state
        end

        StateMachine.new(@config, active)
      end

      # @return [StateMachine]
      def last
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          until value.node.segment?
            value = value.down.last
            state = state.down.last
          end

          state
        end

        StateMachine.new(@config, active)
      end

      # @return [StateMachine]
      def forward
        active = []

        @active.each do |zipper|
          state = zipper
          value = zipper.node.zipper

          while not value.root? and value.last?
            state = zipper.up
            value = value.up
          end

          if zipper.root?
            raise Exceptions::ZipperError,
              "Cannot move forward: end of tree"
          end

          state = state.next
          value = value.next
        end
      end

      def backward
      end

    private

      # @return [Array<Zipper::AbstractCursor>]
      def roots
        active = []

        @active.each do |zipper|
          state = zipper
          value = zipper.node.zipper

          zipper.depth.times do
            value = value.up
            state = state.up
            state = state.replace(state.node.copy(:zipper => value))
          end

          active << state
        end

        active
      end

    end

  end
end
