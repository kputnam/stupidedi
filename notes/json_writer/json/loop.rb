module Stupidedi
  using Refinements

  module Writer
    class Json
      class Loop
        attr_reader :node

        def_delegators :node, :definition, :children
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
