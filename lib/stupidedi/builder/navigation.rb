module Stupidedi
  module Builder

    module Navigation

      # @return [Array<InstructionTable>]
      def successors
        @active.map{|a| a.node.instructions }
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

      # @return [Either<Zipper::AbstractCursor>]
      def zipper
        if deterministic?
          Either.success(@active.head.node.zipper)
        else
          Either.failure("non-deterministic state")
        end
      end

      # @group Navigating the Tree
      #########################################################################

      # @return [Either<Values::AbstractVal>]
      def node
        if deterministic?
          Either.success(@active.head.node.zipper.node)
        else
          Either.failure("non-deterministic state")
        end
      end

      # @return [Either<StateMachine>]
      def first
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          until value.node.segment?
            value = value.down
            state = state.down
          end

          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # @return [Either<StateMachine>]
      def last
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          until value.node.segment?
            value = value.down.last
            state = state.down.last
          end

          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # @return [StateMachine]
      def next(count = 1)
        active = @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          count.times do
            while not value.root? and value.last?
              value = value.up
              state = state.up
            end

            if value.root?
              return Either.failure("cannot move to next after last segment")
            end

            value = value.next
            state = state.next

            until value.node.segment?
              value = value.down
              state = state.down
            end
          end

          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # @return [Either<StateMachine>]
      def prev(count = 1)
        active = @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          count.times do
            while not value.root? and value.first?
              value = value.up
              state = state.up
            end

            if value.root?
              return Either.failure("cannot move to prev before first segment")
            end

            state = state.prev
            value = value.prev

            until value.node.segment?
              value = value.down.last
              state = state.down.last
            end
          end

          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # @return [Either<StateMachine>]
      def find(id, *elements)
        reachable = false
        matches   = []

        @active.each do |zipper|
          segment_tok  = mksegment_tok(zipper.node.segment_dict, id, elements)
          instructions = zipper.node.instructions.matches(segment_tok, true)
          matched      = false
          reachable  ||= !instructions.empty?

          instructions.each do |op|
            break if matched

            state = zipper
            value = zipper.node.zipper

            op.pop_count.times do
              value = value.up
              state = state.up
            end

            # The state we're searching for will have an ancestor state
            # with this instruction table
            target = zipper.node.instructions.pop(op.pop_count).drop(op.drop_count)

            until state.last?
              state = state.next
              value = value.next

              if target.eql?(state.node.instructions)
                # Found the ancestor state. Often the segment belongs to this
                # state, but some states correspond to values which indirectly
                # contain segments (eg, TransactionSetVal does not have child
                # segments, it has TableVals which either contain a SegmentVal
                # or a LoopVal that contains a SegmentVal)
                _value = value
                _state = state

                until _value.node.segment?
                  _value = _value.down
                  _state = _state.down
                end

                if op.segment_use.nil? or op.segment_use.eql?(_value.node.usage)
                  unless _value.eql?(_state.node.zipper)
                    _state = _state.replace(_state.node.copy(:zipper => _value))
                  end

                  matches << _state
                  matched  = true
                  break
                end
              elsif target.length > state.node.instructions.length
                # The ancestor state isn't one of the rightward siblings, since
                # the length of instruction tables is non-increasing as we move
                # rightward
                break
              end
            end
          end
        end

        if not reachable
          raise Exceptions::ParseError,
            "#{id} segment cannot be reached from the current state"
        elsif matches.empty?
          Either.failure("#{id} segment does not occur")
        else
          Either.success(StateMachine.new(@config, matches))
        end
      end

    private

      # @return [Array<Zipper::AbstractCursor>]
      def roots
        @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          zipper.depth.times do
            value = value.up
            state = state.up
          end

          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

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
