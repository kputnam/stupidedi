require File.dirname(__FILE__) + "/lib/stupidedi/version"

if `git describe --tags 2>/dev/null`.strip.empty?
  describe = 'v0.0.0'
else
  describe = `git describe --tags`.strip
end

Gem::Specification.new do |s|
  s.name        = "stupidedi"
  s.summary     = "Parse, generate, validate ASC X12 EDI"
  s.description = "Ruby API for parsing and generating ASC X12 EDI transactions"
  s.homepage    = "https://github.com/kputnam/stupidedi"

  s.version = if not describe.match?(/^v?\d+\.\d+\.\d+-\d+-g[0-9a-f]+$/)
    describe.sub(/^v/, '')
  else
    # "v1.2.3-4-gabcdef7" => "1.2.3.4.gabcdef7"
    describe.sub(/^v/, '').gsub('-', '.')
  end

  s.authors = ["Kyle Putnam"]
  s.email   = "putnam.kyle@gmail.com"
  s.license = "BSD-3-Clause"

  s.files             = ["README.md", "Rakefile",
                         "bin/*",
                         "lib/**/*",
                         "doc/**/*.md"].map {|glob| Dir[glob] }.flatten
  s.bindir            = "bin"
  s.executables       = ["edi-pp", "edi-ed"]
  s.require_path      = "lib"

  s.required_ruby_version = ">= 3.2"
  s.add_dependency "cantor",         "~> 1.2.1"
  s.add_dependency "bigdecimal"
  s.add_dependency "ostruct"
  s.add_dependency "base64"
end
