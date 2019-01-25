require "base64"
require "simplecov-inline-html"
require "term/ansicolor"

SimpleCov.start do
  coverage_dir "build/coverage"

  add_filter %r{/segment_defs}
  add_filter %r{/element_defs}
  add_filter %r{/spec}
  add_filter %r{/transaction_sets/[0-9]+/[A-Z0-9-]+\.rb}

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
    width = (result.groups.keys + ["Total"]).map(&:length).max
    result.groups.sort.each do |name, files|
      pct = files.covered_percent.round(2)
      clr = case pct
            when 90..100 then :green
            when 80..90  then :yellow
            else              :red
            end
      puts Term::ANSIColor.send(clr, "#{name.rjust(width)}: #{pct}%")
    end
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::SummaryFormatter,
  SimpleCov::Formatter::InlineHTMLFormatter
])
