class Object
  # Prepend the item to the front of a new list
  # @return [Array]
  def cons(array = [])
    [self] + array
  end

  # Append the item to rear of a new list
  # @return [Array]
  def snoc(array = [])
    array + [self]
  end

  # Yields self to a block argument
  def bind
    yield self
  end

  # Yields self to a side-effect block argument and return self
  def tap
    yield self
    self
  end

  # Return the "eigenclass" where singleton methods reside
  def eigenclass
    class << self; self; end
  end
end
