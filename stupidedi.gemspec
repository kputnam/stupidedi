require File.dirname(__FILE__) + "/lib/stupidedi/version"

Gem::Specification.new do |s|
  s.name        = "stupidedi"
  s.summary     = "Parse, generate, validate ASC X12 EDI"
  s.description = "Ruby API for parsing and generating ASC X12 EDI transactions"
  s.homepage    = "https://github.com/kputnam/stupidedi"

  s.version = Stupidedi::VERSION
  s.date    = "2024-06-24"
  s.authors = ["Kyle Putnam", "Isi Robayna"]
  s.email   = "putnam.kyle@gmail.com"
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
