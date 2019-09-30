# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Tokens
    autoload :IgnoredTok,           "stupidedi/tokens/ignored_tok"
    autoload :SegmentTok,           "stupidedi/tokens/segment_tok"
    autoload :SimpleElementTok,     "stupidedi/tokens/simple_element_tok"
    autoload :ComponentElementTok,  "stupidedi/tokens/component_element_tok"
    autoload :CompositeElementTok,  "stupidedi/tokens/composite_element_tok"
    autoload :RepeatedElementTok,   "stupidedi/tokens/repeated_element_tok"
  end
end
