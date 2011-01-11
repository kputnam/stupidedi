class Array

  # Return the first item
  def head
    raise IndexError, "head of empty list" if empty?
    x, _ = self
    x
  end

  # Selects all elements except the first
  def tail
    _, *xs = self
    xs
  end

  # Selects all elements except the last
  def init
    slice(0..-2) or []
  end

  # Select all elements except the first +n+ ones
  def drop(n)
    raise ArgumentError, "n (#{n}) must be positive" if n < 0
    slice(n..-1) or []
  end

  # Drops the longest prefix of elements that satisfy the predicate
  def drop_while(&block)
    # This is in tail call form
    if not empty? and yield(head)
      tail.drop_while(&block)
    else
      self
    end
  end

  # Drops the longest prefix of elements that do not satisfy the predicate
  def drop_until(&block)
    # This is in tail call form
    unless empty? or yield(head)
      tail.drop_until(&block)
    else
      self
    end
  end

  # Select all elements except the last +n+ ones
  def take(n)
    raise ArgumentError, "n (#{n}) must be positive" if n < 0
    slice(0, n) or []
  end

  # Takes the longest prefix of elements that satisfy the predicate
  def take_while(accumulator = [], &block)
    # This is in tail call form
    if not empty? and yield(head)
      tail.take_while(head.snoc(accumulator), &block)
    else
      accumulator
    end
  end

  # Takes the longest prefix of elements that do not satisfy the predicate
  def take_until(accumulator = [], &block)
    # This is in tail call form
    unless empty? or yield(head)
      tail.take_until(head.snoc(accumulator), &block)
    else
      accumulator
    end
  end

  # Splits the array into prefix/suffix pair according to the predicate
  def span(&block)
    prefix = take_while(&block)
    suffix = drop(prefix.length)
    return prefix, suffix
  end

  # Splits the array into prefix/suffix pair according to the predicate
  def split_when(&block)
    prefix = take_until(&block)
    suffix = drop(prefix.length)
    return prefix, suffix
  end

  # Split the array in two at the given position
  def split_at(n)
    return take(n), drop(n)
  end
end
