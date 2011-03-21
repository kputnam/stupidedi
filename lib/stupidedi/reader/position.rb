module Stupidedi
  module Reader

    class Position

      # @return [Integer]
      attr_reader :offset

      # @return [Integer]
      attr_reader :line

      # @return [Integer]
      attr_reader :column

      # @return [String, Pathname]
      attr_reader :path

      def initialize(offset, line, column, path)
        @offset, @line, @column, @path =
          offset, line, column, path
      end

      def copy(changes = {})
        Position.new \
          changes.fetch(:offset, @offset),
          changes.fetch(:line, @line),
          changes.fetch(:column, @column),
          changes.fetch(:path, @path)
      end
    end

  end
end
