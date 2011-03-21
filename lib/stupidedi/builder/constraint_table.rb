module Stupidedi
  module Builder

    #
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
      abstract :matches, :args => %w(segment_tok)

      #
      # Performs no filtering of the {Instruction} list. This is used when there
      # already is a single {Instruction} or when a {Reader::SegmentTok} doesn't
      # provide any more information to filter the list.
      #
      class Stub < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok)
          @instructions
        end
      end

      #
      # Chooses the {Instruction} that pops the fewest number of states.
      #
      class DepthBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok)
          @__matches ||= begin
            deepest = @instructions.head

            @instructions.tail.each do |i|
              if i.pop_count < deepest.pop_count
                deepest = i
              end
            end

            deepest.cons
          end
        end
      end

      #
      # Chooses the subset of {Instruction} values based on the distinguishing
      # values allowed by each {Schema::SegmentUse}. If none of the
      # {Instruction} values have {Schema::SegmentUse} values that restrict
      # allowed element values, it will behave identically to {Stub}.
      #
      class ValueBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok)
          element_toks = segment_tok.element_toks

          @__basis ||= basis(deepest(@instructions))
          @__basis.head.each do |(n, m), map|
            value = deconstruct(element_toks, n, m)
            unless value.nil?
              match = map.at(value)
              unless match.nil?
                return match
              end
            end
          end

          # @todo: If we reach this line, none of the elements present in the
          # SegmentTok could distinguish its Instruction/SegmentUse alone. Now
          # we should check @__basis.last for elements that can iteratively
          # narrow down the search space. This is a bit complicated, since we
          # should order the filters according to their probable effectiveness,
          # so we might be able to terminate early without having to evaluate
          # each one. For now, we'll just return all the instructions and hope
          # that the grammar sorts it out after reading more tokens.

          @instructions
        end

      private

        # Resolve conflicts between instructions that have identical SegmentUse
        # values. For each SegmentUse, this chooses the Instruction that pops
        # the fewest number of states.
        #
        # @return [Array<Instruction>]
        def deepest(instructions)
          deepest = Hash.new

          instructions.each do |i|
            key = i.segment_use.object_id

            if deepest.defined_at?(key)
              if deepest.at(key).pop_count > i.pop_count
                deepest[key] = i
              end
            else
              deepest[key] = i
            end
          end

          deepest.values
        end

        # @return [Array(Array<(Integer, Integer, Map)>, Array<(Integer, Integer, Map)>)]
        def basis(instructions)
          disjoint_elements = []
          distinct_elements = []

          element_uses = instructions.head.segment_use.definition.element_uses

          # Iterate over each element across all SegmentUses (think columns)
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

                # We want to know if every Instruction's set of allowed values
                # is disjoint (with one another). Instead of comparing each set
                # with every other set, which takes (N-1)! comparisons, we can
                # do it in N steps.
                disjoint &&= allowed_vals.disjoint?(total)

                # We also want to know if one Instruction's set of allowed vals
                # contains elements that aren't present in at least one other
                # set. The opposite of this condition is easy to test: all sets
                # contain the same elements (are equal). So we can similarly
                # check this condition in N steps rather than (N-1)!
                distinct ||= allowed_vals != last unless last.nil?

                total = allowed_vals.union(total)
                last  = allowed_vals
              end

            # puts "#{n}.#{m}: disjoint(#{disjoint}) distinct(#{distinct})"

              if disjoint
                # Since each Instruction's set of allowed values is disjoint, we
                # can build a function/hash that returns the single Instruction
                # given one of the values. When given a value outside the set of
                # all (combined) values, it returns nil.
                disjoint_elements << [[n, m], build_disjoint(total, n, m, instructions)]
              elsif distinct
                # Not all Instructions have the same set of allowed values. So
                # we can build a function/hash that accepts one of the values
                # and returns the subset of the Instructions where that value
                # can occur. This might be some, none, or all of the original
                # Instructions, so clearly this provides less information than
                # if each allowed value set was disjoint.

              # distinct_elements << [[n, m], build_distinct(total, n, m, instructions)]
              end
            end
          end

          [disjoint_elements, distinct_elements]
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
        # @param [Array<Reader::SimpleElementTok, Reader::CompositeElementTok>] element_toks
        # @param [Integer] m
        # @param [Integer, nil] n
        #
        # @return [String, nil]
        def deconstruct(element_toks, m, n)
          element_tok = element_toks.at(m)

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

      # Given a list of {Instruction} values for the same segment identifier,
      # this method constructs the appropriate concrete subclass of
      # {ConstraintTable}.
      #
      # @param [Array<Instruction>] instructions
      # @return [ConstraintTable]
      def build(instructions)
        unless instructions.length > 1
          return ConstraintTable::Stub.new(instructions)
        end

        # When one of the instructions has a nil segment_use, it means
        # the SegmentUse is determined when pushing the new state. There
        # isn't a way to know the segment constraints from here.
        if instructions.any?{|i| i.segment_use.nil? }
          return ConstraintTable::Stub.new(instructions)
        end

        segment_uses = instructions.map{|i| i.segment_use }

        # The same SegmentUse may appear more than once, because the
        # segment can be placed at different levels in the tree. If
        # all the instructions have the same SegmentUse, we can't use
        # segment constraints to narrow down the instruction list.
        unless segment_uses.map{|u| u.object_id }.uniq.length > 1
          return ConstraintTable::DepthBased.new(instructions)
        end

        return ConstraintTable::ValueBased.new(instructions)
      end
    end

  end
end
