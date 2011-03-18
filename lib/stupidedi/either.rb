module Stupidedi

  #
  #
  #
  class Either

    # @return [void]
    abstract :each, :args => %w(&block)

    # @return [Boolean]
    abstract :defined?

    ###########################################################################
    # @group Filter Methods

    # @return [Either]
    abstract :select, :args => %w(explanation='select' &block)

    # @return [Either]
    abstract :reject, :args => %w(explanation='reject' &block)

    # @endgroup
    ###########################################################################

    ###########################################################################
    # @group Combinator Methods

    # @return [Either]
    abstract :map, :args => %w(&block)

    # @return [Either]
    abstract :flatmap, :args => %w(&block)

    # @return [Either]
    abstract :or, :args => %w(&block)

    # @return [Either]
    abstract :explain, :args => %w(&block)

    # @endgroup
    ###########################################################################

    #
    class Success < Either
      def initialize(value)
        @value = value
      end

      # @return [Success]
      # @yieldparam value
      def each
        yield(@value)
        self
      end

      # @return true
      def defined?
        true
      end

      #########################################################################
      # @group Filter Methods

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Boolean]
      def select(explanation = "select")
        if yield(@value)
          self
        else
          Either.failure(explanation)
        end
      end

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Boolean]
      def reject(explanation = "reject")
        if yield(@value)
          Either.failure(explanation)
        else
          self
        end
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Combinator Methods

      # @return [Success]
      # @yieldparam value
      # @yieldreturn value
      def map
        Success.new(yield(@value))
      end

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Either]
      def flatmap
        result = yield(@value)

        if result.is_a?(Either)
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      # @return [Success]
      def or
        self
      end

      # @return [Success]
      def explain
        self
      end

      # @endgroup
      #########################################################################

      # @return [Boolean]
      def ==(other)
        other.is_a?(Success) and other.select{|x| x == @value }.defined?
      end

      # @return [void]
      def pretty_print(q)
        q.text("Either.success")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class Failure < Either
      attr_accessor :explanation

      def initialize(explanation)
        @explanation = explanation
      end

      # @return [Failure]
      def each
        self
      end

      # @return false
      def defined?
        false
      end

      #########################################################################
      # @group Filter Methods

      # @return [Failure]
      def select(explanation = nil)
        self
      end

      # @return [Failure]
      def reject(explanation = nil)
        self
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Combinator Methods

      # @return [Failure]
      def map
        self
      end

      # @return [Failure]
      def flatmap
        self
      end

      # @return [Either]
      # @yieldparam explanation
      # @yieldreturn [Either]
      def or
        result = yield(@explanation)

        if result.is_a?(Either)
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      # @return [Failure]
      # @yieldparam explanation
      # @yieldreturn explanation
      def explain
        Either.failure(yield(@explanation))
      end

      # @endgroup
      #########################################################################

      # @return [Boolean]
      def ==(other)
        other.is_a?(self.class) and other.explanation == @explanation
      end

      # @return [void]
      def pretty_print(q)
        q.text("Either.failure")
        q.group(1, "(", ")") do
          q.breakable ""
          q.pp @explanation
        end
      end

      # @return [Fatal]
      def fatal
        Fatal.new(@explanation)
      end
    end

    class Fatal < Failure
      # @return [Fatal]
      def or
        self
      end

      # @return [Fatal]
      def fatal
        self
      end
    end

  end

  class << Either

    ###########################################################################
    # @group Constructor Methods

    # @return [Success]
    def success(value)
      Either::Success.new(value)
    end

    # @return [Failure]
    def failure(explanation)
      Either::Failure.new(explanation)
    end

    # @endgroup
    ###########################################################################

  end

  Either.eigenclass.send(:protected, :new)
  Either::Success.eigenclass.send(:public, :new)
  Either::Failure.eigenclass.send(:public, :new)

end
