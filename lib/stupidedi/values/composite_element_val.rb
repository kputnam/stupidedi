module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.3 Composite Data Structure
    #
    class CompositeElementVal < AbstractVal

      # @return [CompositeElementDef]
      delegate :definition, :to => :@usage

      # @return [Array<SimpleElementVal>]
      attr_reader :children
      alias component_vals children

      # @return [CompositeElementUse]
      attr_reader :usage

      def initialize(children, usage)
        @children, @usage =
          children, usage
      end

      # @return [CompositeElementVal]
      def copy(changes = {})
        CompositeElementVal.new \
          changes.fetch(:children, @children),
          changes.fetch(:usage, @usage)
      end

      # @return false
      def leaf?
        false
      end

      def empty?
        @children.all?(&:empty?)
      end

      # @return [SimpleElementVal]
      def at(n)
        if definition.component_element_uses.defined_at?(n)
          if @children.defined_at?(n)
            @children.at(n)
          else
            definition.component_element_uses.at(n).empty
          end
        else
          raise IndexError
        end
      end

      # @return [void]
      def pretty_print(q)
        id = definition.bind do |d|
          "[#{d.id}: #{d.name}]".bind do |s|
            if usage.forbidden?
              ansi.forbidden(s)
            elsif usage.required?
              ansi.required(s)
            else
              ansi.optional(s)
            end
          end
        end

        q.text(ansi.composite("CompositeElementVal#{id}"))

        if empty?
          q.text(ansi.composite(".empty"))
        else
          q.group(2, "(", ")") do
            q.breakable ""
            @children.each do |e|
              unless q.current_group.first?
                q.text ", "
                q.breakable
              end
              q.pp e
            end
          end
        end
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == definition and
          other.children   == @children)
      end
    end

  end
end
