module Stupidedi
  class Either

    abstract :each, "&block"

    # @return [Either]
    abstract :select, "explanation = 'select'", "&block"

    # @return [Either]
    abstract :reject, "explanation = 'reject'", "&block"

    # @return [Boolean]
    abstract :defined?

    # @return [Either]
    abstract :map, "&block"

    # @return [Either]
    abstract :flatmap, "&block"

    # @return [Either]
    abstract :or, "&block"

    # @return [Either]
    abstract :explain, "&block"

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

      # @return true
      def defined?
        true
      end

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
        if Either === (result = yield(@value))
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

      def ==(other)
        self.class === other and other.select{|x| x == @value }.defined?
      end

      # @private
      def pretty_print(q)
        q.text("Either.success")
        q.group(2, "(", ")") do
          q.breakable
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

      # @return [Failure]
      def select(explanation = nil)
        self
      end

      # @return [Failure]
      def reject(explanation = nil)
        self
      end

      # @return false
      def defined?
        false
      end

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
        if Either === (result = yield(@explanation))
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

      def ==(other)
        self.class === other and other.explanation == @explanation
      end

      # @private
      def pretty_print(q)
        q.text("Either.failure")
        q.group(1, "(", ")") do
          q.breakable
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

  #
  # Constructors
  #
  class << Either
    # @return [Success]
    def success(value)
      Either::Success.new(value)
    end

    # @return [Failure]
    def failure(explanation)
      Either::Failure.new(explanation)
    end
  end

  Either.eigenclass.send(:protected, :new)
  Either::Success.eigenclass.send(:public, :new)
  Either::Failure.eigenclass.send(:public, :new)

end
