# frozen_string_literal: true
# encoding: ISO-8859-1
module Stupidedi
  using Refinements

  if RUBY_PLATFORM !~ /java/
    require "stupidedi/reader/native_ext"
  end

  module Reader
    autoload :Separators,   "stupidedi/reader/separators"
    autoload :SegmentDict,  "stupidedi/reader/segment_dict"

    autoload :IgnoredTok,           "stupidedi/reader/tokens/ignored_tok"
    autoload :SegmentTok,           "stupidedi/reader/tokens/segment_tok"
    autoload :SimpleElementTok,     "stupidedi/reader/tokens/simple_element_tok"
    autoload :ComponentElementTok,  "stupidedi/reader/tokens/component_element_tok"
    autoload :CompositeElementTok,  "stupidedi/reader/tokens/composite_element_tok"
    autoload :RepeatedElementTok,   "stupidedi/reader/tokens/repeated_element_tok"

    autoload :Input,              "stupidedi/reader/input"
    autoload :Position,           "stupidedi/reader/position"
    autoload :NoPosition,         "stupidedi/reader/position/no_position"
    autoload :OffsetPosition,     "stupidedi/reader/position/offset_position"
    autoload :StacktracePosition, "stupidedi/reader/position/stacktrace_position"

    autoload :Tokenizer,    "stupidedi/reader/tokenizer"
    autoload :Pointer,      "stupidedi/reader/pointer"
    autoload :ArrayPtr,     "stupidedi/reader/pointer"
    autoload :StringPtr,    "stupidedi/reader/pointer"

    # @private
    # @return [Regexp]
    R_BASIC    = /[A-Z0-9!"&'()*+,.\/:;?= -]/.freeze

    # @private
    # @return [Regexp]
    R_EXTENDED = /[a-z%@\[\]_{}\\|<>~^`#\$ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡]/.freeze

    # @private
    # @return [Regexp]
    R_EITHER   = Regexp.union(R_BASIC, R_EXTENDED)

    # @private
    # @return [String]
    C_BYTES    = (0..255).inject(""){|string, c| string + [c].pack('U') }.freeze

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
      def build(input, position = NoPosition)
        Tokenizer.build(Input.build(input, position))
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

      unless Reader.respond_to?(:is_control_character_at?)
        # @private
        # @see X222.pdf B.1.1.2.2 Extended Characters
        def is_control_character_at?(string, offset)
          is_control_character?(string[offset])
        end
      end

      unless Reader.respond_to?(:lstrip_control_characters_offset)
        def lstrip_control_characters_offset(string, offset)
          while string.defined_at?(offset)
            break offset unless is_control_character_at?(string, offset)
            offset += 1
          end
        end
      end

      unless Reader.respond_to?(:substr_eql?)
        # @private
        def substr_eql?(s1, n1, s2, n2, length)
          if s1.length >= n1 + length and s2.length >= n2 + length
            s1 = s1[n1, length] unless n1.zero? and length == s1.length
            s2 = s2[n2, length] unless n2.zero? and length == s2.length
            s1 == s2
          end
        end
      end

      if R_EXTENDED.respond_to?(:match?)
        # @private
        def has_extended_characters?(string)
          R_EXTENDED.match?(string)
        end
      else
        # @private
        def has_extended_characters?(string)
          R_EXTENDED.match?(string)
        end
      end

      # @private
      def has_control_characters?(string)
        #_CONTROL.match?(string)
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
