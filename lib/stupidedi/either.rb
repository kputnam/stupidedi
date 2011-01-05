module Stupidedi
  class Either

    class Success < Either
      def initialize(value)
        @value = value
      end

      def each
        yield(@value)
        self
      end

      def select(explanation = "select")
        if yield(@value)
          self
        else
          Either.failure(explanation)
        end
      end

      def reject(explanation = "reject")
        if yield(@value)
          Either.failure(explanation)
        else
          self
        end
      end

      def defined?
        true
      end

      def map
        Success.new(yield(@value))
      end

      def flatmap
        if Either === (result = yield(@value))
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      def or
        self
      end

      def explain
        self
      end

      def ==(other)
        self.class === other and other.select{|x| x == @value }.defined?
      end

      def pretty_print(q)
        q.text("Either.success")
        q.group(1, "(", ")") do
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

      def each
        self
      end

      def select(explanation = nil)
        self
      end

      def reject(explanation = nil)
        self
      end

      def defined?
        false
      end

      def map
        self
      end

      def flatmap
        self
      end

      def or
        if Either === (result = yield(@explanation))
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      def explain
        Either.failure(yield(@explanation))
      end

      def ==(other)
        self.class === other and other.explanation == @explanation
      end

      def pretty_print(q)
        q.text("Either.failure")
        q.group(1, "(", ")") do
          q.breakable
          q.pp @explanation
        end
      end

      def fatal
        Fatal.new(@explanation)
      end
    end

    class Fatal < Failure
      def or
        self
      end

      def fatal
        self
      end
    end

  end

  # Constructors
  class << Either
    private :new

    def success(value)
      Either::Success.new(value)
    end

    def failure(explanation)
      Either::Failure.new(explanation)
    end
  end

  class << Either::Success
    public :new
  end

  class << Either::Failure
    public :new
  end

end
