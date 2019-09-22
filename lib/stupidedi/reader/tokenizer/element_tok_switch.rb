# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    class Tokenizer
      #
      # This is a bit clunky, but we can save quite a lot of memory allocation
      # by reusing our ElementTokBuilders. This is done by keeping a pair and
      # reseting them before giving to a caller. Otherwise, one of these would
      # be allocated each time a simple or composite is tokenized, then thrown
      # out once it's finished.
      #
      class ElementTokSwitch
        include Inspect

        def initialize
          @repeatable    = ElementTokBuilder::Repeatable.new(nil)
          @nonrepeatable = ElementTokBuilder::NonRepeatable.new(nil)
        end

        # Toggles the behavior of `#add`. When repeatable, it accumulates an
        # array of elements; otherwise it only stores the most recent.
        def switch(repeatable, position)
          @active = repeatable ? @repeatable : @nonrepeatable
          @active.reset!(position)
          @active
        end

        # @return self
        def add(element_tok)
          @active.add(element_tok)
          self
        end

        # @return [Tokens::SimpleElementTok | Tokens::CompositeElementTok | Tokens::ComponentElementTok]
        def build
          @active.build
        end

        # @private
        class ElementTokBuilder
          include Inspect

          # @return self
          abstract :add

          abstract :build

          # @return self
          abstract :reset!

          # @return [Position]
          abstract :position

          # @private
          class Repeatable < ElementTokBuilder
            # @return [Position]
            attr_reader :position

            def initialize(position)
              @position     = nil
              @element_toks = nil
            end

            def add(element_tok)
              @element_toks.push(element_tok)
            end

            def build
              Tokens::RepeatedElementTok.build(@element_toks, @position)
            end

            def reset!(position)
              @position     = position
              @element_toks = []
            end
          end

          # @private
          class NonRepeatable < ElementTokBuilder
            # @return [Position]
            attr_reader :position

            def initialize(position)
              @position = position
            end

            def add(element_tok)
              @element_tok = element_tok
            end

            def build
              @element_tok
            end

            def reset!(position)
              @position    = position
              @element_tok = nil
            end
          end
        end
      end
    end
  end
end
