# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    module Navigation
      #########################################################################
      # @group Querying the Current Position

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
        if m <= 0 or (n || 1) <= 0 or (o || 1) <= 0
          raise ArgumentError,
            "all arguments must be positive"
        end

        if n.nil? and not o.nil?
          raise ArgumentError,
            "third argument cannot be present unless second argument is present"
        end

        segment.flatmap do |s|
          if s.node.invalid?
            # InvalidSegmentVal doesn't have child AbstractElementVals, its
            # children are SimpleElementTok, CompositeElementTok, etc, which
            # are not parsed values.
            return Either.failure("invalid segment")
          end

          segment_id  = s.node.id.to_s
          segment_def = s.node.definition
          descriptor  = segment_id

          unless m <= segment_def.element_uses.length
            raise ArgumentError,
              "segment #{descriptor} has only #{segment_def.element_uses.length} elements"
          end

          element_use = segment_def.element_uses.at(m - 1)
          element_def = element_use.definition
          element_zip = s.child(m - 1)

          if n.nil?
            return Either.success(element_zip)

          elsif element_use.composite? and not element_use.repeatable?
            # m: element   of segment
            # n: component of composite element
            # o: occurence of repeated component
            descriptor = "%s%02d" % [segment_id, m]
            components = element_def.component_uses.length
            unless n <= components
              raise ArgumentError,
                "composite element #{descriptor} only has #{components} components"
            end

            # component_use = element_def.component_uses.at(n - 1)

            if o.nil?
              # This is a component of a composite element
              return Either.success(element_zip.child(n - 1))

            # @todo: There currently doesn't seem to be any instances of this in
            # the real world (a composite element that has a component that can
            # repeat), but perhaps this will happen in the future.
            #
            # elsif component_use.repeatable?
            #   repeat_count = component_use.repeat_count
            #   occurs_count = component_val.children.length
            #   descriptor   = "%s%02d-%02d" % [segment_id, m, n]
            #   unless repeat_count.include?(o)
            #     raise ArgumentError,
            #       "repeatable component element #{descriptor} can only occur #{repeat_count.max} times"
            #   end
            #   component_zip = element_zip.child(n - 1)
            #   if component_zip.node.blank?
            #     return Either.failure("repeating component element #{descriptor} is blank")
            #   elsif occurs_count < n
            #     return Either.failure("repeating component element #{descriptor} only occurs #{occurs_count} times")
            #   else
            #     return Either.success(component_zip.child(o - 1))
            #   end

            else
              descriptor = "%s%02d-%02d" % [segment_id, m, n]
              raise ArgumentError,
                "component element #{descriptor} cannot be further deconstructed"
            end

          elsif element_use.repeatable?
            # m: element   of segment
            # n: occurence of repeated element
            # o: component of composite element
            descriptor   = "%s%02d" % [segment_id, m]
            occurs_count = element_zip.children.count
            unless element_use.repeat_count.include?(n)
              raise ArgumentError,
                "repeatable element #{descriptor} can only occur #{element_use.repeat_count.max} times"
            end

            if o.nil?
              description = (element_use.composite?) ? "repeatable composite" : "repeatable"
              if element_zip.node.blank?
                return Either.failure("#{description} element #{descriptor} does not occur")
              elsif occurs_count < n
                return Either.failure("#{description} element #{descriptor} only occurs #{occurs_count} times")
              else
                return Either.success(element_zip.child(n - 1))
              end

            elsif element_use.composite?
              components = element_def.component_uses.length
              unless o <= components
                raise ArgumentError,
                  "repeatable composite element #{descriptor} only has #{components} components"
              end

              descriptor = "%s%02d" % [segment_id, m]

              if element_zip.node.blank?
                return Either.failure("repeatable composite element #{descriptor} does not occur")
              elsif occurs_count < n
                return Either.failure("repeatable composite element #{descriptor} only occurs #{occurs_count} times")
              else
                component_zip = element_zip.children.at(n - 1)
                return Either.success(component_zip.child(o - 1))
              end

            else
              raise ArgumentError,
                "repeatable element #{descriptor} cannot be further deconstructed"
            end

          else
            raise ArgumentError,
              "#{segment_id}#{"%02d" % m} is not a composite or repeated element"
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
        m = __find(false, id, elements, true)
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
      def __find(invalid, id, elements, assert_repeatable = false)
        reachable   = false
        repeatable  = false
        matches     = []
        filter_tok  = nil

        @active.each do |zipper|
          matched      = false
          filter_tok ||= mksegment_tok(zipper.node.segment_dict, id, elements, nil)

          instructions = zipper.node.instructions.matches(filter_tok, true, :find)
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

            if assert_repeatable
              # We have to do some extra work here, because `target` below won't
              # have the additional instructions that could be added by calling
              # `.push` on the new state class
              repeatable ||= begin
                suppose  = StateMachine.new(@config, [state])
                suppose, = suppose.execute(op_, state, nil, filter_tok)
                suppose.node.instructions.matches(filter_tok, true, :find).present?
              end
            end

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
            # non_leaders = nil

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
                      # @note op.segment_use.nil? is true when searching for ISA,
                      # GS, and ST, because we can't know the SegmentUse until we
                      # deconstruct the token and look up the versions numbers
                      # in the Config
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

                  # ops = non_leaders     ||= group.reject do |op|
                  #   op.push.nil?        ||
                  #   op.segment_use.nil? ||
                  #   1 >= zipper.node.instructions.instructions.count do |x|
                  #     x.push.present? and
                  #      (# This is hairy, but we know the instruction is pushing some
                  #       # number of nested subtrees. We know from each AbstractState
                  #       # subclass that we both either push a single subtree
                  #       op.segment_use.parent.eql?(x.segment_use.try(:parent)) or
                  #       # Or this instruction pushes one subtree while the other one
                  #       # pushes two (eg, a new loop inside of a table)
                  #       op.segment_use.parent.eql?(x.segment_use.try(:parent).try(:parent)) or
                  #       # Or this instruction pushes two subtrees (eg, a new loop in
                  #       # a new table) and the other also pushes two subtrees.
                  #       op.segment_use.parent.parent.eql?(x.segment_use.try(:parent)))
                  #   end
                  # end

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

        if assert_repeatable and not repeatable
          raise Exceptions::ParseError,
            "segment #{filter_tok.to_x12(Reader::Separators.default)} is not repeatable"
        elsif not reachable
          raise Exceptions::ParseError,
            "segment #{filter_tok.to_x12(Reader::Separators.default)} cannot be reached"
        elsif matches.empty?
          Either.failure("segment #{filter_tok.to_x12(Reader::Separators.default)} does not occur")
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
