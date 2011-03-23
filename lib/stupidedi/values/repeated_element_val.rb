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

      # @return [Schema::SimpleElementUse, Schema::CompositeElementUse
      attr_reader :usage

      delegate :at, :defined_at?, :length, :to => :@children

      def initialize(definition, children, usage)
        @definition, @children, @usage =
          definition, children, usage
      end

      # @return [RepeatedElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:usage, @usage)
      end

      # @return false
      def leaf?
        false
      end

      def empty?
        @children.all(&:empty?)
      end

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
        eql?(other)
         (other.definition == @definition and
          other.children   == @children)
      end
    end

    class << RepeatedElementVal
      #########################################################################
      # @group Constructor Methods

      # @return [RepeatedElementVal]
      def empty(definition, element_use)
        RepeatedElementVal.new(definition, [], element_use)
      end

      # @return [RepeatedElementVal]
      def build(definition, children, element_use)
        RepeatedElementVal.new(definition, children, element_use)
      end

      # @endgroup
      #########################################################################
    end

  end
end
