# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class SimpleElementUse < AbstractElementUse
      # @return [SimpleElementDef]
      attr_reader :definition

      # @return [ElementReq]
      attr_reader :requirement

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [AbstractSet]
      attr_reader :allowed_values

      # @return [SegmentDef]
      attr_reader :parent

      def initialize(definition, requirement, repeat_count, allowed_values, parent)
        @definition, @requirement, @repeat_count, @allowed_values, @parent =
          definition, requirement, repeat_count, allowed_values, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @definition = @definition.copy(:parent => self)
        end
      end

      # @return [SimpleElementUse]
      def copy(changes = {})
        SimpleElementUse.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:allowed_values, @allowed_values),
          changes.fetch(:parent, @parent)
      end

      # @return [String]
      def descriptor
        idx = parent.element_uses.index{|u| u.eql?(self) } + 1
        "element #{parent.id}#{"%02d" % idx} #{definition.name}".strip
      end

      # @return [SimpleElementVal]
      def parse(string)
        definition.parse(string, self)
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      # @return true
      def simple?
        true
      end

      # @return false
      def component?
        false
      end

      # @return [AbstractSet<CodeList>]
      def code_lists
        if forbidden?
          Sets.empty
        else
          @definition.code_lists(@allowed_values)
        end
      end

      # @return [void]
      def pretty_print(q)
        q.text("SimpleElementUse")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @definition
          q.text ","

          q.breakable
          q.pp @requirement
          q.text ","

          q.breakable
          q.pp @repeat_count
        end
      end
    end
  end
end
