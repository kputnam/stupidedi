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

      # @return [Integer]
      attr_reader :position

      def initialize(id, position, repeatable, header_segment_uses, loop_defs, trailer_segment_uses, parent)
        @id, @position, @repeatable, @header_segment_uses, @loop_defs, @trailer_segment_uses, @parent =
          id, position, repeatable, header_segment_uses, loop_defs, trailer_segment_uses, parent

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
          changes.fetch(:repeatable, @repeatable),
          changes.fetch(:header_segment_uses, @header_segment_uses),
          changes.fetch(:loop_defs, @loop_defs),
          changes.fetch(:trailer_segment_uses, @trailer_segment_uses),
          changes.fetch(:parent, @parent)
      end

      def repeatable?
        @repeatable
      end

      # @return [Array<SegmentUse>]
      def entry_segment_uses
        min  = 1.0 / 0.0
        uses = []
        
        @header_segment_uses.each do |u|
          if u.position < min
            min   = u.position
            uses << u
          end
        end

        @loop_defs.each do |l|
          if l.entry_segment_use.position < min
            min   = l.entry_segment_use.position
            uses << l.entry_segment_use
          end
        end

        @trailer_segment_uses.each do |u|
          if u.position < min
            min   = u.position
            uses << u
          end
        end

        return uses
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
      def header(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 1, false, header, loop_defs, trailer, nil)
      end

      # @return [TableDef]
      def detail(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 2, true, header, loop_defs, trailer, nil)
      end

      # @return [TableDef]
      def summary(id, *children)
        header, children   = children.split_when{|x| x.is_a?(LoopDef) }
        loop_defs, trailer = children.split_when{|x| x.is_a?(SegmentUse) }
        new(id, 3, false, header, loop_defs, trailer, nil)
      end
    end

  end
end
