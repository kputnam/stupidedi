module Stupidedi
  module Reader

    module Result

      # @return [Position]
      def position
        if @remainder.respond_to?(:position)
          @remainder.position
        end
      end

      # @return [Integer]
      def offset
        if @remainder.respond_to?(:offset)
          @remainder.offset
        end
      end

      # @return [Integer]
      def line
        if @remainder.respond_to?(:line)
          @remainder.line
        end
      end

      # @return [Integer]
      def column
        if @remainder.respond_to?(:column)
          @remainder.column
        end
      end
    end

    class << Result
      # @group Constructors
      #########################################################################

      # @return [Result::Success]
      def success(value, remainder)
        Success.new(value, remainder)
      end

      # @return [Result::Failure]
      def failure(reason, remainder, fatal)
        Failure.new(reason, remainder, fatal)
      end

      # @endgroup
      #########################################################################
    end

    class Success < Either::Success
      include Result

      attr_reader :remainder

      def initialize(value, remainder)
        @value, @remainder = value, remainder
      end

      # @return [Success]
      def copy(changes = {})
        Success.new \
          changes.fetch(:value, @value),
          changes.fetch(:remainder, @remainder)
      end

      def fatal?
        false
      end

      # @return [Boolean]
      def ==(other)
        if other.is_a?(self.class)
          @value == other.value and @remainder == other.remainder
        else
          @value == other
        end
      end

      # @return [void]
      def pretty_print(q)
        q.text "Result.success"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
          q.text ","
          q.breakable
          q.pp @remainder
        end
      end

      # Override {Enumerable#blank?} since we're not really {Enumerable}
      def blank?
        false
      end

    private

      def deconstruct(block)
        block.call(@value, @remainder)
      end

      def failure(reason)
        Failure.new(reason, @remainder, false)
      end
    end

    class Failure < Either::Failure
      include Result

      attr_reader :remainder

      def initialize(reason, remainder, fatal)
        @reason, @remainder, @fatal =
          reason, remainder, fatal
      end

      # @return [Failure]
      def copy(changes = {})
        Failure.new \
          changes.fetch(:reason, @reason),
          changes.fetch(:remainder, @remainder),
          changes.fetch(:fatal, @fatal)
      end

      def fatal?
        @fatal
      end

      def fatal
        copy(:fatal => true)
      end

      # @return [Boolean]
      def ==(other)
        if other.is_a?(self.class)
          @reason == other.reason
        else
          @reason == other
        end
      end

      # @return [void]
      def pretty_print(q)
        q.text "Result.failure"
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @reason
          q.text ","
          q.breakable
          q.pp @remainder
          q.text ","
          q.breakable
          q.text "#{@fatal ? "" : "non-"}fatal"
        end
      end

    private

      def deconstruct(block)
        block.call(@reason, @remainder)
      end
    end

  end
end
