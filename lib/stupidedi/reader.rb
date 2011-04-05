# encoding: ISO-8859-1

module Stupidedi
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
    autoload :Position,       "stupidedi/reader/position"
    autoload :AbstractInput,  "stupidedi/reader/input/abstract_input"
    autoload :DelegatedInput, "stupidedi/reader/input/delegated_input"
    autoload :FileInput,      "stupidedi/reader/input/file_input"

    # @private
    # @return [Regexp]
    R_BASIC    = /[A-Z0-9!"&'()*+,.\/:;?= -]/.freeze

    # @private
    # @return [Regexp]
    R_EXTENDED = /[a-z%@\[\]_{}\\|<>~^`#\$ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡]/.freeze

    # @private
    # @return [Regexp]
    R_EITHER   = Regexp.union(R_BASIC, R_EXTENDED).freeze

    # @private
    # @return [String]
    C_BYTES    = (0..255).inject(""){|string, c| string << c }.freeze

    # @private
    # @return [Hash]
    H_BASIC    = C_BYTES.scan(R_BASIC).inject({}){|h,c| h[c] = nil; h }.freeze

    # @private
    # @return [Hash]
    H_EXTENDED = C_BYTES.scan(R_EXTENDED).inject({}){|h,c| h[c] = nil; h }.freeze

    # @private
    # @return [Hash]
    H_EITHER   = C_BYTES.scan(R_EITHER).inject({}){|h,c| h[c] = nil; h }.freeze

    # @private
    # @return [Regexp]
    #_CONTROL  = Regexp.new("[^#{Regexp.quote(H_EITHER.keys.join)}]")

    class << self

      # @group Constructors
      #########################################################################

      # @return [StreamReader]
      def build(input)
        StreamReader.new(Input.build(input))
      end

      # @endgroup
      #########################################################################

      # Returns true if `character` does not belong to the extended or basic
      # character set.
      #
      # @see X222.pdf B.1.1.2.4 Control Characters
      def is_control_character?(character)
        not H_EITHER.include?(character)
      end

      # @private
      # @see X222.pdf B.1.1.2.2 Basic Characters
      def is_basic_character?(character)
        H_BASIC.include?(character)
      end

      # @private
      # @see X222.pdf B.1.1.2.2 Extended Characters
      def is_extended_character?(character)
        H_EXTENDED.include?(character)
      end

      # @private
      def has_extended_characters?(string)
        R_EXTENDED =~ string
      end

      # @private
      def has_control_characters?(string)
        #_CONTROL =~ string
      end

      # @return [Character]
      # @private
      def basic_characters
        H_BASIC.keys
      end

      # @return [Character]
      # @private
      def extended_characters
        H_EXTENDED.keys
      end

      # @return [Character]
      # @private
      def control_characters
        C_BYTES.split(//) - H_EITHER.keys
      end
    end

  end
end
