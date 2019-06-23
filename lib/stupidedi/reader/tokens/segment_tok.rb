# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class SegmentTok
      include Inspect

      # @return [Symbol]
      attr_reader :segment_id

      # @return [Array<CompositeElementTok, SimpleElementTok>]
      attr_reader :element_toks

      # @return [Position]
      attr_reader :position

      def initialize(segment_id, element_toks, position)
        @segment_id, @element_toks, @position =
          segment_id, element_toks, position
      end

      # @return [SegmentTok]
      def copy(changes = {})
        SegmentTok.new \
          changes.fetch(:segment_id, @segment_id),
          changes.fetch(:element_toks, @element_toks),
          changes.fetch(:position, @position)
      end

      # :nocov:
      def pretty_print(q)
        q.pp(:segment.cons(@segment_id.cons(@element_toks)))
      end
      # :nocov:

      def blank?
        @element_toks.all?(&:blank?)
      end

      def present?
        not blank?
      end

      def to_x12(separators)
        if blank?
          "#{segment_id}#{(separators.segment || "~").strip}"
        else
          es  = @element_toks.map{|x| x.to_x12(separators) }
          sep = separators.element || "*"
          eos = separators.segment || "~"
          segment_id.cons(es).join(sep).gsub(/#{Regexp.escape(sep)}+$/, "") + eos.strip
        end
      end
    end

    class << SegmentTok
      # @group Constructors
      #########################################################################

      # @return [SegmentTok]
      def build(segment_id, element_toks, position)
        new(segment_id, element_toks, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end
