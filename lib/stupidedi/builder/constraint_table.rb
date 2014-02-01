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
        def matches(segment_tok, strict)
          @instructions
        end
      end

      #
      # Chooses the {Instruction} that pops the greatest number of states. For
      # example, in the X222 837P an HL segment signals the start of a new
      # 2000 loop, but may or may not begin a new Table 2 -- the specifications
      # aren't actually clear. This rule will always create a new Table 2 and
      # a new 2000 loop under it.
      #
      class Shallowest < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
          @__matches ||= begin
            shallowest = @instructions.head

            @instructions.tail.each do |i|
              if i.pop_count > shallowest.pop_count
                shallowest = i
              end
            end

            shallowest.cons
          end
        end
      end

      #
      # The only exception to the rule of preferring the {Instruction} which pops
      # the greatest number of states is when the {Instruction} is for ISA. We want
      # to reuse one root {Values::TransmissionVal} container for all children.
      #
      class Deepest < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
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
      # values allowed by each {Schema::SegmentUse}. For instance, there are
      # often several loops that begin with `NM1`, which are distinguished by
      # the qualifier in element `NM101`.
      #
      class ValueBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # @return [Array<Instruction>]
        def matches(segment_tok, strict)
          invalid = true  # Were all possibly distinguishing elements invalid?
          present = false # Were any possibly distinguishing elements present?

          @__basis ||= basis(shallowest(@instructions))
          @__basis.head.each do |(n, m), map|
            value = deconstruct(segment_tok.element_toks, n, m)

            case value
            when nil, :not_used, :default
              # ignore
            else
              singleton = map.at(value)
              present   = true

              unless singleton.nil?
                return singleton
              else
                if strict
                  designator = "#{segment_tok.id}#{'%02d' % (n + 1)}"
                  designator << "-%02d" % m unless m.nil?

                  raise ArgumentError,
                    "#{value.inspect} is not allowed in #{designator}"
                end
              end
            end
          end

          # If we reach this line, none of the present elements could, on its
          # own, narrow the search space to a single Instruction. We now test
          # the combination of elements to iteratively narrow the search space
          space = @instructions

          # @todo: These filters should be ordered by probable effectiveness,
          # so we narrow the search space by the largest amount in the fewest
          # number of steps.
          @__basis.last.each do |(n, m), map|
            value = deconstruct(segment_tok.element_toks, n, m)

            unless value.nil?
              subset  = map.at(value)
              present = true

              unless subset.blank?
                invalid = false
                space  &= subset

                if space.length <= 1
                  return space
                end
              else
                if strict
                  designator = "#{segment_tok.id}#{'%02d' % n}"
                  designator << "-%02d" % m unless m.nil?

                  raise ArgumentError,
                    "#{value.inspect} is not allowed in #{designator}"
                end
              end
            end
          end

          if invalid and present
            []
          else
            space
          end
        end

      private

        # Resolve conflicts between instructions that have identical SegmentUse
        # values. For each SegmentUse, this chooses the Instruction that pops
        # the greatest number of states.
        #
        # @return [Array<Instruction>]
        def shallowest(instructions)
          shallowest = Hash.new

          instructions.each do |i|
            key = i.segment_use.object_id

            if shallowest.defined_at?(key)
              if shallowest.at(key).pop_count < i.pop_count
                shallowest[key] = i
              end
            else
              shallowest[key] = i
            end
          end

          shallowest.values
        end

        # @return [Array(Array<(Integer, Integer, Map)>, Array<(Integer, Integer, Map)>)]
        def basis(instructions)
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
            instructions.head.segment_id == :ISA ?
              ConstraintTable::Deepest.new(instructions) :
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
