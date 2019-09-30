# frozen_string_literal: true
# encoding: utf-8

module Stupidedi
  using Refinements

  module Reader
    autoload :Tokenizer,    "stupidedi/reader/tokenizer"
    autoload :SegmentDict,  "stupidedi/reader/segment_dict"
    autoload :Separators,   "stupidedi/reader/separators"
    autoload :Input,        "stupidedi/reader/input"
    autoload :Slice,        "stupidedi/reader/slice"
    autoload :Substring,    "stupidedi/reader/substring"

    if RUBY_PLATFORM !~ /java/
      require "stupidedi/reader/native_ext"
    end

    # RFI 2142 - component elements are not repeatable
    # RFI 0001 - the X12.6 standard prohibits special characters in ID elements
    # RFI 0028 - non-printable chars can be discarded (except delimiters and binary elements)
    # RFI 0650 - control chars can be used for delimeters (element, sub-element etc)
    # RFI 0669 - trading partner agreements lie outside X12 standard, they can do anything
    # RFI 1207 - X12 is a character based standard, references to byte or bytes is incorrect
    # RFI 1815 - none of the four delimeters can be used in data elements
    # RFI 2026 - delimiters cannot appear as data except in binary elements
    # RFI 2205 - space-only values are allowed in ISA02 and ISA04 to meet min length
    # RFI 2207 - delimeters can be CR/LF, trading partner agreements are outside X12 scope
    # RFI 2212 - unless TR3 explicitly states only chars from X12.6, chars are negotiable between patrners
    # RFI 2264 - same as 2212

    # http://members.x12.org/technical-assessment/x12-6-dm-042316.pdf
    # https://en.wikipedia.org/wiki/ISO_8859#Table
    # https://en.wikipedia.org/wiki/EBCDIC#Code_page_layout
    # https://www.reddit.com/r/ruby/comments/5zhinx/ruby_24_has_optimized_lstrip_and_strip_methods/dezarc7/
    # https://blog.bigbinary.com/2017/03/14/ruby-2-4-has-optimized-lstrip-and-strip-methods.html

    # X12.6 3.3 Character Set
    #
    # NOTE: The X12 standards are graphic-character oriented, so any common
    # character encoding schemes may be used as long as a common mapping is
    # available. No collating sequence is to be assumed in any definition used
    # in the standard since no single character code is specified and no other
    # means of specifying a sequence is provided.
    #
    # 3.3.1 Basic Character Set
    #
    #   Uppercase letters A to Z:
    #     "A" ... "Z"
    #
    #   Digits 0 to 9:
    #     "0" ... "9"
    #
    #   Special characters:
    #     "!" """ "&" "'" "(" ")" "*" "+" "," "-" "." "/" ":" ";" "?" "="
    #
    #     NOTE: Special characters are removed from this category when used as
    #     delimiters.
    #
    #   Space character:
    #     " "
    #
    # 3.3.2 Extended Character Set
    #
    #   Lowercase letters from a to z:
    #     "a" ... "z"
    #
    #   Other special characters:
    #     "%" "@" "[" "]" "_" "{" "}" "\" "|" "<" ">" "~" "^" "`"
    #
    #     NOTE: Special characters are removed from this category when used as
    #     delimiters.
    #
    #   National characters:
    #     "#" "$"
    #
    #   Select language characters:
    #     "À" "Á" "Â" "Ä" "à" "á" "â" "ä" "È" "É" "Ê" "è" "é" "ê" "ë"
    #     "Ì" "Í" "Î" "ì" "í" "î" "ï" "Ò" "Ó" "Ô" "Ö" "ò" "ó" "ô" "ö"
    #     "Ù" "Ú" "Û" "Ü" "ù" "ú" "û" "ü" "Ç" "ç" "Ñ" "ñ" "¿" "¡"
    #
    #     NOTE: See ISO document 8859-1 (Latin-1 Alphabet) for an example of an
    #     encoding of select language characters.
    #
    #   Other language characters:
    #     Any graphical character that is specified in any of the following ISO
    #     documents that is not defined in any of the previous BNF productions:
    #
    #     * ISO 646     -- family of 7-bit encodings              NOT SUPPORTED
    #     * ISO 8859-1  -- western european                       ✅
    #     * ISO 8859-2  -- central/eastern european languages     ✅
    #     * ISO 8859-5  -- latin/cyrillic alphabet                ✅
    #     * ISO 8859-7  -- greek                                  ✅
    #     * ISO 8859-3  -- south european                         ✅
    #     * ISO 8859-4  -- north european                         ✅
    #     * ISO 8859-6  -- latin/arabic                           ✅
    #     * ISO 8859-8  -- latin/hebrew                           ✅
    #     * ISO 8859-9  -- turkish                                ✅
    #     * ISO 8859-15 -- western european                       ✅
    #     *[ISO 8859-10]-- nordic                                 ✅
    #     *[ISO 8859-11]-- thai                                   ✅
    #     *[ISO 8859-12]-- devanagari                             NOT SUPPORTED
    #     *[ISO 8859-13]-- baltic rim                             ✅
    #     *[ISO 8859-14]-- celtic                                 ✅
    #     *[ISO 8859-15]--                                        ✅
    #     *[ISO 8859-16]--                                        ✅
    #     * ISO 2022:JP -- stateful variable width encoding       ✅
    #     * ISO 2022:JP2-- stateful variable width encoding       ✅
    #     * ISO 2375    --                                        NOT SUPPORTED
    #     * ISO 10646   -- unicode                                ✅
    #
    # X12.5 3 Control Characters
    #
    # Two control character groups are specified which have only restricted
    # usage. The common notation for these is also provided, together with the
    # character coding in three common alphabets represented by their
    # hexadecimal values. In the following table IA5 represents CCITT V.3
    # International Alphabet 5.
    #
    # 3.1 Terminal Control Set
    #
    #   The terminal control set includes characters used to control terminal
    #   display characteristics. Thesecharacters usually will not have an effect
    #   on a transmission system. These are presented by the syntacticentity of
    #   <term_control_char>.
    #
    #         EBCDIC  ASCII   IA5
    #   BEL   0x2f    0x07    0x07
    #   HT    0x05    0x09    0x09
    #   LF    0x25    0x0a    0x0a
    #   VT    0x0b    0x0b    0x0b
    #   FF    0x0c    0x0c    0x0c
    #   CR    0x0d    0x0d    0x0d
    #   NL    0x15    NOTE    ----
    #   FS    0x1c    0x1c    0x1c
    #   GS    0x1d    0x1d    0x1d
    #   RS    0x1e    0x1e    0x1e
    #   US    0x1f    0x1f    0x1f
    #
    #   NOTE: The equivalent representation for the EBCDIC "new line" character
    #   is the character pair "carriage return" "line feed" in ASCII or IA5. If
    #   mapped in this manner, the superfluous “line feed” is ignored, and the
    #   "carriage return" is treated as the delimiter. For historical reasons,
    #   many systems support this mapping for use as the <segment_terminator>.
    #
    # 3.2 Communication Control Set
    #
    #   The communication control set includes those that may have an effect on
    #   a transmission system. Theseare represented by the syntactic entity of
    #   <comm_control_char>.
    #
    #         EBCDIC  ASCII   IA5
    #   GS    0x1d    0x1d    0x1d
    #   RS    0x1e    0x1e    0x1e
    #   US    0x1f    0x1f    0x1f
    #   SOH   0x01    0x01    0x01
    #   STX   0x02    0x02    0x02
    #   ETX   0x03    0x03    0x03
    #   EOT   0x37    0x04    0x04
    #   ENQ   0x2d    0x05    0x05
    #   ACK   0x2e    0x06    0x06
    #   DC1   0x11    0x11    0x11
    #   DC2   0x12    0x12    0x12
    #   DC3   0x13    0x13    0x13
    #   DC4   0x3c    0x14    0x14
    #   NAK   0x3d    0x15    0x15
    #   SYN   0x32    0x16    0x16
    #   ETB   0x25    0x17    0x17

    # Delimiters are specified in the interchange header segment, ISA.The ISA
    # segment canbe considered in implementations compliant with this guide (see
    # Appendix C, ISASegment Note 1) to be a 105 byte fixed length segment,
    # followed by a segment terminator.The data element separator is byte number
    # 4; the repetition separator is byte number83; the component element
    # separator is byte number 105; and the segment terminatoris the byte that
    # immediately follows the component element separator
    #
    # Once specified in the interchange header, the delimiters are not to be
    # used in a dataelement value elsewhere in the interchange. For consistency,
    # this implementation guideuses the delimiters shown in Table B.5 -
    # Delimiters, in all examples of EDI transmissions.

    # 3.5.1.1 Numeric
    #
    #   <numeric> ::= [-] <unsigned_integer>
    #   <unsigned_integer> ::= <digit> {<digit>}
    #
    # 3.5.1.2 Decimal Number
    #
    #   <decimal_number> ::= [-] <unsigned_decimal_number> [<base_10_exponential>]
    #   <base_10_exponential> ::= E <exponent>
    #   <exponent> ::= [-] <unsigned_integer>
    #   <unsigned_decimal_number> ::= <unsigned_integer> | .<unsigned_integer> | <unsigned_integer> . {<digit>}
    #
    # 3.5.1.3 Identifier
    #
    #   <id> ::= <letter_or_digit> {<letter_or_digit>} {<space>}
    #   <letter_or_digit> ::= <uppercase_letter> | <digit>
    #
    # 3.5.1.4 String
    #
    #   <string> ::= {<non_space_char> | <space>} <non_space_char> {<non_space_char> |<space>}
    #   <non_space_char> ::= <uppercase_letter> | <digit> | <special_char> | <lowercase_letter> | <other_special_char> | <national_char> |<select_language_character>
    #
    # 3.5.1.5 Date
    #
    #   <date> ::= <year> <month> <day> | <hundred_year> <year> <month> <day>
    #   <hundred_year> ::= <digit> <digit>
    #   <year> ::= <digit> <digit>
    #   <month> ::= "01" | "02" | ... | "12"
    #   <day> ::= "01" | "02" | ... | "31"
    #
    # 3.5.1.6 Time
    #
    #   <time> ::= <hour> <minute> [<seconds>]
    #   <hour> ::= "00" | "01" | "02" | ... | "23"
    #   <minute> ::= "00" | "01" | "02" | ... | "59"
    #   <seconds> ::= <integer_seconds> [<decimal_seconds>]
    #   <integer_seconds> ::= "00" | ... | "59"
    #   <decimal_seconds> ::= <digit> {<digit>}
    #
    # 3.5.1.7 Binary
    #
    #   <binary> ::= <octet> {<octet>}
    #   <octet> ::= "000000002" | ... | "111111112"

    class << self
      # @group Constructors
      #########################################################################

      # @param  [String or Pathname or IO] input
      # @return [Tokenizer]
      def build(input, *args)
        if args.last.is_a?(Hash)
          keywords = {}
          keywords[:config] = args.last.delete(:config) if args.last.include?(:config)
          keywords[:strict] = args.last.delete(:config) if args.last.include?(:strict)
        else
          keywords = {}
        end

        Tokenizer.build(Input.build(input, *args), *keywords)
      end


      # @param  [String or Pathname or IO] path
      # @return [Tokenizer]
      def file(path, *args)
        if path.is_a?(String)
          build(Pathname.new(path), *args)
        else
          build(input, *args)
        end
      end

      # @endgroup
      #########################################################################
    end
  end
end
