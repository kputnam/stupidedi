require "base64"
require "simplecov-inline-html"
require "term/ansicolor"

SimpleCov.start do
  coverage_dir "build/generated/coverage"

  add_filter %r{/segment_defs}
  add_filter %r{/element_defs}
  add_filter %r{/spec}
  add_filter %r{/transaction_sets/[0-9]+/[A-Z0-9-]+\.rb}
  add_filter %r{/stupidedi/editor}

  add_group "Refinements",      "lib/ruby"
  add_group "Config",           "lib/stupidedi/config"
  add_group "Editor",           "lib/stupidedi/editor"
  add_group "Exceptions",       "lib/stupidedi/exceptions"
  add_group "Interchanges",     "lib/stupidedi/interchanges"
  add_group "Parser",           "lib/stupidedi/parser"
  add_group "Reader",           "lib/stupidedi/reader"
  add_group "Schema",           "lib/stupidedi/schema"
  add_group "TransactionSets",  "lib/stupidedi/transaction_sets"
  add_group "Values",           "lib/stupidedi/values"
  add_group "Versions",         "lib/stupidedi/versions"
  add_group "Writer",           "lib/stupidedi/writer"
  add_group "Zipper",           "lib/stupidedi/zipper"
end

# Based on https://github.com/inossidabile/simplecov-summary/edit/master/lib/simplecov-summary.rb
class SimpleCov::Formatter::SummaryFormatter
  def format(result)
    puts "SimpleCov summary:"
    name_width  = (result.groups.keys + ["SUMMARY"]).map(&:length).max
    count_width = result.groups.values.map(&:missed_lines).max.to_i.to_s.length

    result.groups.sort.each do |name, files|
      print_group(name, files, name_width, count_width)
    end

    print_group("SUMMARY", result.files, name_width, count_width)
  end

  def print_group(name, files, name_width, count_width)
    pct = files.covered_percent
    clr = case pct
          when 90..100 then :green
          when 80..90  then :yellow
          else              :red
          end
    puts Term::ANSIColor.send(clr,
      ("  % #{name_width}s: % 5s%%      " +
       "% #{count_width}s missed lines, " +
       "% #{count_width + 2}s lines total") %
       [name, pct.round(1), files.missed_lines.to_i, files.lines_of_code.to_i])
  end
end

# Don't let the file name in the first column be broken into two lines
class SimpleCov::Formatter::CustomHtmlFormatter < SimpleCov::Formatter::InlineHTMLFormatter
  def output_message(result)
  end

  BORDER = <<-EOF.gsub(/\s/, '')
    iVBORw0KGgoAAAANSUhEUgAAAAEAAABLCAIAAAA+tHrUAAAAUklEQVR4AcXH
    sQ3AIAwFUfuDYADSMQkrMiVdqKGzLDnCRTaIUjzpjnvvodaKtRbM7KWqTkT4
    PBF9Yu+NMQauUvx/Eu45Q0oJOWd3OsbomBmttQc0NiOlCz/4pgAAAABJRU5E
    rkJggg==
  EOF

  CONTROLS = <<-EOF.gsub(/\s/, '')
    iVBORw0KGgoAAAANSUhEUgAAAOEAAABLCAMAAACx6hDAAAABj1BMVEVPT0/e
    3t7b29vS0tK7urq5uLjq6uqZmZmSkpJaWlrU1NTj4+PFxcWvr6+goKBbW1u3
    t7c9PT27u7vCwsKsrKxiYWGqqqq5ublbWlpeXV2Xl5fExMSbmpq6ubmNjY18
    fHzy8vIrKystLS0sLCxNTU0uLi4wMDDNzc05OTns6+vl5eUvLy/q6ekqKipM
    TExDQ0M4ODgyMjI2NjbZ2dk6OjrY2NjMzMxLS0vAwMBCQkLo5+dHR0cxMTFK
    SkpBQUHv7u43NzdISEhFRUVRUVHx8fE7Ozs8PDwzMzNJSUnp6elGRkZQUFDr
    6upeXl7t7e1gYGCoqKjv7+81NTWKiorn5uZERESCgoJdXV3p6OhOTk51dXVA
    QEA+Pj6np6fu7e2+vr5cXFxSUlKJiYnOzs7s7OxTU1P29vbw8PB2dnZfX1/m
    5eV4eHifn59qamqmpqbQ0NCOjo7Kysqzs7P4+PiDg4Otra3z8/M/Pz80NDSr
    q6u/v7/Pz890dHRpaWmBgYH5+fn08/NoaGjPzs7///+ioqIRuwm9AAAGF0lE
    QVR4AcTWd1PDNhQAcH8UDcszdvaOs0lCSNiQsCmjhe7d654fvE+y8QjGXAq+
    vj+iu+enO/0iPdnSwdrx18f/YxzsfDDYkqrNtvp3Ynw1LrWbVWlrcCMdfLaz
    XkSFh/rms1Vs6nFry+jBnEy0/DAWs414dPzxvwphynoRES6HBlpdWQOVh42Y
    9RpetjEsou3QfwQPlnH/yO9XPD78wxs77yMcxMdLQh19vo9Wl7dE+zWUWQUa
    UqECRA6sFE5DRCj/Gs2eC/XvMaUUX33jjejNQi7Zeilc56rwEh1bVozQsr7k
    hCgQ4y4QObCLLSCGy39DlzFCSgihIBTjm4VcJyWFYEaEjT1jQSmOEWJMfzX2
    Qt01AyClRFOHmaGqEZj1C8qEyxfGXuOZkDDGCAjF+Eah8J3Iss2jGg1bhCwD
    EoiBENaaI4zQGCGF/KAS6i69XMCQZCUVqSUGk3ChPIuU9yvDzVSF3Gc7k14z
    Pnq9iWPLnOgL79AuYaZpMiRi2zu2IgjP5y5QcHvC0aRQrYx2Rgo8o3Bggz9E
    lNMLdJeekANtpzc9ytbbsVHPHk17VSD6wo7xAEBFUcz7+XxxfWpkxGH883ox
    n9+LPCPHQXdB9+WIqbR4KCbJQUcGQq/8AXVWhaYnNN9BKDvN75Jm/Fjvu0QQ
    igt/wIHugvmp+0nni6pZVKRFnpFQdwFRM1t5CJighYAgfCofGB810hGKLez9
    kzzl03Z/YnvCJarxQ6fwFbtEXHOFWKS9vDiMhz5R3Wjlx+NxvrWhAjAs9Mtr
    8CAQMk/I3kMoO9MvkqfcnmebjuwK9aKFCQMgrDcfFRIX7uYJtoJezKBHT/gJ
    3KNhYai8rKckhC3M/pw8RS2d9R1Z8vcQKCCJ38M8j5g9VMQDZXUPRdbfw3RO
    6Um1Wb99RZg7P5rYILx56kO/33gf1qJ9KODRPlRL/k2jqdE+9MoHxdT6UDqp
    TtuvCCuFUZY3ohCKuxSIobt0FrlLW/CAfBu5SzWgu2EyLXqXivIU71J+0Tj9
    s9eE+6N6z+ZTEt6HHSRC5LXdyPswRxikNx7hBzY9F34finKym9770BX+sKaQ
    f9NoLOGbRg19pOjFLiYQmopUjUDgbnHlm+bf9u33tWkgjAP4VvUak251/v79
    RCashUBhTGQV1zBtVLoX3dy0s0OmDETfGmhfCv3HzZPlSp7suKPFcL153zfZ
    2BH2IT/unnAPDi9ZuKEQjrtcqF6XrgvXpevJlQuSq4mlwhc/yA8Xr0sTOQrx
    qEU4W23Ry9cWzwq1xSd1baFHSOtDWcGH5VM4rQ/DeepDDULMh7lq/Bfz1vga
    hPq/05Qr1BArtML/UGjfNIO3TDBbeMLZgk1nC4/OFkw8W0yWMZM/2bGjacav
    xYIZP964OOMzJ65kM34l7iNRMhzTnABm+Xd21LRqWwEQCAFuIIECAZCYAgGQ
    mBu+4n9dRGF7n1UBxEJYZWTljcCUGKRAJAb54VW23144If9fxUJwKvnqycOh
    SPQr2U/eHhn+EYeXLHzkS3OrIDzza5BG8EX43FDLV8AcVoWMmquAIU3NPytZ
    ePuKNHepsMP6cB6nmqTPgvRmXMVfHMCQp6vNiVNguyiEvt8pV3j1lzTXckJ8
    4TtA4qZfolwgwaeLEimQCsHxfrQXRDjw3RgUQk45pEQKpEKIXf4H3cKmB6AQ
    8uS/COMzSN+jRIjxmpf+Gh5e7ueQ6X0OFe/SPfPfpf9oPozp7UvnQ73C2dc0
    g9nXNFqF5q9L1UJ9tYUGoaI+dP1Af304u1B/ja9DqOs7TflCDTFCaIVWaIVW
    aIVWaIVWaIVWaIVDlfAgMlTI95eqhPc2oxYKvxkp7OEO2pvyUz8JcY+wsULc
    5+3IT/20MeL7vE0ULj1/vzt8LDvzwzDaxr36xgqTreytk607Pz+f1u9fL6Re
    P31wEkZD7LcwVJjepq9ftUZRY3P87mLGB2EjGh4ll9Bg4RISj3ZGa93uVjHd
    brQ22uFAI4WK1i7s69rFxq7j3htzhfL2vKQ37yU25+ElNFJIWiwxgv7KY95g
    aaaQG3vyHlkEmitEI0bV52yikOe7KnygYcK/0sK5wtrjpuMAAAAASUVORK5C
    YII=
  EOF

  def file(path)
    if path.end_with?("application.css")
      css = super(path)
      css.gsub!("url(colorbox/border.png)", "url(data:image/png;base64,#{BORDER})")
      css.gsub!("url(colorbox/controls.png)", "url(data:image/png;base64,#{CONTROLS})")
      css << <<-EOF
        body       { padding:0 !important; }
        .src_link  { white-space:nowrap; }
        .file_list { font-size: .8rem; }
        .ui-icon   { width:0px !important; height:0px !important; }
        th         { font-size:.7rem; overflow:hidden; white-space:normal !important; }
      EOF
      css
    else
      super(path)
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::SummaryFormatter,
  SimpleCov::Formatter::CustomHtmlFormatter
])
