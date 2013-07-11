require "cantor"

module Stupidedi

  module Sets
  end

  class << Sets
    # @group Constructors
    ###########################################################################

    # @return [Cantor::AbstractSet]
    def build(object)
      Cantor.build(object)
    end

    # @return [Cantor::AbstractSet]
    def complement(other)
      Cantor.complement(other)
    end

    # @return [Cantor::UniversalSet]
    def universal
      Cantor.universal
    end

    # @return [Cantor::NullSet]
    def empty
      Cantor.empty
    end

    # @return [Cantor::AbsoluteSet]
    def absolute(other, universe = other)
      Cantor.absolute(other, universe)
    end

    # @endgroup
    ###########################################################################
  end


end
