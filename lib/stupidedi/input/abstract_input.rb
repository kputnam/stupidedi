module Stupidedi
  module Input

    #
    # Updates cursor position and allows access to an indexed input
    # with the following abstract methods.
    #
    #   at(n)     read a single element at the given index
    #   take(n)   read n elements from the input
    #   drop(n)   advance the cursor n elements
    #   index(e)  return the smallest index where element e occurs
    #
    # The monkey-patched classes String and Array provide compatible
    # implementations of the above methods, so for the most part, the
    # users of this class will also be compatible with non-cursor input
    #
    # Cursor position can be queried using the following abstract methods
    #   offset
    #   line
    #   column
    #
    class AbstractInput
      autoload :DelegatedInput, "stupidedi/input/delegated_input"
      autoload :FileInput,      "stupidedi/input/file_input"

      def offset
        raise NoMethodError, "Method offset must be implemented in subclass"
      end

      def line
        raise NoMethodError, "Method line must be implemented in subclass"
      end

      def column
        raise NoMethodError, "Method column must be implemented in subclass"
      end

      ###################################################################

      #
      def defined_at?(n)
        raise NoMethodError, "Method defined_at?(n) must be implemented in subclass"
      end

      # Returns true if no elements remain
      def empty?
        raise NoMethodError, "Method empty? must be implemented in subclass"
      end

      # Returns an instance of Input with the first +n+
      # elements have been removed
      def drop(n)
        raise NoMethodError, "Method drop(n) must be implemented in subclass"
      end

      # Returns the first +n+ elements
      def take(n)
        raise NoMethodError, "Method take(n) must be implemented in subclass"
      end

      # Returns an element at index +n+
      def at(n)
        raise NoMethodError, "Method at(n) must be implemented in subclass"
      end

      # Returns the smallest n, where self.at(n) == +value+
      # or nil if no such value exists
      def index(value)
        raise NoMethodError, "Method index(value) must be implemented in subclass"
      end
    end

  end
end
