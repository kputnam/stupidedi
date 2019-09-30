# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class Tokenizer
      class Result
        include Inspect

        # @return [Boolean]
        abstract :fail?

        # @return [Position]
        abstract :position

        class Fail < Result
          # @return [String]
          attr_reader :error

          # @return [Position]
          attr_reader :position

          # @return [Boolean]
          attr_accessor :fatal

          def initialize(error, position, fatal = false)
            @error    = error
            @position = position
            @fatal    = fatal
          end

          def fail?
            true
          end

          def fatal?
            @fatal
          end

          # @yield [String]
          def explain
            yield @error
          end

          def to_s
            if @position.equal?(Position::NoPosition)
              @error
            else
              "%s at %s" % [@error, @position]
            end
          end
        end

        class Done < Result
          # @return [Object]
          attr_reader :value

          # The remaining, unconsumed input
          #
          # @return [Input]
          attr_reader :rest

          # The position within the input attributed to `value`. In many cases
          # in the tokenizer, the `value` itself also carries a position, but
          # this is useful for cases where the value does not (_read_segment_id)
          #
          # @return [Position]
          attr_reader :position

          def initialize(value, position, rest)
            @value    = value
            @position = position
            @rest     = rest
          end

          def fail?
            false
          end

          def fatal?
            false
          end

          # @return self
          def explain
            self
          end
        end
      end
    end
  end
end
