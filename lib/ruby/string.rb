class String
  def blank?
    self =~ /\S/
  end

  # Return the one-character string at the given index
  #
  # @param [Integer] n zero-based index of the character to read
  #
  # @return [String]
  def at(n)
    self[n, 1] unless n >= length
  end

  # Return the string with +n+ characters removed from the front
  #
  # @param [Integer] n number of characters to drop (+n > 0+)
  #
  # @return [String]
  def drop(n)
    (length >= n) ? self[n..-1] : ""
  end

  # Return the first +n+ characters from the front
  #
  # @param [Integer] n number of characters to select (+n > 0+)
  #
  # @return [String]
  def take(n)
    self[0, n]
  end

  # Split the string in two at the given position
  #
  # @return [Array(String, String)]
  def split_at(n)
    [take(n), drop(n)]
  end

  # True if the string is long enough such that {#at}+(n)+ is defined
  def defined_at?(n)
    n < length
  end
end
