# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Tokens
    class SegmentTok
      include Inspect

      # @return [Symbol]
      attr_reader :id

      # @return [Array<CompositeElementTok, SimpleElementTok>]
      attr_reader :element_toks

      # @return [Position]
      attr_reader :position

      def initialize(id, element_toks, position)
        @id, @element_toks, @position =
          id, element_toks, position
      end

      # @return [SegmentTok]
      def copy(changes = {})
        SegmentTok.new \
          changes.fetch(:id, @id),
          changes.fetch(:element_toks, @element_toks),
          changes.fetch(:position, @position)
      end

      # :nocov:
      def pretty_print(q)
        q.pp(:segment.cons(@id.cons(@element_toks)))
      end
      # :nocov:

      def blank?
        @element_toks.all?(&:blank?)
      end

      def present?
        not blank?
      end

      # This is a hacky way to get InterchangeDef#separators to work with
      # both SegmentVal and SegmentTok; that saves a few steps when just
      # doing tokenization (not parsing)
      #
      # @private
      # @return [SimpleElementTok or CompositeElementVal]
      def element(m, n = nil, o = nil)
        unless m > 0
          raise ArgumentError,
            "m must be positive"
        end

        unless n.nil?
          @element_toks.at(m - 1).element(n, o)
        else
          @element_toks.at(m - 1).value
        end
      end

      def to_x12(separators)
        if blank?
          "#{id}#{(separators.segment || "~").strip}"
        else
          es  = @element_toks.map{|x| x.to_x12(separators) }
          sep = separators.element || "*"
          eos = separators.segment || "~"
          id.cons(es).join(sep).gsub(/#{Regexp.escape(sep)}+$/, "") + eos.strip
        end
      end
    end

    class << SegmentTok
      #########################################################################
      # @group Constructors

      # @return [SegmentTok]
      def build(id, element_toks, position)
        new(id, element_toks, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end
