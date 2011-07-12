module Stupidedi
  module Editor

    class TransactionSetEd < AbstractEd

      # @return [Config]
      attr_reader :config

      # @return [Time]
      attr_reader :received

      def initialize(config, received)
        @config, @received =
          config, received
      end

      def critique(st, acc)
        st.parent.tap do |gs|
          gs.parent.tap do |isa|
            critique_isa(isa, acc)
          end

          critique_gs(gs, acc)
        end

        acc.tap { critique_st(st, acc) }
      end

    private

      # Performs validations using the definition of the given ISA segment
      def critique_isa(isa, acc)
        isa.segment.tap do |x|
          envelope_def = x.node.definition.parent.parent

          # ...
        end
      end

      # Performs validations using the definition of the given GS segment
      def critique_gs(gs, acc)
        gs.segment.tap do |x|
          envelope_def = x.node.definition.parent.parent

          # ...
        end
      end

      # Performs validations using the definition of the given ST segment
      def critique_st(st, acc)
        st.segment.tap do |x|
          envelope_def = x.node.definition.parent.parent.parent

          # Transaction Set Identifier Code
          st.element(1).tap do |e|
            if e.node.present? and e.node.valid?
              unless e.node == envelope_def.id
                acc.ik502(e, "R", "6", "is not an allowed value")
              end
            end
          end

          st.parent.tap do |gs|
            # Functional Identifier Code
            gs.element(1).tap do |e|
              if e.node.present? and e.node.valid?
                unless e.node == envelope_def.functional_group
                  acc.ak905(e, "R", "1", "is not an allowed value")
                end
              end
            end
          end

          if config.editor.defined_at?(envelope_def)
            editor = config.editor.at(envelope_def)
            editor.new(config, received).critique(st, acc)
          end
        end

        st.zipper.tap do |zipper|
          until zipper.node.transaction_set?
            zipper = zipper.up
          end

          recurse(zipper, acc)
        end
      end

      # IK304 "3"   Segment must be present
      # IK304 "I6"  Segment must be present
      # IK304 "5"   Segment occurs too many times
      # IK304 "4"   Loop occurs too many times
      # IK304 "I7"  Loop must be present
      #
      # IK403 "1"   Element must be present
      # IK403 "I10" Element must not be present
      # IK403 "2"   Element must be present if other element(s) is (not) present
      # IK403 "6"   Element must contain at least one character
      # IK403 "4"   Element value is too short
      # IK403 "5"   Element value is too long
      # IK403 "6"   Element has invalid characters
      # IK403 "7"   Invalid code value
      # IK403 "8"   Invalid date
      # IK403 "9"   Invalid time

      def recurse(zipper, acc)
        if zipper.node.simple? or zipper.node.component?
          if zipper.node.invalid?
            if zipper.node.date?
              acc.ik403(zipper, "R", "8", "is not a valid date")
            elsif zipper.node.time?
              acc.ik403(zipper, "R", "8", "is not a valid time")
            elsif zipper.node.numeric?
              acc.ik403(zipper, "R", "6", "is not a valid number")
            else
              acc.ik403(zipper, "R", "6", "is not a valid string")
            end
          elsif zipper.node.blank?
            if zipper.node.usage.required?
              acc.ik403(zipper, "R", "1", "must be present")
            end
          elsif zipper.node.usage.forbidden?
            acc.ik403(zipper, "R", "I10", "must not be present")
          elsif not zipper.node.allowed?
            acc.ik403(zipper, "R", "7", "is not an allowed value")
          elsif zipper.node.too_long?
            acc.ik403(zipper, "R", "5", "is too long")
          elsif zipper.node.too_short?
            acc.ik403(zipper, "R", "4", "is too short")
          end

        elsif zipper.node.composite?
          if zipper.node.blank?
            if zipper.node.usage.required?
              acc.ik403(zipper, "R", "1", "must be present")
            end
          elsif zipper.node.usage.forbidden?
            acc.ik403(zipper, "R", "I10", "must not be present")
          else
            if zipper.node.present?
              zipper.children.each{|z| recurse(z, acc) }

              d = zipper.node.definition
              d.syntax_notes.each do |s|
                zs = s.errors(zipper)
                ex = s.reason(zipper) if zs.present?
                zs.each{|c| acc.ik403(c, "R", "2", ex) }
              end
            end
          end

        elsif zipper.node.repeated?
          zipper.children.each{|z| recurse(z, acc) }

        elsif zipper.node.segment?
          if zipper.node.valid?
            zipper.children.each do |element|
              recurse(element, acc)
            end

            zipper.node.definition.tap do |d|
              d.syntax_notes.each do |s|
                es = s.errors(zipper)
                ex = s.reason(zipper) if es.present?
                es.each{|c| acc.ik403(c, "R", "2", ex) }
              end
            end
          else
            acc.ik304(child, "R", "2", "unexpected segment")
          end

        elsif zipper.node.loop?
          group = Hash.new{|h,k| h[k] = [] }

          zipper.children.each do |child|
            # Child is either a segment or loop
            recurse(child, acc)

            if child.node.loop?
              group[child.node.definition] << child
            elsif child.node.valid?
              group[child.node.usage] << child
            end
          end

          # Though we're iterating the definition tree, we need to track
          # the last location before a required child was missing.
          last = zipper

          zipper.node.definition.children.each do |child|
            repeat  = child.repeat_count
            matches = group.at(child)

            if matches.blank? and child.required?
              if child.loop?
                acc.ik304(last, "R", "I7", "missing #{child.id} loop")
              else
                acc.ik304(last, "R", "3", "missing #{child.id} segment")
              end
            elsif repeat < matches.length
              matches.drop(repeat.max).each do |c|
                if child.loop?
                  acc.ik304(c, "R", "4", "loop occurs too many times")
                else
                  acc.ik304(c, "R", "5", "segment occurs too many times")
                end
              end
            end

            last = matches.last unless matches.blank?
          end

        elsif zipper.node.table?
          group = Hash.new{|h,k| h[k] = [] }

          zipper.children.each do |child|
            # Child is either a segment or loop
            recurse(child, acc)

            if child.node.loop?
              group[child.node.definition] << child
            elsif child.node.valid?
              group[child.node.usage] << child
            end
          end

            # Though we're iterating the definition tree, we need to track
            # the last location before a required child was missing.
            last = zipper

          zipper.node.definition.children.each do |child|
            matches = group.at(child)
            repeat  = child.repeat_count

            if matches.blank? and child.required?
              if child.loop?
                acc.ik304(last, "R", "I7", "missing #{child.id} loop")
              else
                acc.ik304(last, "R", "3", "missing #{child.id} segment")
              end
            elsif repeat < matches.length
              matches.drop(repeat.max).each do |c|
                if child.loop?
                  acc.ik304(c, "R", "4", "loop occurs too many times")
                else
                  acc.ik304(c, "R", "5", "segment occurs too many times")
                end
              end
            end

            last = matches.last unless matches.blank?
          end

        elsif zipper.node.transaction_set?
          group = Hash.new{|h,k| h[k] = [] }

          zipper.children.each do |table|
            recurse(table, acc)
            group[table.node.definition] << table
          end

          zipper.node.definition.tap do |d|
            d.table_defs.each do |table|
              # @todo: How do we know which tables are required? It isn't
              # obvious because some tables have more than one entry segment,
              # and perhaps each has a different requirement designator.
            end
          end
        end
      end
    end

  end
end

