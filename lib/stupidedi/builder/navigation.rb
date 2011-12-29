module Stupidedi
  module Builder

    module Navigation

      # @group Querying the Current Position
      #########################################################################

      # @return [Array<InstructionTable>]
      def successors
        @active.map{|a| a.node.instructions }
      end

      # Is there exactly one valid parse tree in the current state?
      def deterministic?
        @active.length == 1
      end

      def empty?
        value = @active.head.node.zipper

        until value.root?
          value = value.up
        end

        value.node.children.empty?
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

      # Returns the number of segments apart the current state is from the
      # given `StateMachine`'s state. Note the direction is not indicated by
      # the return value, so `a.distance(b) == b.distance(a)` for all states
      # `a` and `b`.
      #
      # @example
      #   m.distance(m)                          #=> Either.success(0)
      #   m.next(10).flatmap{|n| n.distance(m) } #=> Either.success(10)
      #
      # @return [Integer]
      #
      # @note This method uses AbstractCursor#between, which assumes the two
      #   cursors point to the same tree. If that is not the case, the results
      #   are undefined.
      def distance(other)
        zipper.flatmap do |a|
          other.zipper.map do |b|
            a.between(b).count(&:segment?) - 1
          end
        end
      end

      # @group Accessing the Current Node
      #########################################################################

      # Returns the current position within the parse tree, if the current state
      # is deterministic.
      #
      # @return [Either<Zipper::AbstractCursor<Values::AbstractVal>>]
      def zipper
        if deterministic?
          Either.success(@active.head.node.zipper)
        else
          Either.failure("non-deterministic state")
        end
      end

      # Extracts the segment from the current state, if the current state is
      # deterministic and positioned on a segment.
      #
      # @return [Either<Zipper::AbstractCursor<Values::SegmentVal>>]
      def segment
        zipper.flatmap do |z|
          if z.node.segment?
            Either.success(z)
          else
            Either.failure("not a segment")
          end
        end
      end

      # Extracts the *mth* element from the current segment, if the current
      # state is deterministic. Accepts optional arguments to extract a specific
      # occurrence of a repeated element and/or a specific component from a
      # composite element.
      #
      # @return [Either<Zipper::AbstractCUrsor<Values::AbstractElementVal>>]
      def element(m, n = nil, o = nil)
        segment.flatmap do |s|
          unless m >= 1
            raise ArgumentError,
              "argument must be positive"
          end

          if s.node.invalid?
            # InvalidSegmentVal doesn't have child AbstractElementVals, its
            # children are SimpleElementTok, CompositeElementTok, etc, which
            # are not parsed values.
            return Either.failure("invalid segment")
          end

          designator = s.node.id.to_s
          definition = s.node.definition
          length     = definition.element_uses.length

          unless m <= length
            raise ArgumentError,
              "#{designator} segment has only #{length} elements"
          end

          designator << "%02d" % m
          value       = s.child(m - 1)

          if n.nil?
            return Either.success(value)
          elsif value.node.repeated?
            unless n >= 1
              raise ArgumentError,
                "argument must be positive"
            end

            limit = value.node.definition.repeat_count
            unless limit.include?(n)
              raise ArgumentError,
                "#{designator} can only occur #{limit.max} times"
            end

            unless value.node.children.defined_at?(n - 1)
              return Either.failure("#{designator} occurs only #{value.node.children.length} times")
            end

            value = value.child(n - 1)
            n, o  = o, nil

            return Either.success(value) if n.nil?
          end

          unless value.node.composite?
            raise ArgumentError,
              "#{designator} is a simple element"
          end

          unless o.nil?
            raise ArgumentError,
              "#{designator} is a non-repeatable composite element"
          end

          unless n >= 1
            raise ArgumentError,
              "argument must be positive"
          end

          length = definition.element_uses.at(m - 1).definition.component_uses.length
          unless n <= length
            raise ArgumentError,
              "#{designator} has only #{length} components"
          end

          if value.node.empty?
            Either.failure("#{designator} is empty")
          else
            Either.success(value.child(n - 1))
          end
        end
      end

      # @group Navigating the Tree
      #########################################################################

      # Returns a new `StateMachine` positioned on the first segment in
      # the parse tree, if there are any segments in the parse tree.
      #
      # @return [Either<StateMachine>]
      def first
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          until value.node.segment? or value.leaf?
            value = value.down
            state = state.down
          end

          unless value.node.segment?
            return Either.failure("no segments")
          end

          # Synchronize the two parallel state and value nodes
          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # Returns a new `StateMachine` positioned on the last segment in
      # the parse tree, if there are any segments in the parse tree.
      #
      # @return [Either<StateMachine>]
      def last
        active = roots.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          until value.node.segment? or value.leaf?
            value = value.down.last
            state = state.down.last
          end

          unless value.node.segment?
            return Either.failure("no segments")
          end

          # Synchronize the two parallel state and value nodes
          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # Returns a new `StateMachine` positioned on the first segment of the
      # parent structure. For example, when the current segment belongs to a
      # loop but it's not the first segment in that loop, this method will
      # rewind to the first segment in the loop. If the current position is
      # the first segment of a loop, this method will rewind to the first
      # segment in the loop's parent structure.
      #
      # @return [Either<StateMachine>]
      def parent
        active = []

        @active.each do |zipper|
          state = zipper
          value = zipper.node.zipper

          while value.first? and not value.root?
            value = value.up
            state = state.up
          end

          if value.root?
            break
          end

          value = value.first
          state = state.first

          until value.node.segment?
            value = value.down
            state = state.down
          end

          # Synchronize the two parallel state and value nodes
          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          active << state
        end

        if active.empty?
          Either.failure("no parent segment")
        else
          Either.success(StateMachine.new(@config, active))
        end
      end

      # Returns a new `StateMachine` positioned on the next segment, if
      # there is a next segment. Optionally, a `count` argument may be
      # provided that indicates how many segments to advance.
      #
      # @return [StateMachine]
      def next(count = 1)
        unless count > 0
          raise ArgumentError,
            "count must be positive"
        end

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

          # Synchronize the two parallel state and value nodes
          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # Returns a new `StateMachine` positioned on the previous segment, if
      # there is a previous segment. Optionally, a `count` argument may be
      # provided that indicates how many segments to rewind.
      #
      # @return [Either<StateMachine>]
      def prev(count = 1)
        unless count > 0
          raise ArgumentError,
            "count must be positive"
        end

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

          # Synchronize the two parallel state and value nodes
          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end

        Either.success(StateMachine.new(@config, active))
      end

      # Returns a `StateMachine` positioned on the next matching segment,
      # excluding {InvalidSegmentVal}s, that satisfies the given element
      # constraints. The search space is limited to certain related elements
      # described in [Navigating.md]
      #
      # @example
      #   machine.find(:ST, nil, nil, "005010X222")
      #
      # @return [Either<StateMachine>]
      def find(id, *elements)
        __find(false, id, elements)
      end

      # Returns a `StateMachine` positioned on the next matching segment,
      # including {InvalidSegmentVal}s, that satisfies the given element
      # constraints. The search space is limited to certain related elements
      # described in [Navigating.md]
      #
      # @example
      #   machine.find!(:ST, nil, nil, "005010X222")
      #
      # @return [Either<StateMachine>]
      def find!(id, *elements)
        __find(true, id, elements)
      end

      # @return [Integer]
      def count(id, *elements)
        __count(false, id, elements)
      end

      # @return [Integer]
      def count!(id, *elements)
        __count(true, id, elements)
      end

    private

      # @return [Either<StateMachine>]
      def __find(invalid, id, elements)
        reachable = false
        matches   = []

        @active.each do |zipper|
          matched      = false
          filter_tok   = mksegment_tok(zipper.node.segment_dict, id, elements, nil)

          instructions = zipper.node.instructions.matches(filter_tok, true)
          reachable  ||= !instructions.empty?

          instructions.each do |op|
            break if matched

            state = zipper
            value = zipper.node.zipper

            op.pop_count.times do
              value = value.up
              state = state.up
            end

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

                # In most cases, we need only to check the first segment under
                # this ancestor. However, certain structures have more than one
                # entry segment... hopefully only non-repeatable tables. For
                # example, transaction set 835's summary table has an optional
                # PLB segment followed by a mandatory SE segment, so the table
                # can begin with PLB or SE. When the user searches for SE, we
                # might descend into the table and see PLB, but this flag means
                # we should search the sibling segments, too (SE).
                multi   = _value.node.table?
                multi &&= target.instructions.count do |x|
                  x.segment_use.try(:parent) == op.segment_use.parent
                end > 1

                # Descend to the first segment
                until _value.node.segment?
                  _value = _value.down
                  _state = _state.down
                end

                # This loop only executes once if multi is false. Otherwise, it
                # checks the first segment and continues checking each sibling
                # until a match is found or there are no more sibling segments.
                while true
                  if op.segment_use.nil? or op.segment_use.eql?(_value.node.usage)
                    # Note op.segment_use.nil? is true of ISA, GS, and ST, since
                    # we can't know the SegmentUse until we've deconstructed the
                    # token and looked up the versions numbers in the Config.
                    if _value.node.valid?
                      break if filter?(filter_tok, _value.node)
                    else
                      break unless invalid
                      break if __filter?(filter_tok, _value.node)
                    end

                    # Synchronize the two parallel state and value nodes
                    unless _value.eql?(_state.node.zipper)
                      _state = _state.replace(_state.node.copy(:zipper => _value))
                    end

                    matches << _state
                    matched  = true
                    break
                  elsif invalid and _value.node.invalid?
                    break if __filter?(filter_tok, _value.node)

                    # Synchronize the two parallel state and value nodes
                    unless _value.eql?(_state.node.zipper)
                      _state = _state.replace(_state.node.copy(:zipper => _value))
                    end

                    matches << _state
                    matched  = true
                    break
                  end

                  break unless multi

                  # Scan through sibling nodes until we find another segment
                  _value = _value.next
                  _state = _state.next

                  unless _value.node.segment?
                    break if _value.last?
                    _value = _value.next
                    _state = _state.next
                  end

                  # No more siblings
                  break unless _value.node.segment?
                end

                break if matched
              elsif target.length > state.node.instructions.length
                # The ancestor state can't be one of the rightward siblings,
                # since the length of instruction tables is non-increasing as
                # we move rightward
                break
              end
            end
          end
        end

        if not reachable
          raise Exceptions::ParseError,
            "#{id} segment cannot be reached from the current state"
        elsif matches.empty?
          Either.failure("#{id}(#{elements.map(&:inspect).join(", ")}) segment does not occur")
        else
          Either.success(StateMachine.new(@config, matches))
        end
      end

      # Returns true if the constraints modeled in `filter_tok` are not
      # satisfied by the given `segment_val`, otherwise returns false.
      def filter?(filter_tok, segment_val)
        return true unless filter_tok.id == segment_val.id

        filter_tok.element_toks.zip(segment_val.children) do |f_tok, e_val|
          if f_tok.simple?
            return true unless f_tok.blank? or e_val == f_tok.value
          elsif f_tok.composite?
            f_tok.component_toks.zip(e_val.children) do |c_tok, c_val|
              return true unless c_tok.blank? or c_val == c_tok.value
            end
          elsif f_tok.present?
            raise Exceptions::ParseError,
              "only simple and component elements can be filtered"
          end
        end

        false
      end

      # Returns true if the constraints modeled in `filter_tok` are not
      # satisfied by the given `invalid_val`, otherwise returns false.
      def __filter?(filter_tok, invalid_val)
        return true unless filter_tok.id == invalid_val.id

        children = invalid_val.segment_tok.element_toks
        filter_tok.element_toks.zip(children) do |f_tok, e_tok|
          if f_tok.simple?
            return true unless f_tok.blank? or f_tok.value == e_tok.value
          elsif f_tok.composite?
            children = e_tok.component_toks
            f_tok.component_toks.zip(children) do |f_com, e_com|
              return true unless f_com.blank? or f_com.value == e_com.value
            end
          elsif f_tok.present?
            raise Exceptions::ParseError,
              "only simple and component elements can be filtered"
          end
        end

        false
      end

      # @return [Integer]
      def __count(invalid, id, elements)
        cursor = __find(invalid, id, elements)
        count  = 0

        while cursor.defined?
          count += 1
          cursor = cursor.flatmap{|c| c.send(:__find, invalid, id, elements) }
        end

        count
      end

      # Returns the cursor positioned at the root of the parse tree linked
      # from each state.
      #
      # @return [Array<Zipper::RootCursor>]
      def roots
        @active.map do |zipper|
          state = zipper
          value = zipper.node.zipper

          zipper.depth.times do
            value = value.up
            state = state.up
          end

          # Synchronize the two parallel state and value nodes
          unless value.eql?(state.node.zipper)
            state = state.replace(state.node.copy(:zipper => value))
          end

          state
        end
      end

    end

  end
end
