# frozen_string_literal: true

module Stupidedi
  using Refinements

  class Either

    # @return [Boolean]
    abstract :defined?

    ###########################################################################
    # @group Filtering the Value

    # @return [Either]
    abstract :select, :args => %w(reason='select' &block)

    # @return [Either]
    abstract :reject, :args => %w(reason='reject' &block)

    # @endgroup
    ###########################################################################

    ###########################################################################
    # @group Transforming the Value

    # @return [Either]
    abstract :map, :args => %w(&block)

    # @return [Either]
    abstract :flatmap, :args => %w(&block)

    # @return [Either]
    abstract :or, :args => %w(&block)

    # @return [Either]
    abstract :explain, :args => %w(&block)

    # @return [Object]
    abstract :fetch, :args => %w(default)

    # @endgroup
    ###########################################################################

    class Success < Either

      def initialize(value)
        @value = value
      end

      def copy(changes = {})
        Success.new \
          changes.fetch(:value, @value)
      end

      # @return true
      def defined?
        true
      end

      def fetch(default = nil)
        @value
      end

      #########################################################################
      # @group Filtering the Value

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Boolean]
      def select(reason = "select", &block)
        if deconstruct(block)
          self
        else
          failure(reason)
        end
      end

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Boolean]
      def reject(reason = "reject", &block)
        if deconstruct(block)
          failure(reason)
        else
          self
        end
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Transforming the Value

      # @return [Success]
      # @yieldparam value
      # @yieldreturn value
      def map(&block)
        copy(:value => deconstruct(block))
      end

      # @return [Either]
      # @yieldparam value
      # @yieldreturn [Either]
      def flatmap(&block)
        result = deconstruct(block)

        if result.is_a?(Either)
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      # @return [Success]
      def or
        self
      end

      # @return [Success]
      def explain
        self
      end

      # @endgroup
      #########################################################################

      def tap(&block)
        deconstruct(block); self
      end

      # @return [Boolean]
      def ==(other)
        other.is_a?(Either) and other.select{|x| x == @value }.defined?
      end

      # @return [void]
      def pretty_print(q)
        q.text("Either.success")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end

      # @return [String]
      def inspect
        "Either.success(#{@value.inspect})"
      end

    private

      def deconstruct(block)
        block.call(@value)
      end

      def failure(reason)
        Either::Failure.new(reason)
      end
    end

    class Failure < Either

      attr_reader :reason

      def initialize(reason)
        @reason = reason
      end

      # @return [Failure]
      def copy(changes = {})
        Failure.new \
          changes.fetch(:reason, @reason)
      end

      # @return false
      def defined?
        false
      end

      def fetch(default = nil)
        default
      end

      #########################################################################
      # @group Filtering the Value

      # @return [Failure]
      def select(reason = nil)
        self
      end

      # @return [Failure]
      def reject(reason = nil)
        self
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Transforming the Value

      # @return [Failure]
      def map
        self
      end

      # @return [Failure]
      def flatmap
        self
      end

      # @return [Either]
      # @yieldparam reason
      # @yieldreturn [Either]
      def or(&block)
        result = deconstruct(block)

        if result.is_a?(Either)
          result
        else
          raise TypeError, "block did not return an instance of Either"
        end
      end

      # @return [Failure]
      # @yieldparam reason
      # @yieldreturn reason
      def explain(&block)
        copy(:reason => deconstruct(block))
      end

      # @endgroup
      #########################################################################

      def tap
        self
      end

      # @return [Boolean]
      def ==(other)
        other.is_a?(self.class) and other.reason == @reason
      end

      # @return [void]
      def pretty_print(q)
        q.text("Either.failure")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @reason
        end
      end

      # @return [String]
      def inspect
        "Either.failure(#{@reason.inspect})"
      end

    private

      def deconstruct(block)
        block.call(@reason)
      end
    end

  end

  class << Either
    ###########################################################################
    # @group Constructors

    # @return [Success]
    def success(value)
      Either::Success.new(value)
    end

    # @return [Failure]
    def failure(reason)
      Either::Failure.new(reason)
    end

    # @endgroup
    ###########################################################################
  end

  Either.eigenclass.send(:protected, :new)
  Either::Success.eigenclass.send(:public, :new)
  Either::Failure.eigenclass.send(:public, :new)

end
