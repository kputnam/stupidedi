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
end if defined? SimpleCov
