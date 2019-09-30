# frozen_string_literal: true
# encoding: utf-8
describe Stupidedi::Reader::NativeExt do
  using Stupidedi::Refinements
  include ReaderExtMatchers

  # These are all UTF-8, due to the pragma at the top of the file
  let(:basic_letters)   { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
  let(:basic_digits)    { "0123456789" }
  let(:basic_symbols)   { " !\"&'()*+,-./:;?=" }
  let(:basic_control)   { [0x07, *0x09..0x0d, *0x1c..0x1f].map(&:chr).join }

  let(:extend_letters)  { "abcdefghijklmnopqrstuvwxyz" }
  let(:extend_symbols)  { "%@[]_{}\\|<>~^`$#" }
  let(:extend_control)  { [*0x01..0x06, *0x11..0x17].map(&:chr).join }
  let(:extend_language) { "ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡Øø" }

  let(:whitespace)      { "\t\n\v\f\r " }

  # Lists which ISO-8859-x do not define each char. Charcters from 0x00 to 0x7f
  # are defined in US-ASCII. Characters from 0x80 to 0x9f are defined as
  # non-graphical chars in all ISO-8859-x encodings.
  let(:iso_8859_table) do
    {0xa0 => [          ],
     0xa1 => [   6,    8],
     0xa2 => [   6      ],
     0xa3 => [   6      ],
     0xa4 => [          ],
     0xa5 => [3, 6      ],
     0xa6 => [   6      ],
     0xa7 => [   6      ],
     0xa8 => [   6      ],
     0xa9 => [   6      ],
     0xaa => [   6      ],
     0xab => [   6      ],
     0xac => [          ],
     0xad => [          ],
     0xae => [3, 6, 7   ],
     0xaf => [   6      ],

     0xb0 => [   6   ],
     0xb1 => [   6   ],
     0xb2 => [   6   ],
     0xb3 => [   6   ],
     0xb4 => [   6   ],
     0xb5 => [   6   ],
     0xb6 => [   6   ],
     0xb7 => [   6   ],
     0xb8 => [   6   ],
     0xb9 => [   6   ],
     0xba => [   6   ],
     0xbb => [       ],
     0xbc => [   6   ],
     0xbd => [   6   ],
     0xbe => [3, 6   ],
     0xbf => [      8],

     0xc0 => [   6, 8],
     0xc1 => [      8],
     0xc2 => [      8],
     0xc3 => [3,    8],
     0xc4 => [      8],
     0xc5 => [      8],
     0xc6 => [      8],
     0xc7 => [      8],
     0xc8 => [      8],
     0xc9 => [      8],
     0xca => [      8],
     0xcb => [      8],
     0xcc => [      8],
     0xcd => [      8],
     0xce => [      8],
     0xcf => [      8],

     0xd0 => [3,       8    ],
     0xd1 => [         8    ],
     0xd2 => [      7, 8    ],
     0xd3 => [         8    ],
     0xd4 => [         8    ],
     0xd5 => [         8    ],
     0xd6 => [         8    ],
     0xd7 => [         8    ],
     0xd8 => [         8    ],
     0xd9 => [         8    ],
     0xda => [         8    ],
     0xdb => [   6,    8, 11],
     0xdc => [   6,    8, 11],
     0xdd => [   6,    8, 11],
     0xde => [   6,    8, 11],
     0xdf => [   6          ],

     0xe0 => [ ],
     0xe1 => [ ],
     0xe2 => [ ],
     0xe3 => [3],
     0xe4 => [ ],
     0xe5 => [ ],
     0xe6 => [ ],
     0xe7 => [ ],
     0xe8 => [ ],
     0xe9 => [ ],
     0xea => [ ],
     0xeb => [ ],
     0xec => [ ],
     0xed => [ ],
     0xee => [ ],
     0xef => [ ],

     0xf0 => [3             ],
     0xf1 => [              ],
     0xf2 => [              ],
     0xf3 => [   6          ],
     0xf4 => [   6          ],
     0xf5 => [   6          ],
     0xf6 => [   6          ],
     0xf7 => [   6          ],
     0xf8 => [   6          ],
     0xf9 => [   6          ],
     0xfa => [   6          ],
     0xfb => [   6,    8    ],
     0xfc => [   6,    8, 11],
     0xfd => [   6,       11],
     0xfe => [   6,       11],
     0xff => [   6, 7, 8, 11]}
  end

  # encodings = %w(us-ascii ascii-8bit iso-8859-1 iso-8859-2 iso-8859-3 iso-8859-4
  # iso-8859-5 iso-8859-6 iso-8859-7 iso-8859-8 iso-8859-9 iso-8859-10 iso-8859-11
  # iso-8859-13 iso-8859-14 iso-8859-15 iso-8859-16 ibm437 koi8-r koi8-u shift_jis
  # windows-1250 windows-1251 windows-1252 windows-1253 windows-1254 windows-1255
  # windows-1256 windows-1257 utf-8 utf-16be utf-16le utf-32be utf-32le)

  encodings = %w(us-ascii iso-8859-1 iso-8859-2 iso-8859-3 iso-8859-4 iso-8859-5
  iso-8859-6 iso-8859-7 iso-8859-8 iso-8859-9 iso-8859-10 iso-8859-11
  iso-8859-13 iso-8859-14 iso-8859-15 iso-8859-16 utf-8)

  describe ".graphic?" do
    encodings.each do |e|
      context "when encoding is #{e}" do
        it "identifies basic uppercase letters" do
          expect(basic_letters).to be_graphic(encoding: e)
        end

        it "identifies basic digits" do
          expect(basic_digits).to be_graphic(encoding: e)
        end

        it "identifies basic symbols" do
          expect(basic_symbols).to be_graphic(encoding: e)
        end

        it "excludes basic control characters" do
          expect(basic_control).to_not be_graphic(encoding: e)
        end

        it "identifies extended lowercase letters" do
          expect(extend_letters).to be_graphic(encoding: e)
        end

        it "identifies extended symbols" do
          expect(extend_symbols).to be_graphic(encoding: e)
        end

        it "excludes extended control characters" do
          expect(extend_control).to_not be_graphic(encoding: e)
        end

        it "identifies extended language characters" do
          expect(extend_language).to be_graphic(encoding: e)
        end

        if n = e[/iso-8859-(\d+)/, 1].try{|m| Integer(m) }
          it "identifies all graphic characters" do
            bytes  = iso_8859_table.reject{|_, no| no.include?(n) }.keys
            string = bytes.sort.map(&:chr).join.force_encoding(e)
            expect(string).to be_graphic
          end

          it "excludes all non-graphic characters" do
            bytes  = iso_8859_table.select{|_, no| no.include?(n) }.keys
            string = bytes.sort.map(&:chr).join.force_encoding(e)
            expect(string).to_not be_graphic
          end
        end
      end
    end
  end

  fdescribe ".whitespace?" do
    encodings.each do |e|
      context "when encoding is #{e}" do
        it "identifies whitespace characters" do
          expect(whitespace).to be_whitespace(encoding: e)
        end

        it "excludes basic uppercase letters" do
          expect(basic_letters).to_not be_whitespace(encoding: e)
        end

        it "excludes basic digits" do
          expect(basic_digits).to_not be_whitespace(encoding: e)
        end

        it "excludes basic symbols" do
          expect(basic_symbols.chars.reject{|c| c == " " }.join).to_not be_whitespace(encoding: e)
        end

        it "excludes basic control characters" do
          expect(basic_control.chars.reject{|c| "\t" <= c and c <= "\r"}.join).to_not be_whitespace(encoding: e)
        end

        it "excludes extended lowercase letters" do
          expect(extend_letters).to_not be_whitespace(encoding: e)
        end

        it "excludes extended symbols" do
          expect(extend_symbols).to_not be_whitespace(encoding: e)
        end

        it "excludes extended control characters" do
          expect(extend_control).to_not be_whitespace(encoding: e)
        end

        it "excludes extended language characters" do
          expect(extend_language).to_not be_whitespace(encoding: e)
        end

        if n = e[/iso-8859-(\d+)/, 1].try{|m| Integer(m) }
          it "excludes all extended characters (except 0xa0)" do
            bytes  = 0xa1..0xff
            string = bytes.map(&:chr).join.force_encoding(e)
            expect(string).to_not be_whitespace
          end
        end
      end
    end
  end

  todo ".min_graphic_index"
  todo ".min_nongraphic_index"
  todo ".min_nonspace_index"
  todo ".max_nonspace_index"
end
