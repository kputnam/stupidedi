module Stupidedi

  module Sets
    autoload :AbstractSet,        "stupidedi/sets/abstract_set"
    autoload :AbsoluteSet,        "stupidedi/sets/absolute_set"
    autoload :EmptySet,           "stupidedi/sets/empty_set"
    autoload :RelativeComplement, "stupidedi/sets/relative_complement"
    autoload :RelativeSet,        "stupidedi/sets/relative_set"
    autoload :UniversalSet,       "stupidedi/sets/universal_set"
  end

  class << Sets
    # @group Constructor Methods
    ###########################################################################

    # @return [Sets::AbstractSet]
    def build(object)
      if object.is_a?(Sets::AbstractSet)
        object
      elsif object.is_a?(Enumerable)
        Sets::RelativeSet.build(object)
      end
    end

    # @return [Sets::UniversalSet]
    def universal
      Sets::UniversalSet.build
    end

    # @return [Sets::EmptySet]
    def empty
      Sets::EmptySet.build
    end

    # @return [Sets::AbsoluteSet]
    def absolute(other)
      Sets::AbsoluteSet.build(other)
    end

    # @endgroup
    ###########################################################################
  end


end
