# frozen_string_literal: true
# encoding: utf-8
module Stupidedi
  using Refinements

  module Reader
    class Input
      include Inspect

      # @return [StringPtr]
      attr_reader :pointer

      # @return [Position]
      attr_reader :position

      def_delegators :@pointer, :head, :defined_at?, :empty?, :[], :length,
        :count, :take, :match?, :slice, :index, :rindex, :reify, :last, :=~,
        :at, :encoding, type: StringPtr

      def initialize(pointer, position)
        @pointer, @position =
          pointer, position
      end

      # @endgroup
      #########################################################################

      # Returns the input with the first `n` characters removed
      #
      # @return [Input]
      def drop(n)
        if n.zero?
          self
        else
          self.class.new(@pointer.drop(n), position_at(n))
        end
      end

      # Destructively updates this Input to start `n` characters after the
      # first.
      #
      # @return [Input]
      def drop!(n)
        unless n.zero?
          if @position.is_a?(Integer)
            @pointer.drop!(n)
            @position += n
          else
            unless @position.eql?(Position::NoPosition)
              @position = @position.advance(@pointer.take(n))
            end

            @pointer.drop!(n)
          end
        end

        self
      end

      # Calculates the position at the given offset.
      # 
      # @return [Position]
      def position_at(n)
        if @position.eql?(Position::NoPosition)
          @position
        elsif @position.is_a?(Integer)
          @position + n
        else
          @position.advance(@pointer.take(n))
        end
      end

      # Returns true if the input begins with the other value (String, StringPtr)
      def start_with?(other)
        other and @pointer.start_with?(other)
      end

      # Returns true if the input contains the other value, starting at the
      # `nth` character.
      #
      def substr_at?(offset, other)
        other and @pointer.substr_at?(offset, other)
      end

      # Returns true if the character at the given offset is a control
      # character (defined by X222.pdf B.1.1.2.4 Control Characters)
      def graphic?(offset)
        @pointer.graphic?(offset)
      end

      # Returns a new Input with the leading control characters removed
      #
      # @return [Input]
      def lstrip_nongraphic(offset = 0)
        drop(min_graphic_index(offset))
      end

      # Returns the offset of the next non-control character at or after offset
      #
      # @return [Integer]
      def min_graphic_index(offset = 0)
        @pointer.min_graphic_index(offset)
      end
    end

    class << Input
      # @group Constructors
      #########################################################################

      # @example
      #   Input.build(File.open("sample.edi"), mode: "rb")
      #   Input.build(File.read("sample.edi", encoding: "UTF-8"))
      #   Input.build(Pathname.new("sample.edi"), position: Position::OffsetPosition)
      #
      def build(value, *args)
        if value.is_a?(String)
          string(value, *args)

        elsif defined?(Pathname) and value.is_a?(Pathname)
          file(value, *args)

        elsif value.is_a?(Input)
          value

        elsif value.respond_to?(:read)
          position = args.last.delete(:position) if args.last.is_a?(Hash)
          path     = value.path if value.respond_to?(:path)
          new(Pointer.build(value.read), (position || Position::NoPosition).build(path))

        else
          raise TypeError,
            "value must be a String, Pathname, or respond to #read"
        end
      end

      #
      # @example
      #   Input.file("example.edi", length, offset)
      #   Input.file("example.edi", mode: "rb")
      #   Input.file("example.edi", encoding: "US-ASCII")
      #   Input.file("example.edi", position: Position::NoPosition)
      #
      def file(path, *args)
        position =
          if args.last.is_a?(Hash)
            args.last.delete(:position)
          end || Position::NoPosition

        new(Pointer.build(File.read(path, *args)), position.build(path))
      end

      # @example
      #   Input.string(io.read)
      #   Input.string("...", position: Position::OffsetPosition)
      #
      def string(value, *args)
        position =
          if args.last.is_a?(Hash)
            args.last.delete(:position)
          end || Position::NoPosition

        new(Pointer.build(value), position.build(nil))
      end

      # @endgroup
      #########################################################################
    end
  end
end
