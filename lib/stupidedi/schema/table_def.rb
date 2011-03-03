module Stupidedi
  module Schema

    class TableDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :header_segment_uses

      # @return [Array<SegmentUse>]
      attr_reader :trailer_segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @return [TransactionSetDef]
      attr_reader :parent

      # @todo: Is this temporary?
      attr_reader :position

      def initialize(id, position, header_segment_uses, loop_defs, trailer_segment_uses, parent)
        @id, @position, @header_segment_uses, @loop_defs, @trailer_segment_uses, @parent =
          id, position, header_segment_uses, loop_defs, trailer_segment_uses, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @header_segment_uses  = @header_segment_uses.map{|x| x.copy(:parent => self) }
          @loop_defs            = @loop_defs.map{|x| x.copy(:parent => self) }
          @trailer_segment_uses = @trailer_segment_uses.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [TableDef]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:position, @position),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      # @return [Array<SegmentUse>]
      def entry_segment_uses
        uses = []

        unless @header_segment_uses.empty?
          uses << @header_segment_uses.head
        else
          unless @trailer_segment_uses.empty?
            uses << @trailer_segment_uses.head
          end
        end

        unless @loop_defs.empty?
          uses.concat(@loop_defs.head.entry_segment_uses)
        end

        uses
      end

      # @return [Values::TableVal]
      def value(header_segment_vals, loop_vals, trailer_segment_vals, parent = nil)
        Values::TableVal.new(self, header_segment_vals, loop_vals, trailer_segment_vals, parent)
      end

      # @return [Values::TableVal]
      def empty(parent = nil)
        Values::TableVal.new(self, [], [], [], parent)
      end

      # @private
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @loop_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @trailer_segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << TableDef
      # @return [TableDef]
      def build(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, nil, header, loop_defs, trailer, nil)
      end
    end

  end
end
