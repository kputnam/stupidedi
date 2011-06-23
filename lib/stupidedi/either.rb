module Stupidedi
  class Either

    # @return self
    abstract :each, :args => %w(&block)

    # (see #each)
    def tap
      each{|x| yield x }
    end

    # @return [Boolean]
    abstract :defined?

    ###########################################################################
    # @group Filtering the Value

    # @return [Either]
    abstract :select, :args => %w(reason='select' &block)

    # @return [Either]
    abstract :reject, :args => %w(reason='reject' &block)

    # @endgroup
    ###########################################################################

    ###########################################################################
    # @group Transforming the Value

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
      # @group Filtering the Value

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Boolean]
      def select(reason = "select")
        if yield(@value)
          self
        else
          Either.failure(reason)
        end
      end

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Boolean]
      def reject(reason = "reject")
        if yield(@value)
          Either.failure(reason)
        else
          self
        end
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Transforming the Value

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

      # @return [String]
      def inspect
        "Either.success(#{@value.inspect})"
      end
    end

    class Failure < Either

      attr_reader :reason

      def initialize(reason)
        @reason = reason
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
      # @group Filtering the Value

      # @return [Failure]
      def select(reason = nil)
        self
      end

      # @return [Failure]
      def reject(reason = nil)
        self
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Transforming the Value

      # @return [Failure]
      def map
        self
      end

      # @return [Failure]
      def flatmap
        self
      end

      # @return [Either]
      # @yieldparam reason
      # @yieldreturn [Either]
      def or
        result = yield(@reason)

        if result.is_a?(Either)
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      # @return [Failure]
      # @yieldparam reason
      # @yieldreturn reason
      def explain
        Either.failure(yield(@reason))
      end

      # @endgroup
      #########################################################################

      # @return [Boolean]
      def ==(other)
        other.is_a?(self.class) and other.reason == @reason
      end

      # @return [void]
      def pretty_print(q)
        q.text("Either.failure")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @reason
        end
      end

      # @return [Fatal]
      def fatal
        Fatal.new(@reason)
      end

      # @return [String]
      def inspect
        "Either.failure(#{@reason.inspect})"
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

      # @return [String]
      def inspect
        "Either.fatal(#{@reason.inspect})"
      end
    end

  end

  class << Either
    ###########################################################################
    # @group Constructors

    # @return [Success]
    def success(value)
      Either::Success.new(value)
    end

    # @return [Failure]
    def failure(reason)
      Either::Failure.new(reason)
    end

    # @endgroup
    ###########################################################################
  end

  Either.eigenclass.send(:protected, :new)
  Either::Success.eigenclass.send(:public, :new)
  Either::Failure.eigenclass.send(:public, :new)

end
