# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Color
    def self.ansi
      @__ansi ||= Wrapper.new(enabled? ? ANSI : Stub)
    end

    # True if output should be colorized. Defaults to whether stdout is
    # attached to a terminal, but can be forced on (eg, `-C` command line
    # flag) or off.
    def self.enabled?
      @__enabled = $stdout.tty? if @__enabled.nil?
      @__enabled
    end

    def self.enabled=(boolean)
      @__enabled = boolean
    end

    def ansi
      Color.ansi
    end

    # @private
    #
    # No-op implementation used when colorized output is disabled.
    module Stub
      METHODS = %w(bold dark black red yellow magenta white)

      METHODS.each do |name|
        instance_eval(<<-RUBY, __FILE__, __LINE__)
          def #{name}(string)
            string
          end
        RUBY
      end
    end

    # @private
    #
    # Minimal implementation of the small subset of ANSI SGR (Select
    # Graphic Rendition) escape codes that stupidedi actually uses to
    # colorize pretty-printed output. This replaces the `term-ansicolor`
    # gem dependency, which pulled in `tins`' global core-class
    # monkeypatches (eg, redefining `Numeric#blank?` as `Numeric#zero?`)
    # as an unwanted side effect.
    module ANSI
      CODES = {
        "bold"    => 1,
        "dark"    => 2,
        "black"   => 30,
        "red"     => 31,
        "yellow"  => 33,
        "magenta" => 35,
        "white"   => 37,
      }

      CODES.each do |name, code|
        instance_eval(<<-RUBY, __FILE__, __LINE__)
          def #{name}(string)
            "\e[#{code}m\#{string}\e[0m"
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
