module ReaderExtMatchers
  def be_graphic(encoding: nil)
    BeGraphic.new(encoding)
  end

  def be_whitespace
    BeWhitespace.new
  end

  class BeGraphic
    def initialize(encoding)
      @encoding = encoding
    end

    def matches?(actual)
      @failures = encode(actual).chars.reject{|c| Stupidedi::Reader::NativeExt.graphic?(c) }
      @failures.empty?
    end

    def failure_message
      failures = @failures.map{|c| "0x%02x%s" % [c.ord, inspect_char(c)] }.join(", ")
      encoding = @actual.encoding.name
      "expected #{failures} to be recognized as #{encoding} graphic characters"
    end

    def does_not_match?(actual)
      @failures = encode(actual).chars.select{|c| Stupidedi::Reader::NativeExt.graphic?(c) }
      @failures.empty?
    end

    def failure_message_when_negated
      failures = @failures.map{|c| "0x%02x%s" % [c.ord, inspect_char(c)] }.join(", ")
      encoding = @actual.encoding.name
      "did not expect #{failures} to be recognized as #{encoding} graphic characters"
    end

    def description
      if @encoding
        "be recognized as #{@encoding} graphic characters"
      else
        "be recognized as graphic characters"
      end
    end

    private

    def encode(actual)
      if @encoding.nil?
        @actual = actual
      else
        blank   = "".encode(@encoding)
        @actual = actual.encode(@encoding, invalid: :replace, undef: :replace, replace: blank)
      end
    end

    def inspect_char(c)
      c = c.encode(Encoding.default_external_encoding)
      x = c.inspect

      if x.match?(/^"\\(?:u|x)/)
        ""
      elsif x != '"\\""' and x != '"\\\\"' and x.index("\\") == 1
        " (#{x[1..-2]})"
      else
        " (#{c})"
      end
    rescue
      ""
    end
  end

  class BeWhitespace
    def initialize(argument)
      @argument = argument
    end

    def matches?(target)
    end

    def does_not_match?(target)
      ""
    end

    def failure_message
      ""
    end

    def failure_message_when_negated
      ""
    end

    def description
      ""
    end
  end
end
