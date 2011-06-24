class String

  # Return the one-character string at the given index
  #
  # @example
  #   "abc".at(0)   #=> "a"
  #   "abc".at(2)   #=> "c"
  #
  # @param [Integer] n zero-based index of the character to read
  #
  # @return [String]
  def at(n)
    raise ArgumentError, "n must be positive" if n < 0
    self[n, 1] unless n >= length
  end

  # Return the string with `n` characters removed from the front
  #
  # @example
  #   "abc".drop(0)   #=> "abc"
  #   "abc".drop(2)   #=> "c"
  #
  # @param [Integer] n number of characters to drop (`n > 0`)
  #
  # @return [String]
  def drop(n)
    raise ArgumentError, "n must be positive" if n < 0
    (length >= n) ? self[n..-1] : ""
  end

  # Return the first `n` characters from the front
  #
  # @example
  #   "abc".take(0)   #=> ""
  #   "abc".take(2)   #=> "ab"
  #
  # @param [Integer] n number of characters to select (`n > 0`)
  #
  # @return [String]
  def take(n)
    raise ArgumentError, "n must be positive" if n < 0
    self[0, n]
  end

  # Split the string in two at the given position
  #
  # @example
  #   "abc".split_at(0)   #=> ["", "abc"]
  #   "abc".split_at(2)   #=> ["ab", "c"]
  #
  # @param [Integer] n number of characters at which to split (`n > 0`)
  #
  # @return [Array(String, String)]
  def split_at(n)
    [take(n), drop(n)]
  end

  # True if the string is long enough such that {#at} is defined for the
  # given `n`
  #
  # @example
  #   "abc".defined_at?(0)  #=> true
  #   "abc".defined_at?(3)  #=> false
  def defined_at?(n)
    n < length
  end

  # To make String compatible with the {Stupidedi::Reader::Input} interface,
  # we have to define `#position`... shameful!
  def position
    nil
  end
end
