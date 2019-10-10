module EitherMatchers
  def be_success(value = nil, &block)
    BeSuccess.new(value || block)
  end

  def be_failure(value = nil, &block)
    BeFailure.new(value || block)
  end

  class BeSuccess
    def initialize(expected)
      @expected = expected
    end

    def matches?(either)
      @either = either

      case @expected
      when nil
        true
      when Proc
        either.select(&@expected).defined?
      when Regexp
        either.select{|x| x =~ @expected}.defined?
      else
        either.select{|x| x == @expected}.defined?
      end
    end

    def does_not_match?(either)
      fail "Use `expect(foo).to be_failure(bar)`, because `expect(foo).to_not be_success(bar)` can cause false matches"
    end

    def failure_message
      "expected Either.success#{expected_label}, got #{@either.inspect}"
    end

    def description
      "be success#{expected_label}"
    end

  private

    def expected_label
      case @expected
      when nil
        ""
      when Proc
        "(lambda{|value| ... })"
      else
        "(#{@expected.inspect})"
      end
    end
  end

  class BeFailure
    def initialize(expected)
      @expected = expected
    end

    def matches?(either)
      @either = either

      if either.defined?
        false
      else
        case @expected
        when nil
          true
        when Proc
          @expected.call(either.reason)
        when Regexp
          either.reason =~ @expected
        else
          either.reason == @expected
        end
      end
    end

    def does_not_match?(either)
      fail "Use `expect(foo).to be_success(bar)`, because `expect(foo).to_not be_failure(bar)` can cause false matches"
    end

    def failure_message
      "expected Either.failure#{expected_label}, got #{@either.inspect}"
    end

    def description
      "be failure#{expected_label}"
    end

  private

    def expected_label
      case @expected
      when nil
        ""
      when Proc
        "(lambda{|value| ... })"
      else
        "(#{@expected.inspect})"
      end
    end
  end
end
