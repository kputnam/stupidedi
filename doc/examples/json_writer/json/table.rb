module Stupidedi
  using Refinements

  module Writer
    class Json
      class Table
        attr_reader :node

        def_delegators :node, :repeated?, :definition, :children
        def_delegators :node, :definition
        def_delegators :definition, :id

        def initialize(node)
          @node = node
        end

        def reduce(memo, &block)
          memo[key] = children.map do |c|
            block.call(c)
          end
        end

        def key
          id
        end
      end
    end
  end
end
