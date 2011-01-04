class String
  ##
  # Return the one-character string at the given index
  def at(n)
    self[n, 1] unless n >= length
  end

  ##
  # Return the string with +n+ characters removed from the front
  def drop(n)
    (length >= n) ? self[n..-1] : ""
  end

  ##
  # Return the first +n+ characters from the front
  def take(n)
    self[0, n]
  end

  ##
  # Split the string in two at the given position
  def split_at(n)
    [take(n), drop(n)]
  end

  ##
  #
  def defined_at?(n)
    n < length
  end
end
