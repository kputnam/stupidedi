module Stupidedi
  module Builder_

    class ConstraintTable

      class Stub < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        def matches(segment_tok)
          @instructions
        end
      end

      class DepthBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        # Each matching instruction produces a unique parse tree containing
        # the new token; more than one instruction creates non-determinism,
        # but often the difference between instructions is how tightly the
        # segment binds to the current subtree.
        #
        # For instance, "HL*20" always indicates a new 2000B loop. However,
        # if the parse tree is currently already within "Table 2 - Provider",
        # we could either place the 2000B loop within the current table or we
        # could create a new occurence of "Table 2 - Provider" as the parent
        # of the 2000B loop.
        #
        # This block of code dicards all instructions except those that most
        # tightly bind the segment. Note that without performing this filter,
        # we would end up with parse trees that accept exactly the same set
        # of tokens -- meaning the trees will never converge.
        def matches(segment_tok)
          @__matches ||= begin
            deepest = @instructions.head

            @instructions.tail.each do |i|
              if i.pop_count < deepest.pop_count
                deepest = i
              end
            end

            deepest
          end
        end
      end

      class ValueBased < ConstraintTable
        def initialize(instructions)
          @instructions = instructions
        end

        def matches(segment_tok)
          element_toks = segment_tok.element_toks

          @__basis ||= basis(deepest(@instructions))
          @__basis.head.each do |(n, m), map|
            if value = select(element_toks, n, m)
              if match = map.at(value)
                return match
              end
            end
          end

          @instructions
        end

      private

        #
        def deepest(instructions)
          deepest = Hash.new

          instructions.each do |i|
            key = i.segment_use

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

        def basis(instructions)
          disjoint_elements = []
          distinct_elements = []

          element_uses = instructions.head.segment_use.definition.element_uses

          # For each element across all SegmentUses (think columns/vectors)
          element_uses.length.times do |n|
            if element_uses.at(n).composite?
              ms = 0 .. element_uses.at(n).definition.component_uses.length - 1
            else
              ms = [nil]
            end

            ms.each do |m|
              last  = nil       # the last subset we examined
              total = EmptySet  # the union of all examined subsets

              distinct = false
              disjoint = true

              instructions.each do |i|
                element_use = i.segment_use.definition.element_uses.at(n)

                unless m.nil?
                  element_use = element_use.definition.component_uses.at(m)
                end

                allowed_vals = element_use.allowed_values

                disjoint &&= allowed_vals.disjoint?(total)
                distinct ||= allowed_vals != last unless last.nil?

                total = allowed_vals.union(total)
                last  = allowed_vals
              end

            # puts "#{n}.#{m}: disjoint(#{disjoint}) distinct(#{distinct})"

              if disjoint
                disjoint_elements << [[n, m], build_disjoint(total, n, m, instructions)]
              elsif distinct
              # distinct_elements << [[n, m], build_distinct(total, n, m, instructions)]
              end
            end
          end

          [disjoint_elements, distinct_elements]
        end

        def build_disjoint(total, n, m, instructions)
          if total.finite?
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

      # def build_distinct(total, n, m, instructions)
      #   if total.finite?
      #     map = Hash.new{|h,k| h[k] = [] }

      #     instructions.each do |i|
      #       element_use  = i.segment_use.definition.element_uses.at(n)

      #       unless m.nil?
      #         element_use = element_use.definition.component_uses.at(m)
      #       end

      #       allowed_vals = element_use.allowed_values
      #       allowed_vals.each{|v| map[v] << i }
      #     end

      #     # Clear the default_proc so accesses don't change the Hash
      #     map.default = []
      #     map
      #   else
      #     map = Hash.new{|h,k| h[k] = instructions }

      #     instructions.each do |i|
      #       element_use  = i.segment_use.definition.element_uses.at(n)

      #       unless m.nil?
      #         element_use = element_use.definition.component_uses.at(m)
      #       end

      #       allowed_vals = element_use.allowed_values

      #       unless allowed_vals.finite?
      #         allowed_vals.complement.each{|v| map[v] -= i }
      #       end
      #     end

      #     # Clear the default_proc so accesses don't change the Hash
      #     map.default = instructions
      #     map
      #   end
      # end

        # @return [String, nil]
        def select(element_toks, m, n)
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
