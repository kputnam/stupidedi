# frozen_string_literal: true
module Stupidedi
  using Refinements

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

      def to_s
        inspect
      end

      # @return [String]
      def inspect
        if @path.present?
          parts = ["file #{@path}", "line #{@line}"]
        else
          parts = ["line #{@line}"]
        end

        if @column.present?
          parts << "column #{@column}"
        end

        parts.join(", ")
      end

      # @return [void]
      def pretty_print(q)
        q.text "Position"
        q.group(2, "(", ")") do
          q.breakable ""
          q.text "line #{@line},"
          q.breakable
          q.text "column #{@column},"
          q.breakable
          q.text "offset #{@offset}"

          unless @path.nil?
            q.text ","
            q.breakable
            q.text "path #{@path}"
          end
        end
      end
    end

    class << Position
      def caller(offset = 1)
        path, line, = Stupidedi.caller(offset + 1)
        new(nil, line, nil, path)
      end
    end
  end
end
