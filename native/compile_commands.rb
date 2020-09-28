#!/usr/bin/env ruby
require "rbconfig"
require "json"

state = JSON::Ext::Generator::State.new(
  space: " ",
  indent: "  ",
  array_nl: "\n",
  object_nl: "\n")

cflags = "#{ENV["CFLAGS"]} -Wall -Wno-deprecated-register -std=c99"
iquote = [RbConfig::CONFIG["rubyhdrdir"],
          RbConfig::CONFIG["rubyarchhdrdir"]].map{|x| "-I#{x}"}.join(" ")

i      = [File.expand_path(File.dirname(__FILE__))].map{|x| "-I#{x}"}.join(" ")

puts(Dir[File.join(File.dirname(__FILE__), "**/*.{c,h}")].map do |c|
  # next if c.split("/").include?("test")
  {file: File.expand_path(c),
   directory: File.dirname(File.expand_path(c)),
   command: "gcc #{cflags} #{i} #{iquote} -c #{c} -o #{c}.o"}
end.compact.to_json(state))
