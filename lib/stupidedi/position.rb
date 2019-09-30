# frozen_string_literal: true
module Stupidedi
  using Refinements

  #
  # This mixin is intended to be used with a user-defined Struct. This
  # scheme allows customization of what position information is tracked via
  # the tokenizer and passed along into the parse tree. For example,
  #
  #     TinyPosition = Struct.new(:offset)
  #     TinyPosition.include(Stupidedi::Position)
  #
  #     anonClass = Struct.new(:name, :line)
  #     anonClass.include(Stupidedi::Position)
  #
  #     class BigPosition < Struct.new(:name, :line, :column, :offset)
  #       include Stupidedi::Position
  #
  #       # Return 50 chars before and after this position
  #       def context(input)
  #         input[offset - 50, 50] + " >> " + input[offset, 50]
  #       end
  #     end
  #
  # Normally it would be fine to just track everything and let the user
  # disregard what's not interesting. However, to conserve memory, it's
  # beneficial to track the minimum.
  #
  # Here's how the memory footprint works out:
  #
  #  * `column`: 40 bytes
  #  * `offset`: 40 bytes
  #  * `line`: 40 bytes
  #  * `name`: 40 bytes for short strings; 64 bytes plus one byte for every
  #     byte longer than 23 bytes.
  #
  # The Position object itself also consumes 40 bytes, as long as it has three
  # or fewer fields. Once a fourth field is added, another 40 bytes are
  # consumed. So tracking three or fewer numeric-only fields consumes 40 bytes.
  # But adding the fourth field increases that to 100 bytes + length of name.
  # Tracking the name and two or less integer fields consumes 60 + length of the
  # name string.
  #
  # Because a position is attached to each individual part of syntax (the
  # start of a segment, the start of each individual element), this can add
  # up to a lot of space. In different situations, the user may independently
  # know the file name and not need it stored here. Or they may not care
  # about the offset and manage with only line and column numbers.
  #
  # The default {NoPosition} implementation is provided which still consumes
  # 40 bytes, but only one instance is ever created.
  #
  module Position
    autoload :NoPosition,         "stupidedi/position/no_position"
    autoload :OffsetPosition,     "stupidedi/position/offset_position"
    autoload :StacktracePosition, "stupidedi/position/stacktrace_position"

    def self.included(base)
      base.__send__(:extend,  ClassMethods)
      base.__send__(:include, InstanceMethods)
    end

    # @private
    module ClassMethods
      def build(name)
        new.reset(name, 1, 1, 0)
      end

      def caller(offset = 1)
        name, line, = Stupidedi.caller(offset + 1)
        new.reset(name, line, nil, nil)
      end
    end

    # @private
    module InstanceMethods
      # @return [String]
      def to_s
        parts  = []
        parts << name               if respond_to?(:name) and name.present?
        parts << "line #{line}"     if respond_to?(:line)
        parts << "column #{column}" if respond_to?(:column)
        parts << "offset #{offset}" if respond_to?(:offset)
        parts.join(", ")
      end

      # Calculate the new position if we started on the current position and
      # then read the given input.
      #
      # @param  input [#length, #count, #rindex]
      # @return [self.class]
      def advance(input)
        length_  = input.length
        r_name   = respond_to?(:name)
        r_line   = respond_to?(:line)
        r_column = respond_to?(:column)
        r_offset = respond_to?(:offset)

        if r_line or r_column
          lines_  = input.count("\n")
        end

        if r_column
          column_ = if lines_.zero?
                      length_ + column
                    else
                      length_ - input.rindex("\n")
                    end
        end

        # Use `clone` because it's already implemented for Struct and any other
        # class. Otherwise we would prefer our own `#copy(changes)` convention.
        clone.reset \
          r_name   ? name : nil,
          r_line   ? line + lines_ : nil,
          r_column ? column_ : nil,
          r_offset ? offset + length_ : nil
      end

      # @return self
      def reset(name, line, column, offset)
        self[:name]   = name   if respond_to?(:name)
        self[:line]   = line   if respond_to?(:line)
        self[:column] = column if respond_to?(:column)
        self[:offset] = offset if respond_to?(:offset)
        self
      end
    end
  end
end
