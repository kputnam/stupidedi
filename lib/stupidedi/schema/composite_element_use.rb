# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class CompositeElementUse < AbstractElementUse
      # @return [CompositeElementDef]
      attr_reader :definition

      def_delegators :definition, :id, :name, :description

      # @return [ElementReq]
      attr_reader :requirement

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @return [SegmentDef]
      attr_reader :parent

      def initialize(definition, requirement, repeat_count, parent)
        @definition, @requirement, @repeat_count, @parent =
          definition, requirement, repeat_count, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @definition = @definition.copy(:parent => self)
        end
      end

      # @return [CompositeElementUse]
      def copy(changes = {})
        CompositeElementUse.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:parent, @parent)
      end

      def descriptor
        n = parent.element_uses.index{|u| u.eql?(self) } + 1
        "element #{parent.id}#{"%02d" % n} #{definition.name}".strip
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      # @return false
      def simple?
        false
      end

      # @return false
      def component?
        false
      end

      # @return [void]
      def pretty_print(q)
        q.text("CompositeElementUse")
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
