module Stupidedi
  module Zipper
    autoload :Cursor, "stupidedi/zipper/cursor"

    autoload :AbstractPath, "stupidedi/zipper/path"
    autoload :Hole,         "stupidedi/zipper/path"
    autoload :Root,         "stupidedi/zipper/path"
  end

  class << Zipper

    # @return [Cursor]
    def build(node)
      Zipper::Cursor.new(node, nil, Zipper::Root)
    end
  end

end
