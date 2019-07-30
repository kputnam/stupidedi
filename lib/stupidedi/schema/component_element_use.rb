# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    class ComponentElementUse < AbstractElementUse
      # @return [SimpleElementDef]
      attr_reader :definition

      def_delegators :definition, :id, :name, :description

      # @return [ElementReq]
      attr_reader :requirement

      # @return [CompositeElementDef]
      attr_reader :parent

      # @return [AbstractSet]
      attr_reader :allowed_values

      def initialize(definition, requirement, allowed_values, parent)
        @definition, @requirement, @allowed_values, @parent =
          definition, requirement, allowed_values, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @definition = @definition.copy(:parent => self)
        end
      end

      # @return [ComponentElementUse]
      def copy(changes =  {})
        ComponentElementUse.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:allowed_values, @allowed_values),
          changes.fetch(:parent, @parent)
      end

      # @return [String]
      def descriptor
        n = parent.parent.parent.element_uses.index{|u| u.eql?(parent.parent) } + 1
        m = parent.component_uses.index{|u| u.eql?(self) } + 1
        "element #{parent.parent.parent.id}#{"%02d-%02d" % [n, m]} #{definition.name}".strip
      end

      # @return false
      def repeatable?
        false
      end

      # @return true
      def simple?
        true
      end

      # @return true
      def component?
        true
      end

      # @return [void]
      # :nocov:
      def pretty_print(q)
        q.text("ComponentElementUse")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @definition
          q.text ","
          q.breakable
          q.pp @requirement
        end
      end
      # :nocov:
    end
  end
end
