module TimeStringMatchers
  def roundtrip(value)
    Roundtrip.new(value)
  end

  class Roundtrip
    def initialize(value)
      @value   = value
      @error   = nil
      @string  = nil
      @value_  = nil
      @string_ = nil
    end

    def matches?(format)
      @format  = format
      begin
        @string  = Stupidedi::Versions::Common::ElementTypes::AN.strftime(format, @value)
        @value_  = Stupidedi::Versions::Common::ElementTypes::AN.strptime(format, @string)

        if @value_.nil?
          @string_ = nil
        else
          @string_ = Stupidedi::Versions::Common::ElementTypes::AN.strftime(format, @value_)
        end

        @string == @string_
      rescue => error
        @error = error
        false
      end
    end

    def description
      "roundtrip(#{@string.inspect})"
    end

    def failure_message
      if @error
        if @string.nil?
          "expected strftime(#@format, strptime(#@format, strftime(#@format, time))) to equal strftime(#@format, time)\n" \
          "  but strftime(#{@format.inspect}, #{@value.inspect}) raised an exception:\n" \
          "    #{@error.class.name}: #{@error.message}\n"                                \
          "    #{@error.backtrace.select{|x| x !~ /rspec-core/ }.join("\n    ")}"
        elsif @value_.nil?
          "expected strftime(#@format, strptime(#@format, strftime(#@format, time))) to equal strftime(#@format, time)\n" \
          "  but strftime(#{@format.inspect}, #{@value.inspect}) == #{@string.inspect}\n" \
          "  and strptime(#{@format.inspect}, #{@string.inspect}) raised an exception:\n" \
          "    #{@error.class.name}: #{@error.message}\n"                                 \
          "    #{@error.backtrace.select{|x| x !~ /rspec-core/ }.join("\n    ")}"
        else
          "expected strftime(#@format, strptime(#@format, strftime(#@format, time))) to equal strftime(#@format, time)\n" \
          "  but strftime(#{@format.inspect}, #{@value.inspect}) == #{@string.inspect}\n"  \
          "  and strptime(#{@format.inspect}, #{@string.inspect}) == #{@value_.inspect}\n" \
          "  and strftime(#{@format.inspect}, #{@value_.inspect}) raised an exception\n"   \
          "    #{@error.class.name}: #{@error.message}\n"                                  \
          "    #{@error.backtrace.select{|x| x !~ /rspec-core/ }.join("\n    ")}"
        end
      elsif @value_.nil?
        "expected strftime(#@format, strptime(#@format, strftime(#@format, time))) to equal strftime(#@format, time)\n" \
          "  but strftime(#{@format.inspect}, #{@value.inspect}) == #{@string.inspect}\n" \
          "  and strptime(#{@format.inspect}, #{@string.inspect}) == #{@value_.inspect}"
      elsif @string != @string_
        "expected strftime(#@format, strptime(#@format, strftime(#@format, time))) to equal strftime(#@format, time)\n" \
        "  but strftime(#{@format.inspect}, #{@value.inspect}) == #{@string.inspect}\n"  \
        "  and strptime(#{@format.inspect}, #{@string.inspect}) == #{@value_.inspect}\n" \
        "  and strftime(#{@format.inspect}, #{@value_.inspect}) == #{@string_.inspect} (expected #{@value.inspect})"
      end
    end
  end
end
