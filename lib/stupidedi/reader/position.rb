# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader

    #
    # This module is intended to be used with a user-defined Struct. This
    # scheme allows customization of what position information is tracked via
    # the tokenizer and passed along into the parse tree.
    #
    # For example,
    #
    #   TinyPosition = Struct.new(:offset)
    #   TinyPosition.include(Stupidedi::Reader::Position)
    #
    #   anonClass = Struct.new(:path, :line)
    #   anonClass.include(Stupidedi::Reader::Position)
    #
    #   class BigPosition < Struct.new(:path, :line, :column, :offset)
    #     include Stupidedi::Reader::Position
    #
    #     # Return 50 chars before and after this position
    #     def context(input)
    #       input[offset - 50, 50] + " >> " + input[offset, 50]
    #     end
    #   end
    #
    # Normally it would be fine to just track everything and let the user
    # disregard what's not interesting. However, to conserve memory, it's
    # beneficial to track the minimum.
    #
    # Here's how the memory footprint works out:
    #   path: roughly 20 bytes + length of string in bytes, but minimum is 40
    #   line: represented directly, so no overhead besides the VALUE struct
    #   column: same
    #   offset: same
    #
    # The Position object itself also consumes 40 bytes, as long as it has three
    # or fewer fields. Once a fourth field is added, another 40 bytes are
    # consumed.
    #
    # So tracking three or fewer numeric-only fields consumes 40 bytes. But
    # adding the fourth field increases that to 100 bytes + length of path.
    # Tracking the path and two or less integer fields consumes 60 + length of
    # the path string.
    #
    # Because a position is attached to each individual part of syntax (the
    # start of a segment, the start of each individual element), this can add
    # up to a lot of space. In different situations, the user may independently
    # know the file path and not need it stored here. Or they may not care
    # about the offset and manage with only line and column numbers.
    #
    # The default NoPosition implementation is provided which still consumes
    # 40 bytes, but only one instance is created.
    #

    module Position
      def self.included(base)
        base.__send__(:extend,  ClassMethods)
        base.__send__(:include, InstanceMethods)
      end

      module ClassMethods
        def caller(offset = 1)
          path, line, = Stupidedi.caller(offset + 1)
          new.reset(path, line, nil, nil)
        end
      end

      module InstanceMethods
        def to_s
          inspect
        end

        # @return [String]
        def inspect
          parts  = []
          parts << "path #{path}"     if respond_to?(:path)
          parts << "line #{line}"     if respond_to?(:line)
          parts << "column #{column}" if respond_to?(:column)
          parts << "offset #{offset}" if respond_to?(:offset)
          parts.join(", ")
        end

        def reset(path, line, column, offset)
          self[:path]   = path   if respond_to?(:path)
          self[:line]   = line   if respond_to?(:line)
          self[:column] = column if respond_to?(:column)
          self[:offset] = offset if respond_to?(:offset)
          self
        end
      end
    end

    class NoPosition
      def to_s
        inspect
      end

      def inspect
        "no position info"
      end

      def reset(path, line, column, offset)
      end
    end

    class << NoPosition
      def caller(offset = 1)
        @instance ||= NoPosition.allocate
      end

      def new(*args)
        @instance ||= NoPosition.allocate
      end
    end
  end
end
