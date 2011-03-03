module Stupidedi
  module Schema

    class ElementUse
    end

    class SimpleElementUse < ElementUse
      # @return [SimpleElementDef]
      attr_reader :definition

      # @return [ElementReq]
      attr_reader :requirement

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @todo
      # @return [SegmentDef]
      attr_reader :parent

      def initialize(definition, requirement, repeat_count, parent)
        @definition, @requirement, @repeat_count, @parent =
          definition, requirement, repeat_count, parent

        @definition = @definition.copy(:parent => self)
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:parent, @parent)
      end

      # @private
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

    # # @private
    # def inspect
    #   "SimpleElementUse(#{@definition.inspect}, #{@requirement.inspect},#{@repeat_count.inspect})"
    # end
    end

    class CompositeElementUse < ElementUse
      # @return [CompositeElementDef]
      attr_reader :definition

      # @return [ElementReq]
      attr_reader :requirement

      # @return [RepeatCount]
      attr_reader :repeat_count

      # @todo
      # @return [SegmentDef]
      attr_reader :parent

      def initialize(definition, requirement, repeat_count, parent)
        @definition, @requirement, @repeat_count, @parent =
          definition, requirement, repeat_count, parent

        @definition = @definition.copy(:parent => self)
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:repeat_count, @repeat_count),
          changes.fetch(:parent, @parent)
      end

      # @private
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

    class ComponentElementUse < ElementUse
      # @return [SimpleElementDef]
      attr_reader :definition

      # @return [ElementReq]
      attr_reader :requirement

      # @todo
      # @return [CompositeElementDef]
      attr_reader :parent

      def initialize(definition, requirement, parent)
        @definition, @requirement, @parent =
          definition, requirement, parent

        @definition = @definition.copy(:parent => self)
      end

      def copy(changes =  {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:requirement, @requirement),
          changes.fetch(:parent, @parent)
      end

      # @private
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

  end
end
