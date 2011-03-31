module Stupidedi
  module Color

    def self.ansi
      @__ansi ||=
        if defined?(::Term::ANSIColor)
          Wrapper.new(::Term::ANSIColor)
        else
          Wrapper.new(Stub)
        end
    end

    def ansi
      Color.ansi
    end

    # @private
    module Stub
      stubs = %w(bold clear reset dark underscore blink negative concealed
                 black red green yellow blue magenta cyan white on_black
                 on_red on_green on_yellow on_blue on_magenta on_cyan on_white)

      stubs.each do |name|
        instance_eval(<<-RUBY, __FILE__, __LINE__)
          def #{name}(string)
            string
          end
        RUBY
      end
    end

    class Wrapper
      def initialize(base)
        @base = base
      end

      def noop(string)
        string
      end

      def invalid(string)
        red(bold(string))
      end

      def element(string)
        black(string)
      end

      def required(string)
        bold(string)
      end

      def optional(string)
        dark(white(string))
      end

      def forbidden(string)
        noop(string)
      end

      def repeated(string)
        black(string)
      end

      def composite(string)
        black(string)
      end

      def segment(string)
        magenta(string)
      end

      def loop(string)
        yellow(string)
      end

      def table(string)
        yellow(string)
      end

      def envelope(string)
        yellow(string)
      end

    private

      def method_missing(name, *args)
        @base.__send__(name, *args)
      end
    end

  end
end
