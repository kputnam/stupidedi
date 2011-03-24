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

      def element(*args, &block)
        black(*args, &block)
      end

      def repeated(*args, &block)
        black(*args, &block)
      end

      def composite(*args, &block)
        black(*args, &block)
      end

      def segment(*args, &block)
        magenta(*args, &block)
      end

      def loop(*args, &block)
        yellow(*args, &block)
      end

      def table(*args, &block)
        yellow(*args, &block)
      end

      def envelope(*args, &block)
        yellow(*args, &block)
      end

    private

      def method_missing(name, *args, &block)
        @base.__send__(name, *args, &block)
      end
    end

  end
end
