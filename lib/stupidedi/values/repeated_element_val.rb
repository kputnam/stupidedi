module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.2 Repeating Data Elements
    #
    class RepeatedElementVal < AbstractVal

      # @return [CompositeElementDef, SimpleElementDef]
      attr_reader :definition

      # @return [Array<ElementVal>]
      attr_reader :children
      alias element_vals children

      # @return [SegmentVal]
      attr_reader :parent

      # @return [Schema::SimpleElementUse, Schema::CompositeElementUse
      attr_reader :usage

      delegate :at, :defined_at?, :length, :to => :@children

      def initialize(definition, children, parent, usage)
        @definition, @children, @parent, @usage =
          definition, children, parent, usage

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @children = children.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [RepeatedElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent),
          changes.fetch(:usage, @usage)
      end

      def empty?
        @children.all(&:empty?)
      end

      # @return [RepeatedElementVal]
      def append(element_val)
        copy(:children => element_val.snoc(@children))
      end
      alias append_element append

      # @return [RepeatedElementVal]
      def append!(element_val)
        @children = element_val.snoc(@children)
        self
      end
      alias append_element! append!

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|e| "[#{e.id}]" }
        q.text("RepeatedElementVal#{id}")
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

      # @return [Boolean]
      def ==(other)
        other.definition   == @definition and
        other.children == @children
      end
    end

    class << RepeatedElementVal
      #########################################################################
      # @group Constructor Methods

      # @return [RepeatedElementVal]
      def empty(definition, parent, element_use)
        RepeatedElementVal.new(definition, [], parent, element_use)
      end

      # @return [RepeatedElementVal]
      def build(definition, children, parent, element_use)
        RepeatedElementVal.new(definition, children, parent, element_use)
      end

      # @endgroup
      #########################################################################
    end

  end
end
