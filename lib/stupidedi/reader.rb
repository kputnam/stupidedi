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

    # Returns non-nil if c belongs to the basic character set
    def self.is_basic_character?(c)
      c =~ BASIC
    end

    # Returns non-nil if c belongs to the extended character set
    def self.is_extended_character?(c)
      c =~ EXTENDED
    end

    # Returns non-nil if c does not belong to the extended or basic character set.
    # NOTE: This does not match the specification of control characters given in X12.5,
    # but I haven't seen the actual usage of control characters. So for our purposes,
    # they basically are characters that we want to ignore.
    def self.is_control_character?(c)
      c !~ EITHER
    end

    # Strips control characters from the string, leaving only basic and extended characters
    def self.strip(string)
      string.scan(EITHER).join
    end

    def self.basic_characters
      @basic_characters ||= BYTES.scan(BASIC)
    end

    def self.extended_characters
      @extended_characters ||= BYTES.scan(EXTENDED)
    end

    def self.control_characters
      @control_characters ||= BYTES.split(//) - (basic_characters.join + extended_characters.join).split(//)
    end

  end
end
