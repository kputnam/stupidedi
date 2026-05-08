require File.dirname(__FILE__) + "/lib/stupidedi/version"

Gem::Specification.new do |s|
  s.name        = "tediparse"
  s.summary     = "Parse, generate, validate ASC X12 EDI"
  s.description = "A fork of stupidedi by Kyle Putnam. A parser and generator for X12 EDI documents. X12 content is not included — users must supply their own licensed X12 data."
  s.homepage    = "https://github.com/Tediware/tediparse"

  s.version = Stupidedi::VERSION
  s.date    = "2024-06-24"
  s.authors = ["Kyle Putnam", "Isi Robayna", "Adrian Duyzer"]
  s.email   = "adrian@tediware.com"
  s.license = "BSD-3-Clause"

  s.files             = ["README.md", "Rakefile",
                         "bin/*",
                         "lib/**/*",
                         "doc/**/*.md"].map {|glob| Dir[glob] }.flatten
  s.bindir            = "bin"
  s.executables       = ["edi-pp", "edi-ed"]
  s.require_path      = "lib"

  s.add_dependency "term-ansicolor", "~> 1.3"
  s.add_dependency "cantor",         "~> 1.2.1"
  # s.metadata["yard.run"] = "yard doc"
end
