# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    # The {ConstraintTable} is a data structure that contains one or more
    # {Instruction} values for the same segment identifier. Each concrete
    # subclass implements different strategies for narrowing down the
    # {Instruction} list.
    #
    # Reducing the number of valid {Instruction} values is important because
    # executing more than one {Instruction} creates a non-deterministic state --
    # more than one valid parse tree exists -- which slows the parser. Most
    # often there is only one valid {Instruction} but the parser cannot
    # (efficiently or at all) narrow the tree down without evaluating the
    # constraints declared by each {Instruction}'s {Schema::SegmentUse}, which
    # is done here.
    #
    class ConstraintTable
      # @return [Array<Instruction>]
      abstract :matches, :args => %w(segment_tok strict mode state)

      # @return [Array<Instruction>]
      attr_reader :instructions

      def copy(changes = {})
        self.class.new \
          changes.fetch(:instructions, instructions)
      end

      # @return [void]
      # :nocov:
      def pretty_print(q)
        name = self.class.name.split("::").last
        q.text "#{name}.build"
        q.group(2, "([", "])") do
          q.breakable
          instructions.each do |op|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp op
          end
        end
      end
      # :nocov:

      # @todo
      def critique(segment_tok, segment_uses)
      end

      # Performs no filtering of the {Instruction} list. This is used when there
      # already is a single {Instruction} or when a {Tokens::SegmentTok} doesn't
      # provide any more information to filter the list.
      #
      class Stub < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict, mode, state = nil)
          @instructions.tap do |xs|
            critique(segment_tok, xs.map(&:segment_use)) if strict
          end
        end
      end

      # Chooses the {Instruction} that pops the fewest number of states. For
      # example, in the X222 837P an HL segment signals the start of a new
      # 2000 loop, but may or may not begin a new Table 2 -- the specifications
      # aren't actually clear. This rule will not create a new Table 2, but
      # just add a new 2000 loop under the current one.
      #
      class Shallowest < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict, mode, state = nil)
          @__matches ||= begin
            shallowest = @instructions.map(&:pop_count).min
            @instructions.select{|i| i.pop_count == shallowest }.tap do |xs|
              critique(segment_tok, xs.map(&:segment_use)) if strict
            end
          end
        end
      end

      # Chooses the subset of {Instruction} values based on the distinguishing
      # values allowed by each {Schema::SegmentUse}. For instance, there are
      # often several loops that begin with `NM1`, which are distinguished by
      # the qualifier in element `NM101`.
      #
      class ValueBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
          @__basis      = {}
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict, mode, state = nil)
          invalid = true  # Were all present possibly distinguishing elements invalid?
          present = false # Were any possibly distinguishing elements present?

          disjoint, distinct = basis(@instructions, mode)

          # First check single elements that can narrow the search space to
          # a single matching Instruction.
          disjoint.each do |(n, m), map|
            value = deconstruct(segment_tok.element_toks, n, m)

            case value
            when nil, :not_used, :default
              # value wasn't present in segment_tok, can't use it to decide
            else
              singleton = map.at(value.to_s)
              present   = true

              unless singleton.nil?
                # Success, search is terminated
                return singleton
              else
                if strict
                  designator = "#{segment_tok.id}#{"%02d" % (n + 1)}"
                  designator = designator + "-%02d" % (m + 1) unless m.nil?

                  raise ArgumentError,
                    "value #{value.to_s} is not allowed in element #{designator}"
                end
              end
            end
          end

          # If we reach this line, none of the present elements could, on its
          # own, narrow the search space to a single Instruction. We now test
          # the combination of elements to iteratively narrow the search space
          space = @instructions

          # @todo: These filters could be ordered by probable effectiveness,
          # so we narrow the search space by the largest amount in the fewest
          # number of steps.
          distinct.each do |(n, m), map|
            value = deconstruct(segment_tok.element_toks, n, m)

            unless value.nil?
              # Lookup which instructions are compatible with this input
              subset  = map.at(value)
              present = true

              unless subset.blank?
                invalid = false
                space  &= subset

                if space.length <= 1
                  # Success, search is terminated
                  return space
                end
              else
                # This value isn't compatible with any instruction
                if strict
                  designator = "#{segment_tok.id}#{"%02d" % (n + 1)}"
                  designator = designator + "-%02d" % (m + 1) unless m.nil?

                  raise ArgumentError,
                    "value #{value.to_s} is not allowed in element #{designator}"
                end
              end
            end
          end

          if invalid and present
            # Some elements were present, but all contained invalid values, and
            # even ignoring those we could not narrow the matches to a single
            # instruction.
            #
            # We could return the remaining search space, but it is safest to
            # mark this as an invalid segment and avoid the non-determinism
            []
          else
            # Some elements were present and none were invalid, but it was not
            # possible to narrow the set of matches to a single instruction.
            #
            # When the survivors are sibling slots in the same loop sharing a
            # segment id (e.g. two N3 slots in a partner-customised 4010 PO850
            # N1 loop), use the parser's current parse tree to pick the slot
            # whose preceding-sibling structure has actually been entered
            # (Variant A — structural reachability). The :insert gate skips
            # disambiguation during :find navigation, where the caller wants
            # the full set of candidates a segment could be bound to. For
            # genuinely ambiguous cases (different parent loops, or different
            # segment ids) the helper bails out to the full search space,
            # which will cause non-determinism in the parser.
            if mode == :insert
              disambiguate_sibling_slots(space, state)
            else
              space
            end
          end
        end

        # Resolve conflicts between instructions that have identical SegmentUse
        # values. For each SegmentUse, this chooses the Instruction that pops
        # the fewest number of states.
        #
        # @return [Array<Instruction>]
        def shallowest(instructions)
          grouped = instructions.group_by{|i| i.segment_use.object_id }
          grouped.flat_map do |k, is|
            shallowest = is.map(&:pop_count).min
            is.select{|i| i.pop_count == shallowest }
          end
        end

        # When ValueBased filtering leaves multiple Instructions whose
        # SegmentUses are sibling slots in the same parent loop sharing a
        # segment id, pick the slot whose ancestor structure has actually
        # been entered in the current parse tree. Concretely: among the
        # candidate sibling positions, keep only those greater than the
        # highest-position segment already consumed in the parent loop;
        # then pick the earliest among those. If `state` (and thus the
        # parse tree) is not available, fall back to picking the earliest
        # position outright (Variant B). Falls back to the input unchanged
        # when the precondition fails, preserving the existing non-
        # determinism error for genuinely ambiguous cases (e.g. survivors
        # in different parent loops).
        #
        # All survivors share a segment id by construction (instructions
        # are grouped by segment_id in InstructionTable#constraints before
        # ConstraintTable.build is called).
        #
        # @return [Array<Instruction>]
        def disambiguate_sibling_slots(instructions, state = nil)
          return instructions if instructions.length <= 1

          collapsed = shallowest(instructions)
          return collapsed if collapsed.length <= 1

          uses = collapsed.map(&:segment_use)
          parent = uses.first.parent
          return instructions if parent.nil?
          return instructions unless uses.all?{|u| u.parent.equal?(parent) }

          reachable = collapsed
          highest   = highest_consumed_position(state, parent) if state
          if highest
            # Strict `>` assumes non-repeating sibling slots: a candidate
            # whose position equals `highest` is excluded because that
            # slot has already been consumed. If a partner grammar exposes
            # repeating sibling slots, this may need to relax to `>=`.
            ahead = collapsed.select{|i| i.segment_use.position > highest }
            reachable = ahead unless ahead.empty?
          end

          min_pos = reachable.map{|i| i.segment_use.position }.min
          reachable.select{|i| i.segment_use.position == min_pos }
        end

        # Walks up from the state's value-tree zipper to find the LoopVal/
        # TableVal whose definition matches `parent` (object identity), then
        # returns the highest `usage.position` among its already-consumed
        # segment children. Returns nil when the matching container can't be
        # found (e.g. the loop hasn't been opened yet) or has no consumed
        # segments — both of which mean we have no structural signal to use.
        #
        # @return [Integer, nil]
        def highest_consumed_position(state, parent)
          return nil if state.nil?
          z = state.zipper
          while z
            node = z.node
            if (node.loop? or node.table?) and node.definition.equal?(parent)
              positions = node.children
                .select{|c| c.segment? and c.usage }
                .map{|c| c.usage.position }
              return positions.max if positions.any?
              return nil
            end
            break if z.root?
            z = z.up
          end
          nil
        end

        # @return [Array(Array<(Integer, Integer, Map)>, Array<(Integer, Integer, Map)>)]
        def basis(instructions, mode)
          @__basis[mode] ||= begin
            # When inserting segments, given a choice between two otherwise
            # equivalent instructions, prefer the one with smallest `pop_count`.
            # For example, when inserting an HL*20 in X221 835, the new 2000A
            # loop could potentially go in the current "Table 2 - Billing
            # Provider Detail" (smaller pop_count), or the parser could create
            # a whole new table (larger pop_count).
            #
            # When searching for segments in a parse tree (mode == :read), we
            # need to try both choices. That's because this "Table 2 - Billing
            # Provider Detail" could be followed by a different "Table 2 -
            # Subscriber Detail", which is then followed by another "Table 2 -
            # Billing Provider Detail". Then the next HL*20 would belong to the
            # uncle table, not the current table.
            if mode == :insert
              instructions = shallowest(instructions)
            end

            disjoint_elements = []
            distinct_elements = []

            # The first SegmentUse is used to represent the structure that must
            # be shared by the others: number of elements and type of elements
            element_uses = instructions.head.segment_use.definition.element_uses

            # Iterate over each element across all SegmentUses (think columns)
            #   NM1*[IL]*[  ]*..*..*..*..*..*[  ]*..*..*{..}*..
            #   NM1*[40]*[  ]*..*..*..*..*..*[  ]*..*..*{..}*..
            element_uses.length.times do |n|
              if element_uses.at(n).composite?
                ms = 0 .. element_uses.at(n).definition.component_uses.length - 1
              else
                ms = [nil]
              end

              # If this is a composite element, we iterate over each component.
              # Otherwise this loop iterates once with the index {m} set to nil.
              ms.each do |m|
                last  = nil        # the last subset we examined
                total = Sets.empty # the union of all examined subsets

                distinct = false
                disjoint = true

                instructions.each do |i|
                  element_use = i.segment_use.definition.element_uses.at(n)

                  unless m.nil?
                    element_use = element_use.definition.component_uses.at(m)
                  end

                  allowed_vals = element_use.allowed_values

                  # We want to know if every instruction's set of allowed values
                  # is disjoint (with one another). Instead of comparing each set
                  # with every other set, which takes (N-1)! comparisons, we can
                  # do it in N steps.
                  disjoint &&= allowed_vals.disjoint?(total)

                  # We also want to know if one instruction's set of allowed vals
                  # contains elements that aren't present in at least one other
                  # set. The opposite condition is easy to test: all sets contain
                  # the same elements (are equal). So we can similarly, check this
                  # condition in N steps rather than (N-1)!
                  distinct ||= allowed_vals != last unless last.nil?

                  total = allowed_vals.union(total)
                  last  = allowed_vals
                end

              # puts "#{n}.#{m}: disjoint(#{disjoint}) distinct(#{distinct})"

                if disjoint
                  # Since each instruction's set of allowed values is disjoint, we
                  # can build a function/hash that returns the single instruction,
                  # given one of the values. When given a value outside the set of
                  # all (combined) values, it returns nil.
                  disjoint_elements << [[n, m], build_disjoint(total, n, m, instructions)]
                elsif distinct
                  # Not all instructions have the same set of allowed values. So
                  # we can build a function/hash that accepts one of the values
                  # and returns the subset of the instructions where that value
                  # can occur. This might be some, none, or all of the original
                  # instructions, so clearly this provides less information than
                  # if each allowed value set was disjoint.

                  # Currently disabled (and untested) because it doesn't look like
                  # any of the HIPAA schemas would use this -- so testing it would
                  # be a pain.
                  #
                  distinct_elements << [[n, m], build_distinct(total, n, m, instructions)]
                end
              end
            end

            [disjoint_elements, distinct_elements]
          end
        end

        # @return [Hash<String, Array<Instruction>>]
        def build_disjoint(total, n, m, instructions)
          if total.finite?
            # The sum of all allowed value sets is finite, so we know that each
            # individual allowed value set is finite (we can iterate over it).
            map = Hash.new

            instructions.each do |i|
              element_use = i.segment_use.definition.element_uses.at(n)

              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values
              allowed_vals.each{|v| map[v] = i.cons }
            end

            map
          else
            # At least one of allowed value sets is infinite. This happens when
            # it is RelativeComplement, which declares the values that are *not*
            # allowed in the set.
            map = Hash.new{|h,k| h[k] = instructions }

            instructions.each do |i|
              element_use = i.segment_use.definition.element_uses.at(n)
              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values

              unless allowed_vals.finite?
                allowed_vals.complement.each{|v| map[v] -= i }
              end
            end

            # Clear the default_proc so accesses don't change the Hash
            map.default = instructions
            map
          end
        end

        # @return [Hash<String, Array<Instruction>>]
        def build_distinct(total, n, m, instructions)
          if total.finite?
            # The sum of all allowed value sets is finite, so we know that each
            # individual allowed value set is finite (we can iterate over it).
            map = Hash.new{|h,k| h[k] = [] }

            instructions.each do |i|
              element_use  = i.segment_use.definition.element_uses.at(n)

              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values
              allowed_vals.each{|v| map[v] << i }
            end

            # Clear the default_proc so accesses don't change the Hash
            map.default = []
            map
          else
            # At least one of allowed value sets is infinite. This happens when
            # it is RelativeComplement, which declares the values that are *not*
            # allowed in the set.
            map = Hash.new{|h,k| h[k] = instructions }

            instructions.each do |i|
              element_use  = i.segment_use.definition.element_uses.at(n)

              unless m.nil?
                element_use = element_use.definition.component_uses.at(m)
              end

              allowed_vals = element_use.allowed_values

              unless allowed_vals.finite?
                allowed_vals.complement.each{|v| map[v] -= i }
              end
            end

            # Clear the default_proc so accesses don't change the Hash
            map.default = instructions
            map
          end
        end

        # Return the value of the `m`-th elemnt, or if `n` is not nil, return
        # the value of the `n`-th component from the `n`-th element. When the
        # value is blank, the function returns `nil`.
        #
        # @param [Array<Tokens::SimpleElementTok, Tokens::CompositeElementTok>] element_toks
        # @param [Integer] m
        # @param [Integer, nil] n
        #
        # @return [String, nil]
        def deconstruct(element_toks, m, n)
          element_tok = element_toks.at(m)
          element_tok = element_tok.element_toks.at(0) if element_tok.try(:repeated?)

          if element_tok.blank?
            nil
          elsif n.nil?
            element_tok.value
          else
            element_tok = element_tok.component_toks.at(n)

            if element_tok.blank?
              nil
            else
              element_tok.value
            end
          end
        end
      end
    end

    class << ConstraintTable
      # @group Constructors
      #########################################################################

      # Given a list of {Instruction} values for the same segment identifier,
      # this method constructs the appropriate concrete subclass of
      # {ConstraintTable}.
      #
      # @param [Array<Instruction>] instructions
      # @return [ConstraintTable]
      def build(instructions)
        if instructions.length <= 1
          ConstraintTable::Stub.new(instructions)
        elsif instructions.any?{|i| i.segment_use.nil? } and
          not instructions.all?{|i| i.segment_use.nil? }
          # When one of the instructions has a nil segment_use, it means
          # the SegmentUse is determined when pushing the new state. There
          # isn't a way to know the segment constraints from here.
          ConstraintTable::Stub.new(instructions)
        else
          segment_uses = instructions.map{|i| i.segment_use }

          if segment_uses.map{|u| u.object_id }.uniq.length <= 1
            # The same SegmentUse may appear more than once, because the
            # segment can be placed at different levels in the tree. If
            # all the instructions have the same SegmentUse, they also have
            # the same element constraints so we can't use them to narrow
            # down the instruction list.
            ConstraintTable::Shallowest.new(instructions)
          else
            ConstraintTable::ValueBased.new(instructions)
          end
        end
      end

      # @endgroup
      #########################################################################
    end
  end
end
