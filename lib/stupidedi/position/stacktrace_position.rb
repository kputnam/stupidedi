# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Position
    #
    # Tracks filename, method name, and line number of a frame in the stack.
    # Usually the stack frame just above the stupidedi boundary is chosen, so
    # users will have the location in their source where a value was generated.
    #
    # TODO: Build a way to store more than a single stack frame's worth of data
    # along with a way to configure how many stack frames should be saved.
    #
    class StacktracePosition

      # @return [Thread::Backtrace::Location]
      attr_reader :frame

      def_delegators :@frame, :absolute_path, :base_label, :inspect, :to_s,
        :label, :lineno, :path

      def initialize(frame)
        @frame = frame
      end

      def name
        @frame.path
      end

      def line
        @frame.lineno
      end

      def advance(input)
        raise NoMethodError, "StacktracePosition does not implement #advance"
      end
    end

    class << StacktracePosition
      def caller(offset = 1)
        new(Kernel.caller_locations(offset + 1, 1).first)
      end

      def build(*args)
        caller(2)
      end
    end
  end
end
