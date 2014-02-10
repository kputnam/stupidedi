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
      # @return [Either<Integer>]
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

      # Extracts the segment from the current state, if the current state is
      # deterministic and positioned on a segment.
      #
      # @return [Either<Values::SegmentVal>>]
      def segmentn
        segment.map(&:node)
      end

      # Extracts the *mth* element from the current segment, if the current
      # state is deterministic. Accepts optional arguments to extract a specific
      # occurrence of a repeated element and/or a specific component from a
      # composite element.
      #
      # @return [Either<Zipper::AbstractCursor<Values::AbstractElementVal>>]
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

            limit = value.node.usage.repeat_count
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

      # Extracts the *mth* element from the current segment, if the current
      # state is deterministic. Accepts optional arguments to extract a specific
      # occurrence of a repeated element and/or a specific component from a
      # composite element.
      #
      # @return [Either<Values::AbstractElementVal>]
      def elementn(m, n = nil, o = nil)
        element(m, n, o).map(&:node)
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
      # @return [Either<StateMachine>]
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
      # excluding {Values::InvalidSegmentVal}s, that satisfies the given element
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
      # including {Values::InvalidSegmentVal}s, that satisfies the given element
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

      # Convenience method to iterate repeated occurrences of a segment by
      # iteratively calling `find`. Beware this doesn't check that the segment
      # is allowed to repeat, so calling `iterate(:XYZ)` may yield an `XYZ`
      # segment and then throw an exception when searching for the second, if
      # `XYZ` is not repeatable.
      #
      # @yieldparam   [StateMachine]
      # @yieldreturn  [Object]
      # @return       [Either<Array<Object>>]
      def iterate(id, *elements)
        a = []
        m = find(id, *elements)
        return m unless m.defined?

        while m.defined?
          m = m.flatmap do |n|
            a << yield(n)
            n.find(id, *elements)
          end
        end

        Either.success(a)
      end

      # Sequence multiple traversals together, by iteratively calling
      # `find`. Each argument must be either a single segment ID or a
      # list whose first element is a segment ID and remaining elements
      # are segment constraints.
      #
      # @example
      #   machine.sequence(:GS, :ST, :HL)
      #   machine.sequence(:GS, [:ST, "837"], [:HL, nil, "20"])
      #
      # @return [Either<StateMachine>]
      def sequence(pattern, *patterns)
        patterns.inject(find(*pattern)) do |m, p|
          m = m.flatmap{|n| n.find(*p) }
        end
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

          grouped = instructions.runs do |a,b|
            a.push == b.push &&
              a.pop_count == b.pop_count &&
                a.drop_count == b.drop_count
          end

          grouped.each do |group|
            break if matched

            # Every transition follows the same shape
            # 1. Move upward a number of nodes
            # 2. Move left a number of nodes
            # 3. Move downward a number of nodes
            # 4. Stop on a segment

            op_,  = group
            state = zipper
            value = zipper.node.zipper

            # 1. Move upward (possibly zero times)
            op_.pop_count.times do
              value = value.up
              state = state.up
            end

            # 2. We know from the instruction `op` the *maximum* number of
            #    nodes to move left, but not exactly how many. Instead, we
            #    know what the InstructionTable is when we get there.
            target = zipper.node.instructions.pop(op_.pop_count).drop(op_.drop_count)

            # 3. If the segment we're searching for belongs in a new subtree,
            #    but it's not the only segment that might have "opened" that
            #    subtree (eg, Summary Table in 835 can begin with PLB or SE)
            #    then maybe the segment we're looking for comes *after* the
            #    first segment in this subtree.
            #
            #    This is computed lazily below: non_leaders ||= ...
            non_leaders = nil

            until state.last?
              state = state.next
              value = value.next
              ops   = group

              # 2. Even if the InstructionTable matches, we still need to
              #    descend to some segment and compare it to the criteria. In
              #    most circumstances, this segment is directly below this
              if target.eql?(state.node.instructions)

                # 3. Move downward a number of nodes. Ultimately, we need to
                #    descend to a segment, but we have to be careful...
                _value = value
                _state = state

                unless _value.node.segment?
                  _value = _value.down
                  _state = _state.down
                end

                while true
                  __value = _value
                  __state = _state

                  # Descend to the first segment
                  until __value.node.segment?
                    __value = __value.down
                    __state = __state.down
                  end

                  matched =
                    if __value.node.invalid?
                      invalid and not __filter?(filter_tok, __value.node)
                    else
                      # Note op.segment_use.nil? is true when searching for ISA,
                      # GS, and ST, because we can't know the SegmentUse until we
                      # deconstruct the token and looked up the versions numbers
                      # in the Config.
                      ops.any?{|op| op.segment_use.nil? or op.segment_use.eql?(__value.node.usage) } \
                        and not filter?(filter_tok, __value.node)
                    end

                  # 4. Stop on a segment
                  if matched
                    unless __value.eql?(__state.node.zipper)
                      __state = __state.replace(__state.node.copy(:zipper => __value))
                    end

                    matches << __state
                    break
                  end

                  ops = non_leaders     ||= group.reject do |op|
                    op.push.nil?        ||
                    op.segment_use.nil? ||
                    1 >= zipper.node.instructions.instructions.count do |x|
                      x.push.present? and
                       (# This is hairy, but we know the instruction is pushing some
                        # number of nested subtrees. We know from each AbstractState
                        # subclass that we both either push a single subtree
                        op.segment_use.parent.eql?(x.segment_use.try(:parent)) or
                        # Or this instruction pushes one subtree while the other one
                        # pushes two (eg, a new loop inside of a table)
                        op.segment_use.parent.eql?(x.segment_use.try(:parent).try(:parent)) or
                        # Or this instruction pushes two subtrees (eg, a new loop in
                        # a new table) and the other also pushes two subtrees.
                        op.segment_use.parent.parent.eql?(x.segment_use.try(:parent)))
                    end
                  end

                  break if ops.empty?
                  break if _value.last?

                  _value = _value.next
                  _state = _state.next
                end

                # 4. Stop on a segment
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
              "only simple and composite elements can be filtered"
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
              "only simple and composite elements can be filtered"
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
