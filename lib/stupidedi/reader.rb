# encoding: ISO-8859-1

module Stupidedi

  #
  #
  #
  module Reader

    autoload :Result,       "stupidedi/reader/result"
    autoload :Success,      "stupidedi/reader/result"
    autoload :Failure,      "stupidedi/reader/result"

    autoload :StreamReader, "stupidedi/reader/stream_reader"
    autoload :TokenReader,  "stupidedi/reader/token_reader"
    autoload :Separators,   "stupidedi/reader/separators"
    autoload :SegmentDict,  "stupidedi/reader/segment_dict"

    autoload :ComponentElementTok,  "stupidedi/reader/tokens/component_element_tok"
    autoload :CompositeElementTok,  "stupidedi/reader/tokens/composite_element_tok"
    autoload :RepeatedElementTok,   "stupidedi/reader/tokens/repeated_element_tok"
    autoload :SegmentTok,           "stupidedi/reader/tokens/segment_tok"
    autoload :SimpleElementTok,     "stupidedi/reader/tokens/simple_element_tok"

    autoload :Input,          "stupidedi/reader/input"
    autoload :AbstractInput,  "stupidedi/reader/input/abstract_input"
    autoload :DelegatedInput, "stupidedi/reader/input/delegated_input"
    autoload :FileInput,      "stupidedi/reader/input/file_input"

    # @private
    R_BASIC    = /[A-Z0-9!"&'()*+,.\/:;?= -]/

    # @private
    R_EXTENDED = /[a-z%@\[\]_{}\\|<>~^`#\$ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡]/

    # @private
    R_EITHER   = Regexp.union(R_BASIC, R_EXTENDED)

    # @private
    C_BYTES    = (0..255).inject(""){|string, c| string << c }

    # @private
    C_EITHER   = (C_BYTES.scan(R_EITHER)).inject({}){|h,c| h[c] = nil; h }

    class << self

      # Returns non-nil if c does not belong to the extended or basic character
      # set.
      #
      # @note This does not match the specification of control characters given
      #   in X12.5, but I haven't seen the actual usage of control characters.
      #   So for our purposes, they basically are characters that we want to
      #   ignore.
      #
      # @param [String] character
      def is_control_character?(character)
        not Reader::C_EITHER.include?(character)
      end

    end

  end
end
