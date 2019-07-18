module Stupidedi
  module TransactionSets
    module Builder
      class Dsl

        ##
        # Build a definition for a given document using DSL-style.
        # DSL style is a bit easier to use than manually building a syntax tree.
        def self.build(shortcode, code, name, &block)
          body = DocumentBodyDSL.new(&block).tables
          Builder.build(shortcode, code, name, *body)
        end

        private

        ##
        # Syntax for DSLs in which you can define elements.
        module ElementSyntax

          ##
          # Define an element within this block
          def element(*args)
            add_element(Builder::Element(*args))
          end

          ##
          # Define a composite element within this block, using a sub-block for the sub-elements
          def composite(*args, &block)
            subelements = SegmentBodyDSL.new(&block).elements
            add_element(Builder::Element(*(args + subelements)))
          end

        end

        ##
        # Syntax for DSLs in which you can define segments.
        module SegmentSyntax

          def segment(pos, type, name, requirement, repeat, &block)
            elements = SegmentBodyDSL.new(&block).elements
            segment = Builder::Segment(
              pos,
              type,
              name,
              requirement,
              repeat,
              *elements
            )

            add_segment(segment)
          end

        end

        ##
        # Syntax for DSLs in which you can define loops.
        module LoopSyntax

          ##
          # Define a loop within this block.
          # The underscore is there because "loop" is a ruby keyword.
          def loop_(name, repeat, &block)
            body = LoopBodyDSL.new(&block).elements
            add_loop(Schema::LoopDef.build(name, repeat, *body))
          end

        end

        ##
        # Syntax for DSLs in which you can define tables.
        module TableSyntax

          ##
          # Define a header table within this block.
          def table_header(name, &block)
            add_table(Schema::TableDef.header(name, *get_table_contents(&block)))
          end

          ##
          # Define a detail table within this block
          def table_detail(name, &block)
            add_table(Schema::TableDef.detail(name, *get_table_contents(&block)))
          end

          ##
          # Helper method to get the body of a table.
          def get_table_contents(&block)
            TableBodyDSL.new(&block).elements
          end

        end

        ##
        # Syntax for DSLs in which you can define values lists.
        module ValuesSyntax

          def values(*args)
            Builder::Values(*args)
          end

        end

        ##
        # A DSL for the body of a loop, which allows defining loops and segments
        class LoopBodyDSL

          include LoopSyntax
          include SegmentSyntax

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

        ##
        # A DSL for the body of a segment, which allows defining elements and using
        # values lists.
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

        ##
        # A DSL for the body of a table, which allows defining segments and loops.
        class TableBodyDSL

          include LoopSyntax
          include SegmentSyntax

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

        ##
        # A DSL for the body of a document, which allows defining tables.
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
