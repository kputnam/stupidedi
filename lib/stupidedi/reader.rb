# encoding: ISO-8859-1

module Stupidedi
  module Reader

    autoload :Success,       "stupidedi/reader/success"
    autoload :Failure,       "stupidedi/reader/failure"

    autoload :DefaultReader, "stupidedi/reader/default_reader"
    autoload :StreamReader,  "stupidedi/reader/stream_reader"
    autoload :TokenReader,   "stupidedi/reader/token_reader"

    BASIC    = /[A-Z0-9!"&'()*+,.\/:;?= -]/
    EXTENDED = /[a-z%@\[\]_{}\\|<>~^`#\$ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡]/
    EITHER   = Regexp.union(BASIC, EXTENDED)
    BYTES    = (0..255).inject("") {|string, c| string << c }

    class << self
      # Returns non-nil if c belongs to the basic character set
      def is_basic_character?(character)
        character =~ Reader::BASIC
      end

      # Returns non-nil if c belongs to the extended character set
      def is_extended_character?(character)
        character =~ Reader::EXTENDED
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
        character !~ Reader::EITHER
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
        @basic_characters ||= Reader::BYTES.scan(Reader::BASIC)
      end

      # @private
      def extended_characters
        @extended_characters ||= Reader::BYTES.scan(Reader::EXTENDED)
      end

      # @private
      def control_characters
        @control_characters ||= Reader::BYTES.split(//) -
          (basic_characters.join + extended_characters.join).split(//)
      end
    end

  end
end
