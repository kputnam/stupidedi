# Mixin applied to Array
module List

  ##
  # Return the first item
  def head
    raise IndexError, "head of empty list" if empty?
    x, _ = self
    x
  end

  ##
  # Selects all elements except the first
  def tail
    _, *xs = self
    xs
  end

  ##
  # Selects all elements except the last
  def init
    slice(0..-2) or []
  end

  ##
  # Select all elements except the first +n+ ones
  def drop(n)
    raise ArgumentError, "n (#{n}) must be positive" if n < 0
    slice(n..-1) or []
  end

  ##
  # Drops the longest prefix of elements that satisfy the predicate
  #   OPTIMIZE: Recursive definition is slower than iterative
  def drop_while(&block)
    if not empty? and yield(head)
      tail.drop_while(&block)
    else
      self
    end
  end

  ##
  # Drops the longest prefix of elements that do not satisfy the predicate
  #   OPTIMIZE: Recursive definition is slower than iterative
  def drop_until(&block)
    unless empty? or yield(head)
      tail.drop_until(&block)
    else
      self
    end
  end

  ##
  # Select all elements except the last +n+ ones
  def take(n)
    raise ArgumentError, "n (#{n}) must be positive" if n < 0
    slice(0, n) or []
  end

  ##
  # Takes the longest prefix of elements that satisfy the predicate
  #   OPTIMIZE: Recursive definition is slower than iterative
  def take_while(&block)
    if not empty? and yield(head)
      head.cons(tail.take_while(&block))
    else
      []
    end
  end

  ##
  # Takes the longest prefix of elements that do not satisfy the predicate
  #   OPTIMIZE: Recursive definition is slower than iterative
  def take_until(&block)
    unless empty? or yield(head)
      head.cons(tail.take_until(&block))
    else
      []
    end
  end

  ##
  # Splits the array into prefix/suffix pair according to the predicate
  #   OPTIMIZE: We don't need to iterate the prefix twice
  def span(&block)
    [take_while(&block), drop_while(&block)]
  end

  ##
  # Splits the array into prefix/suffix pair according to the predicate
  #   OPTIMIZE: We don't need to iterate the prefix twice
  def split_when(&block)
    [take_until(&block), drop_until(&block)]
  end

  ##
  # Split the array in two at the given position
  def split_at(n)
    [take(n), drop(n)]
  end
end

Array.send(:include, List)
