# encoding: utf-8
require "http"
require "pp"

class CodeGenTask
  def execute
  end

  def download
    # https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt
    # https://www.unicode.org/Public/UCD/latest/ucd/extracted/DerivedGeneralCategory.txt
  end

  # PropList.txt
  def load_properties(path)
    properties = Hash.new{|h,k| h[k] = []}

    File.open(path, encoding: "utf-8") do |io|
      io.each_line do |line|
        next if line =~ /^#/
        next if line !~ /\S/

        code_range = line[/^[^ ;]+/].split("..").map{|x|Integer(x, 16)}
        property   = line[/(?<=; )[^#]+/].strip
        properties[property] << code_range
      end
    end

    properties
  end

  # DerivedGeneralCategory.txt
  def load_categories(path)
    categories = Hash.new{|h,k| h[k] = []}

    File.open(path, encoding: "utf-8") do |io|
      io.each_line do |line|
        next if line =~ /^#/
        next if line !~ /\S/

        code_range = line[/^[^ ;]+/].split("..").map{|x|Integer(x, 16)}
        category   = line[/(?<=; )[^#]+/].strip
        code_count = line[/(?<=\[)[^\]]+(?=\])/]

        key =
          case category
          when *%w(Cc Cf Cn Co Cs C&)       then :c # control
          when *%w(Ll Lm Lo Lt Lu L&)       then :l # letter
          when *%w(Mc Me Mn M&)             then :m # mark
          when *%w(Nd Nl No N&)             then :n # number
          when *%w(Pc Pd Pe Pf Pi Po Ps P&) then :p # punctuation
          when *%w(Sc Sk Sm So S&)          then :s # symbol
          when *%w(Zl Zp Zs Z&)             then :z # whitespace
          end

        categories[category]  << code_range
        categories[key]       << code_range
      end
    end

    categories
  end

  def unicode_graphic_codepoints(properties, categories)
    items = []

    [:l,:m,:n,:p,:s,:z].each{|k| items.concat(categories[k]) }
    #"White_Space" ].each{|k| items.concat(properties[k]) }

    intervals(items)
  end

  def unicode_whitespace_codepoints(properties)
    intervals(properties["White_Space"])
  end

  def ascii_graphic_codepoints
    [*0x20..0x7e]
  end

  def ascii_whitespace_codepoints
    [*0x09..0x0d, 0x32]
  end

  def iso_8859_graphic_codepoints
    undefined =
      {0xa0 => [ ], 0xa1 => [   6, 8], 0xa2 => [   6   ], 0xa3 => [6],
       0xa4 => [ ], 0xa5 => [3, 6   ], 0xa6 => [   6   ], 0xa7 => [6],
       0xa8 => [6], 0xa9 => [   6   ], 0xaa => [   6   ], 0xab => [6],
       0xac => [ ], 0xad => [       ], 0xae => [3, 6, 7], 0xaf => [6],

       0xb0 => [6], 0xb1 => [6], 0xb2 => [   6], 0xb3 => [6   ],
       0xb4 => [6], 0xb5 => [6], 0xb6 => [   6], 0xb7 => [6   ],
       0xb8 => [6], 0xb9 => [6], 0xba => [   6], 0xbb => [    ],
       0xbc => [6], 0xbd => [6], 0xbe => [3, 6], 0xbf => [   8],

       0xc0 => [6, 8], 0xc1 => [8], 0xc2 => [8], 0xc3 => [3, 8],
       0xc4 => [   8], 0xc5 => [8], 0xc6 => [8], 0xc7 => [   8],
       0xc8 => [   8], 0xc9 => [8], 0xca => [8], 0xcb => [   8],
       0xcc => [   8], 0xcd => [8], 0xce => [8], 0xcf => [   8],

       0xd0 => [3,    8    ], 0xd1 => [   8    ], 0xd2 => [   7, 8    ], 0xd3 => [   8    ],
       0xd4 => [      8    ], 0xd5 => [   8    ], 0xd6 => [      8    ], 0xd7 => [   8    ],
       0xd8 => [      8    ], 0xd9 => [   8    ], 0xda => [      8    ], 0xdb => [6, 8, 11],
       0xdc => [   6, 8, 11], 0xdd => [6, 8, 11], 0xde => [6,    8, 11], 0xdf => [6       ],

       0xe0 => [ ], 0xe1 => [ ], 0xe2 => [ ], 0xe3 => [3],
       0xe4 => [ ], 0xe5 => [ ], 0xe6 => [ ], 0xe7 => [ ],
       0xe8 => [ ], 0xe9 => [ ], 0xea => [ ], 0xeb => [ ],
       0xec => [ ], 0xed => [ ], 0xee => [ ], 0xef => [ ],

       0xf0 => [3          ], 0xf1 => [     ], 0xf2 => [     ], 0xf3 => [6          ],
       0xf4 => [   6       ], 0xf5 => [6    ], 0xf6 => [6    ], 0xf7 => [6          ],
       0xf8 => [   6       ], 0xf9 => [6    ], 0xfa => [6    ], 0xfb => [6,    8    ],
       0xfc => [   6, 8, 11], 0xfd => [6, 11], 0xfe => [6, 11], 0xff => [6, 7, 8, 11]}

    width = ((0xff - 0xa0) / 8.0).ceil

    (1..16).map do |n|
      offset  = undefined.keys.min
      graphic = undefined.reject{|_,v| v.include?(n) or n == 12 }.keys
      bitmap  = graphic.inject(0){|b,k| b | (1 << (k-offset)) }
      width.times.to_a.reverse.map{|n| b = (bitmap >> 8*n) & 0xff }
    end
  end

  def iso_8859_whitespace_codepoints
    [*0x09..0x0d, 0x32, 0xa0]
  end

  private

  def intervals(items)
    state = OpenStruct.new(current: nil, items: [])
    items.sort.each do |range|
      a, b = range
      b  ||= a
      raise "invalid code point range: %s" % fmt(a, b) if a > b

      if state.current.nil?
        state.current = a..b
      elsif b < state.current.max
        if a >= state.current.min
          #warn "ignoring redudant subset %s within %s" % [fmt(a, b), fmt(state.current)]
        else
          #warn "merging %s and %s" % [fmt(state.current), fmt(a, b)]
          state.current = a..state.current.max
        end
      elsif a <= state.current.max + 1
        #warn "merging %s and %s" % [fmt(state.current), fmt(a, b)]
        state.current = state.current.min..b
      else
        state.items  << state.current
        state.current = a..b
      end
    end

    state.items << state.current
    state.items
  end

  def fmt(a, b=nil)
    case a
    when Range
      if a.min == a.max
        "%04x" % a.min
      else
        "%04x..%04x" % [a.min, a.max]
      end
    else
      if b.nil? or a == b
        "%04x" % a
      else
        "%04x..%04x" % [a, b]
      end
    end
  end
end

t = CodeGenTask.new
p = t.load_properties("data/PropList.txt")
c = t.load_categories("data/DerivedGeneralCategory.txt")

puts "/* Bitmap indicating ISO-8859-x graphic characters starting from 0xa0..0xff */"
puts "unsigned char iso_8859_graphic[16][12] = {"
  t.iso_8859_graphic_codepoints.each_with_index do |bs, n|
    puts "    {%s}, // iso-8859-%d" % [bs.map{|c|"0x%02x"%c}.join(","), n+1]
  end
puts "};"
puts

g = t.unicode_graphic_codepoints(p, c)
puts "/* List of intervals of indicating graphic Unicode codepoints */"
puts "unsigned int ucs_codepoints_graphic_count = %d;" % g.size
puts "unsigned int ucs_codepoints_graphic_min[] = {%s};" % g.map{|c|"0x%02x" % c.min}.join(",")
puts "unsigned int ucs_codepoints_graphic_max[] = {%s};" % g.map{|c|"0x%02x" % c.max}.join(",")
puts

w = t.unicode_whitespace_codepoints(p)
puts "/* List of intervals of indicating whitespace Unicode codepoints */"
puts "unsigned int ucs_codepoints_whitespace_count = %d;" % w.size
puts "unsigned int ucs_codepoints_whitespace_min[] = {%s};" % w.map{|c|"0x%02x" % c.min}.join(",")
puts "unsigned int ucs_codepoints_whitespace_max[] = {%s};" % w.map{|c|"0x%02x" % c.max}.join(",")
