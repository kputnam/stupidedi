module Cantor
  autoload :AbstractSet,        "cantor/abstract_set"
  autoload :AbsoluteSet,        "cantor/absolute_set"
  autoload :NullSet,            "cantor/null_set"
  autoload :RelativeComplement, "cantor/relative_complement"
  autoload :RelativeSet,        "cantor/relative_set"
  autoload :UniversalSet,       "cantor/universal_set"
end

class << Cantor
  # @group Constructors
  ###########################################################################

  # @return [Cantor::AbstractSet]
  def build(object)
    if object.is_a?(Cantor::AbstractSet)
      object
    elsif object.is_a?(Enumerable)
      Cantor::RelativeSet.build(object)
    else
      raise TypeError,
        "argument must be an AbstractSet or Enumerable"
    end
  end

  # @return [Cantor::AbstractSet]
  def complement(other)
    build(other).complement
  end

  # @return [Cantor::UniversalSet]
  def universal
    Cantor::UniversalSet.build
  end

  # @return [Cantor::NullSet]
  def empty
    Cantor::NullSet.build
  end

  # @return [Cantor::AbsoluteSet]
  def absolute(other, universe = other)
    if universe == Cantor::UniversalSet
      build(other)
    elsif universe.eql?(other)
      Cantor::AbsoluteSet.build(universe)
    else
      Cantor::AbsoluteSet.build(universe).intersection(other)
    end
  end

  # @endgroup
  ###########################################################################
end
