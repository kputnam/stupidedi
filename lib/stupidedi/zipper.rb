# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Zipper
    autoload :AbstractCursor, "stupidedi/zipper/abstract_cursor"
    autoload :DanglingCursor, "stupidedi/zipper/dangling_cursor"
    autoload :EditedCursor,   "stupidedi/zipper/edited_cursor"
    autoload :MemoizedCursor, "stupidedi/zipper/memoized_cursor"
    autoload :RootCursor,     "stupidedi/zipper/root_cursor"
    autoload :StackCursor,    "stupidedi/zipper/stack_cursor"

    autoload :AbstractPath, "stupidedi/zipper/path"
    autoload :Hole,         "stupidedi/zipper/path"
    autoload :Root,         "stupidedi/zipper/path"

    # @todo
    module Tree
      class << self
        def build(node)
          Zipper::RootCursor.new(node)
        end
      end
    end

    # @todo
    module Stack
      class << self
        def build(node)
          Zipper::StackCursor.new(node, Zipper::Root, nil)
        end
      end
    end
  end

  class << Zipper

    # @group Constructors
    ###########################################################################

    # @return [AbstractCursor]
    def build(node)
      Zipper::Tree.build(node)
    end
  end

end
