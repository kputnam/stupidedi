module Stupidedi
  module Schema

    class AbstractElementUse
      include Inspect

      # @return [SimpleElementDef, CompositeElementDef]
      abstract :definition

      abstract :simple?

      # @return [SimpleElementVal, CompositeElementVal]
      def empty(parent = nil)
        definition.empty(parent, self)
      end

      # @return [SimpleElementVal, CompositeElementVal]
      def value(value, parent = nil)
        definition.value(value, parent, self)
      end

      def composite?
        not simple?
      end
    end

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
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:allowed_values, @allowed_values),
          changes.fetch(:parent, @parent)
      end

      # @return [SimpleElementVal]
      def parse(string, parent = nil)
        definition.parse(string, parent, self)
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      def simple?
        true
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

    class ComponentElementUse < AbstractElementUse
      # @return [SimpleElementDef]
      attr_reader :definition

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

      # @return [SimpleElementVal]
      def parse(string, parent = nil)
        definition.parse(string, parent, self)
      end

      def repeatable?
        false
      end

      # @return [ComponentElementUse]
      def copy(changes =  {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:allowed_values, @allowed_values),
          changes.fetch(:parent, @parent)
      end

      def simple?
        true
      end

      # @return [void]
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
    end

    class CompositeElementUse < AbstractElementUse
      # @return [CompositeElementDef]
      attr_reader :definition

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
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:parent, @parent)
      end

      def repeatable?
        @repeat_count.try{|r| r.include?(2) }
      end

      def simple?
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
