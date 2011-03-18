module Stupidedi
  module Reader

    #
    # Provides an abstract interface for a positioned cursor within an
    # element-based input stream. The main operations are implemented by the
    # {#take} and {#drop} methods.
    #
    # The {DelegatedInput} subclass wraps values that already implement the
    # interface, like {String} and {Array}. The {FileInput} subclass wraps
    # opened IO streams like File, and possibly others.
    #
    # @example Reading the input
    #   input = Input.from_string("abc")
    #   input.at(0)           #=> "a"
    #
    #   input = input.drop(1) #=> #<DelegatedInput ...>
    #   input.at(0)           #=> "b"
    #
    #   input = input.drop(1) #=> #<DelegatedInput ...>
    #   input.at(0)           #=> "c"
    #
    # @example Querying the position
    #   input = Input.from_string("abc\ndef\nghi")
    #   input.offset  #=> 0
    #   input.line    #=> 1
    #   input.column  #=> 1
    #
    #   input.drop(3).bind do |in|
    #     in.offset   #=> 3
    #     in.line     #=> 1
    #     in.column   #=> 4
    #   end
    #
    #   input.drop(4).bind do |in|
    #     in.offset   #=> 4
    #     in.line     #=> 2
    #     in.column   #=> 1
    #   end
    #
    # @note The monkey-patched classes {String} and {Array} provide compatible
    #   implementations of the abstract methods, so code written to target this
    #   interface is backward-compatable with plain unwrapped {String} and
    #   {Array} values.
    #
    class Input

      # @group Querying the Position
      ##########################################################################

      # Returns the current position as the number of elements previously read
      #
      # @return [Integer]
      abstract :offset

      # Returns the line of the current position
      #
      # @return [Integer]
      abstract :line

      # Returns the column of the current position. The column resets to +0+
      # each time a newline is read
      #
      # @return [Integer]
      abstract :column

      # @group Reading the Input
      ##########################################################################

      # Read the first +n+ elements
      #
      # @param [Integer] n number of elements to read (+n >= 0+)
      abstract :take

      # Read a single element at the given index. Result is undefined unless the
      # input contains enough elements, which can be tested with {#defined_at?}
      #
      # @param [Integer] n the index of the element to read (+n >= 0+)
      abstract :at

      # Returns the smallest +n+, where {#at}+(n)+ == +element+
      #
      # @param [Object] element the element to find in the input
      #
      # @return [Integer]
      # @return nil if +element+ is not present in the input
      abstract :index, :args => %w(value)

      # @group Advancing the Cursor
      ##########################################################################

      # Advance the cursor forward +n+ elements
      #
      # @param [Integer] n the number of elements to advance (+n >= 0+)
      #
      # @return [Input] new object with advanced cursor
      abstract :drop, :args => %w(n)

      # @group Testing the Input
      ##########################################################################

      # True if the input contains enough elements such that {#at}+(n)+ is
      # defined
      #
      # @param [Integer] n the index to test (+n >= 0+)
      abstract :defined_at?, :args => %w(n)

      # True if no elements remain in the input
      abstract :empty?
    end

    #
    # Constructors
    #
    class << Input

      # @return [Input]
      def build(o, *args)
        case o
        when IO
          FileInput.new(o, *args)
        when String, Array
          DelegatedInput.new(o, *args)
        else
          raise TypeError
        end
      end
    end

  end
end
