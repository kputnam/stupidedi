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

      def_delegators :@pointer, :count, :take, :match?, :slice,
        :index, :rindex, :reify, :last, :length, :=~, :[]

      def initialize(pointer, position)
        @pointer, @position =
          pointer, position
      end

      # NOTE: This could be implemented using def_delegators, but unfortunately
      # that allocates an Array to pass the arguments along. Since this method
      # is called frequently, we can reduce allocations by defining it this way.
      def head
        @pointer.head
      end

      # NOTE: This could be implemented using def_delegators, but unfortunately
      # that allocates an Array to pass the arguments along. Since this method
      # is called frequently, we can reduce allocations by defining it this way.
      def defined_at?(n)
        @pointer.defined_at?(n)
      end

      # NOTE: This could be implemented using def_delegators, but unfortunately
      # that allocates an Array to pass the arguments along. Since this method
      # is called frequently, we can reduce allocations by defining it this way.
      # NOTE: 
      def empty?
        @pointer.empty?
      end

      # @NOTE: This allocates 3 objects: Input, Position, and StringPtr
      def tail
        drop(1)
      end

      # @NOTE: This allocates 3 objects: Input, Position, and StringPtr, so
      # if you've written x.drop(10).position.. x.position_at(10) is cheaper
      def drop(n)
        if n.zero?
          self
        else
          self.class.new(@pointer.drop(n), position_at(n))
        end
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

      def start_with?(other)
        other and @pointer.start_with?(other)
      end

      def substr_at?(offset, other)
        other and @pointer.substr_at?(offset, other)
      end

      def is_control_character_at?(offset)
        @pointer.is_control_character_at?(offset)
      end

      # Returns a new Input with the leading control characters removed
      #
      # @return [Input]
      def lstrip_control_characters(offset = 0)
        drop(lstrip_control_characters_offset(offset))
      end

      # Returns the offset of the next non-control character at or after offset
      #
      # @return [Integer]
      def lstrip_control_characters_offset(offset = 0)
        @pointer.lstrip_control_characters_offset(offset)
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
