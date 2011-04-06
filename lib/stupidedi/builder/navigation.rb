module Stupidedi
  module Builder

    module Navigation

      # @return [Array<InstructionTable>]
      def successors
        @active.map{|a| a.node.instructions }
      end

      def zipper
        if deterministic?
          @active.head.node.zipper
        end
      end

      def deterministic?
        @active.length == 1
      end

      # Is this the first segment?
      def first?
        value = @active.head.node.zipper

        until value.root?
          return false unless value.first?
          value = value.up
        end

        return true
      end

      # Is this the last segment?
      def last?
        value = @active.head.node.zipper

        until value.root?
          return false unless value.last?
          value = value.up
        end

        return true
      end

      # @group Navigating the Tree
      #########################################################################

      # @return [Values::AbstractVal]
      def node
        if deterministic?
          @active.head.node.zipper.node
        end
      end

      # @return [StateMachine]
      def first
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper
          xx(:first, value, state)

          until value.node.segment?
            value = value.down
            state = state.down
            unless value.eql?(state.node.zipper)
              state = state.replace(state.node.copy(:zipper => value))
            end
            xx(:first, value, state)
          end
        # puts

          state
        end

        StateMachine.new(@config, active)
      end

      # @return [StateMachine]
      def last
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper
          xx(:last, value, state)

          until value.node.segment?
            value = value.down.last
            state = state.down.last
            unless value.eql?(state.node.zipper)
              state = state.replace(state.node.copy(:zipper => value))
            end
            xx(:last, value, state)
          end

          state
        end

        StateMachine.new(@config, active)
      end

      # @return [StateMachine]
      def forward(count = 1)
        active = @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper
          xx(:forward, value, state)

          count.times do
            while not value.root? and value.last?
              value = value.up
              state = state.up
              unless value.eql?(state.node.zipper)
                state = state.replace(state.node.copy(:zipper => value))
              end
              xx(:forward, value, state)
            end

            if value.root?
              raise Exceptions::ZipperError,
                "cannot move forward after last segment"
            end

            value = value.next
            state = state.next
            unless value.eql?(state.node.zipper)
              state = state.replace(state.node.copy(:zipper => value))
            end
            xx(:forward, value, state)

            until value.node.segment?
              value = value.down
              state = state.down
              unless value.eql?(state.node.zipper)
                state = state.replace(state.node.copy(:zipper => value))
              end
              xx(:forward, value, state)
            end
          end
        # puts

          state
        end

        StateMachine.new(@config, active)
      end

      # @return [StateMachine]
      def backward(count = 1)
        active = @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          count.times do
            while not value.root? and value.first?
              value = value.up
              state = state.up
              unless value.eql?(state.node.zipper)
                state = state.replace(state.node.copy(:zipper => value))
              end
              xx(:backward, value, state)
            end

            if value.root?
              raise Exceptions::ZipperError,
                "cannot move backward before first segment" 
            end

            state = state.prev
            value = value.prev
            unless value.eql?(state.node.zipper)
              state = state.replace(state.node.copy(:zipper => value))
            end
            xx(:backward, value, state)

            until value.node.segment?
              value = value.down.last
              state = state.down.last
              unless value.eql?(state.node.zipper)
                state = state.replace(state.node.copy(:zipper => value))
              end
              xx(:backward, value, state)
            end
          end

          state
        end

        StateMachine.new(@config, active)
      end

    private

      # @return [Array<Zipper::AbstractCursor>]
      def roots
        @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper
          xx(:roots, value, state)

          zipper.depth.times do
            value = value.up
            state = state.up
            unless value.eql?(state.node.zipper)
              state = state.replace(state.node.copy(:zipper => value))
            end
            xx(:roots, value, state)
          end
        # puts

          state
        end
      end

      def xx(label, value, state)
      # puts label
      # puts " ~v: #{state.node.zipper.object_id} #{state.node.zipper.class.name.split('::').last}"
      # puts "  v: #{value.object_id} #{value.class.name.split('::').last}"
      # puts "     #{value.node.inspect}"
      # puts "  s: #{state.object_id} #{state.class.name.split('::').last}"
      # puts "     #{state.node.inspect}"
      end

    end

  end
end
