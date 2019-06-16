# frozen_string_literal: true
module Stupidedi
  module Refinements
    refine String do
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
        self[n] unless n >= length
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

      # Join multi-line string into a single line, removing leading whitespace
      # from the beginning of each line
      #
      # @example
      #   "this is a
      #   multiline string".join #=> "this is a multiline string"
      #
      # @return [String]
      def join
        gsub(/\n[ \t]+/, " ")
      end
    end
  end
end

class Substring
  attr_reader :whole
  attr_reader :m
  attr_reader :n

  def initialize(whole, m = 0, n = whole.length - 1)
    if n < m - 1
      n = m - 1
    end

    if m < 0
      raise ArgumentError, "start index must be non-negative"
    end

    if n >= whole.length
      raise ArgumentError, "end index must not exceed underlying String length"
    end

    @whole, @m, @n = whole, m, n

    # w = @whole[@m, [@n - @m + 1, 60].min]
    # p [w, " "*(60 - w.length), @m, @n]
  end

  # @note: Avoid calling this unless needed because it allocates another String
  def repro
    if @m <= @n
      @whole[@m..@n]
    else
      ""
    end
  end

  def to_str
    repro
  end

  def to_s
    repro
  end

  def length
    @n - @m + 1
  end

  def empty?
    @m > @n
  end

  def inspect
    repro.inspect
  end

  def ==(other)
    eql?(other) or repro == other
  end

  def =~(other)
    repro =~ other
  end

  def at(n)
    raise ArgumentError, "n must be positive" if n < 0
    @whole[@m + n] unless n > @n - @m
  end

  def defined_at?(n)
    n <= @n - @m
  end

  def take(n)
    raise ArgumentError, "n must be positive" if n < 0
    Substring.new(@whole, @m, [@m + n - 1, @whole.length - 1].min)
  end

  def drop(n)
    raise ArgumentError, "n must be positive" if n < 0
    Substring.new(@whole, [@m + n, @n + 1].min, @n)
  end

  def count(other)
    k, m = 0, @m - 1

    while true
      m  = @whole.index(other, m + 1)
      m and m <= @n or break
      k += 1
    end

    k
  end

  def index(other, m = 0)
    z = @whole.index(other, @m + m)
    z - @m if z and z <= @n
  end

  def rindex(other, n = @whole.length - 1)
    z = @whole.rindex(other, [@m + n, @n].min)
    z - @m if z and z >= @m
  end
end
