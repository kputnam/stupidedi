# frozen_string_literal: true
module Stupidedi
  module Refinements
    refine Exception do
      def print(name: nil, io: $stderr)
        ansi = Stupidedi::Color.ansi
        io.puts "warning: #{ansi.red("#{self.class} #{message}")}"
        io.puts " module: #{name}" unless name.nil?
        io.puts backtrace.map{|x| "  " + x}.join("\n")
        io.puts
      end
    end
  end
end
