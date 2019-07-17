module Stupidedi
  module TransactionSets
    module Builder
      class Dsl

        def self.build(ac, code, name, &block)
          body = DocumentBodyDSL.new(&block).tables
          Builder.build(ac, code, name, *body)
        end

        private

        module ElementSyntax

          def element(*args)
            add_element(Builder::Element(*args))
          end

          def composite(*args, &block)
            subelements = SegmentBodyDSL.new(&block).elements
            add_element(Builder::Element(*(args + subelements)))
          end

        end

        module SegmentSyntax

          def segment(pos, type, name, req, repeat, &block)
            elements = SegmentBodyDSL.new(&block).elements
            segment = Builder::Segment(
              pos,
              type,
              name,
              req,
              repeat,
              *elements
            )

            add_segment(segment)
          end

        end

        module LoopSyntax

          def loop_(name, repeat, &block)
            body = LoopBodyDSL.new(&block).elements
            add_loop(Schema::LoopDef.build(name, repeat, *body))
          end

        end

        module TableSyntax

          def table_header(name, &block)
            add_table(Schema::TableDef.header(name, *get_table_contents(&block)))
          end

          def table_detail(name, &block)
            add_table(Schema::TableDef.detail(name, *get_table_contents(&block)))
          end

          def get_table_contents(&block)
            TableBodyDSL.new(&block).elements
          end

        end

        module RepeatSyntax

          def repeat_bounded(n)
            Schema::RepeatCount.bounded(n)
          end

          def repeat_unbounded
            Schema::RepeatCount.unbounded
          end

        end

        module ValuesSyntax

          def values(*args)
            Builder::Values(*args)
          end

        end

        class LoopBodyDSL

          include LoopSyntax
          include SegmentSyntax
          include RepeatSyntax

          def initialize(&block)
            @elements = []
            instance_eval(&block)
          end

          attr_accessor :elements

          def add_loop(loop_)
            elements << loop_
          end

          def add_segment(segment)
            elements << segment
          end

        end

        class SegmentBodyDSL

          include ElementSyntax
          include ValuesSyntax

          def initialize(&block)
            @elements = []
            instance_eval(&block)
          end

          def add_element(e)
            @elements << e
          end

          attr_accessor :elements
        end

        class TableBodyDSL

          include LoopSyntax
          include SegmentSyntax
          include RepeatSyntax

          def initialize(&block)
            @elements = []
            instance_eval(&block)
          end

          def add_loop(l)
            @elements << l
          end

          def add_segment(segment)
            @elements << segment
          end

          attr_accessor :elements
        end

        class DocumentBodyDSL

          include TableSyntax

          def initialize(&block)
            @tables = []
            instance_eval(&block)
          end

          attr_accessor :tables

          def add_table(table)
            tables << table
          end

        end

      end
    end
  end
end
