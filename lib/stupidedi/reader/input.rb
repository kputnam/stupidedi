# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class Input
      include Inspect

      # @return [StringPtr]
      attr_reader :pointer

      # @return [Position]
      attr_reader :position

      def_delegators :@pointer, :defined_at?, :empty?, :count, :head, :take,
        :match?, :slice, :index, :rindex, :reify, :last, :length, :=~, :[]

      def initialize(pointer, position)
        @pointer, @position =
          pointer, position
      end

      # @NOTE: This allocates 3 objects: Input, Position, and StringPtr
      def tail
        drop(1)
      end

      # @NOTE: This allocates 3 objects: Input, Position, and StringPtr, so
      # if you've written x.drop(10).position.. x.position_at(10) is cheaper
      def drop(n)
        self.class.new(@pointer.drop(n), position_at(n))
      end

      # NOTE: This allocates 2 objects: StringPtr and Position
      def position_at(n)
        if @position.eql?(NoPosition)
          @position
        elsif @position.is_a?(Integer)
          @position + n
        else
          @position.advance(@pointer.take(n))
        end
      end
    end

    class << Input
      def build(value, position = NoPosition)
        if value.is_a?(String)
          string(value, position)
        elsif defined?(Pathname) and value.is_a?(Pathname)
          file(value, position)
        elsif value.is_a?(Input)
          value
        elsif value.respond_to?(:read)
          path = value.path if value.respond_to?(:path)
          new(Pointer.build(value.read), position.build(path))
        else
          raise TypeError,
            "value must be a String, Pathname, or respond to #read"
        end
      end

      def file(path, position = NoPosition)
        new(Pointer.build(File.read(path)), position.build(path))
      end

      def string(value, position = NoPosition)
        new(Pointer.build(value), position.build(nil))
      end
    end
  end
end
