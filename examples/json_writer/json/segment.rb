module Stupidedi
  using Refinements

  module Writer
    class Json
      class Segment
        attr_reader :node

        def_delegators :node, :repeated?, :children, :id

        def initialize(node)
          @node = node
        end

        def reduce(memo, &block)
          return memo if node.empty?

          memo[key] = if single_child?
             block.call(child)
          else
            children.map do |c|
              block.call(c)
            end
          end
        end

        def key
          id
        end

        def single_child?
          children.size == 1
        end

        def child
          @child ||= children.first
        end
      end
    end
  end
end
