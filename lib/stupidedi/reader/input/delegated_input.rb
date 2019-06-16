# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class DelegatedInput < AbstractInput
      def initialize(delegate, offset = 0, line = 1, column = 1)
        @delegate, @line, @column =
          delegate, line, column
      end

      # @group Querying the Position
      ########################################################################

      # (see AbstractInput#offset)
      def offset
        nil
      end

      # (see AbstractInput#line)
      attr_reader :line

      # (see AbstractInput#column)
      attr_reader :column

      # (see AbstractInput#position)
      def position
        Position.new(nil, @line, @column, nil)
      end

      # @group Reading the Input
      ########################################################################

      # (see AbstractInput#take)
      def_delegators :@delegate, :take

      # (see AbstractInput#at)
      def_delegators :@delegate, :at

      # (see AbstractInput#index)
      def_delegators :@delegate, :index

      # @group Advancing the Cursor
      ########################################################################

      # (see AbstractInput#drop)
      def drop(n)
        raise ArgumentError, "n must be positive" unless n >= 0

        prefix = @delegate.take(n)
        length = prefix.length
        count  = prefix.count("\n")

        column = unless count.zero?
                   length - prefix.rindex("\n")
                 else
                   @column + length
                 end

        copy(:delegate => @delegate.drop(n),
             :line     => @line + count,
             :column   => column)
      end

      # @group Testing the Input
      ########################################################################

      # (see AbstractInput#defined_at?)
      def_delegators :@delegate, :defined_at?

      # (see AbstractInput#empty?)
      def_delegators :@delegate, :empty?

      # (see AbstractInput#==)
      def_delegators :@delegate, :==

      # @endgroup
      ########################################################################

      # @return [void]
      def pretty_print(q)
        q.text("DelegateInput")
        q.group(2, "(", ")") do
          preview = @delegate.take(4)
          preview = if preview.empty?
                      "EOF"
                    elsif preview.length <= 3
                      preview.inspect
                    else
                      (preview.take(3) + "...").inspect
                    end

          q.text preview
          q.text " at line #{@line}, column #{@column}, offset #{nil}"
        end
      end

    private

      # @return [DelegatedInput]
      def copy(changes = {})
        DelegatedInput.new \
          changes.fetch(:delegate, @delegate),
          nil,
          changes.fetch(:line, @line),
          changes.fetch(:column, @column)
      end
    end
  end
end
