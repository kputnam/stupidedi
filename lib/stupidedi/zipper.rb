# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Zipper
    autoload :AbstractCursor, "stupidedi/zipper/abstract_cursor"
    autoload :DanglingCursor, "stupidedi/zipper/dangling_cursor"
    autoload :EditedCursor,   "stupidedi/zipper/edited_cursor"
    autoload :MemoizedCursor, "stupidedi/zipper/memoized_cursor"
    autoload :RootCursor,     "stupidedi/zipper/root_cursor"

    autoload :AbstractPath, "stupidedi/zipper/path"
    autoload :Hole,         "stupidedi/zipper/path"
    autoload :Root,         "stupidedi/zipper/path"
  end

  class << Zipper

    # @group Constructors
    ###########################################################################

    # @return [AbstractCursor]
    def build(node)
      Zipper::RootCursor.new(node)
    end
  end

end
