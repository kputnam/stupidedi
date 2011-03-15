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
    autoload :DelegatedInput, "stupidedi/reader/input/delegated_input"
    autoload :FileInput,      "stupidedi/reader/input/file_input"

    R_BASIC    = /[A-Z0-9!"&'()*+,.\/:;?= -]/
    R_EXTENDED = /[a-z%@\[\]_{}\\|<>~^`#\$ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡]/
    R_EITHER   = Regexp.union(R_BASIC, R_EXTENDED)

    C_BYTES    = (0..255).inject(""){|string, c| string << c }
    C_EITHER   = (C_BYTES.scan(R_EITHER)).inject({}){|h,c| h[c] = nil; h }

    class << self
      # Returns non-nil if c belongs to the basic character set
      def is_basic_character?(character)
        # @todo
      end

      # Returns non-nil if c belongs to the extended character set
      def is_extended_character?(character)
        # @todo
      end

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

      # Strips control characters from the string, leaving only basic and
      # extended characters
      #
      # @param [String] string
      # @return [String]
      def strip(string)
        string.scan(Reader::EITHER).join
      end

      # @private
      def basic_characters
        # @todo
      end

      # @private
      def extended_characters
        # @todo
      end

      # @private
      def control_characters
        # @todo
      end
    end

  end
end
