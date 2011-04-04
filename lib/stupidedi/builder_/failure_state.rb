module Stupidedi
  module Builder

    class FailureState < AbstractState

      # @return [AbstractState]
      attr_reader :parent

      # @return [SegmentTok]
      attr_reader :segment_tok

      # @return [String]
      attr_reader :explanation

      def initialize(explanation, segment_tok, parent)
        @explanation, @segment_tok, @parent =
          explanation, segment_tok, parent
      end

      # @return true
      def failure?
        true
      end

      def leaf?
        true
      end

      # @return nil
      def instructions
        nil
      end

      # @return [Zipper::AbstractZipper]
      def zipper
        @parent.zipper
      end

      # @return [void]
      def pop(count)
        raise Exceptions::ParseError,
          "FailureState#pop should not be called"
      end

      # @return [void]
      def drop(count)
        raise Exceptions::ParseError,
          "FailureState#drop should not be called"
      end

      # @return [void]
      def add(segment_tok, segment_use)
        raise Exceptions::ParseError,
          "FailureState#add should not be called"
      end

      # @return [void]
      def pretty_print(q)
        q.text("FailureState")
        q.group(2, "(", ")") do
          q.breakable ""

          q.pp @explanation
          q.text ","
          q.breakable

          q.pp @segment_tok
          q.text ","
          q.breakable

          q.pp zipper.node
        end
      end
    end

  end
end
