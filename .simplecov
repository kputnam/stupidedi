require "base64"
require "simplecov-inline-html"
require "term/ansicolor"

SimpleCov.start do
  coverage_dir "build/coverage"

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

  def file(path)
    if path.end_with?("application.css")
      [super(path), ".src_link { white-space: nowrap; }"].join("\n")
    else
      super(path)
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::SummaryFormatter,
  SimpleCov::Formatter::CustomHtmlFormatter
])
