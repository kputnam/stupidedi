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
          def #{name}(string = "")
            if block_given?
              yield
            else
              string
            end
          end
        RUBY
      end
    end

    class Wrapper
      def initialize(base)
        @base = base
      end

      def noop(string = "", &block)
        if block_given?
          yield
        else
          string
        end
      end

      def element(string = "", &block)
        black(string, &block)
      end

      def required(string = "", &block)
        bold(string, &block)
      end

      def optional(string = "", &block)
        dark(white(string, &block))
      end

      def forbidden(string = "", &block)
        noop(string, &block)
      end

      def repeated(string = "", &block)
        black(string, &block)
      end

      def composite(string = "", &block)
        black(string, &block)
      end

      def segment(string = "", &block)
        magenta(string, &block)
      end

      def loop(string = "", &block)
        yellow(string, &block)
      end

      def table(string = "", &block)
        yellow(string, &block)
      end

      def envelope(string = "", &block)
        yellow(string, &block)
      end

    private

      def method_missing(name, *args, &block)
        @base.__send__(name, *args, &block)
      end
    end

  end
end
