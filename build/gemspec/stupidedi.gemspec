require_relative "../../lib/stupidedi/version"

Gem::Specification.new do |s|
  # Required attributes
  s.name    = "stupidedi"
  s.summary = "Parse, generate, validate ASC X12 EDI"
  s.authors = ["Kyle Putnam", "Isi Robayna"]
  s.version = Stupidedi::VERSION
  s.files   = Dir[*%w(*.md)]
  s.files  += [__FILE__]

  # Recommended attributes
  s.platform    = Gem::Platform::RUBY
  s.description = "Ruby API for parsing and generating ASC X12 EDI transactions"
  s.email       = "irobayna@gmail.com"
  s.homepage    = "https://github.com/irobayna/stupidedi"
  s.license     = "BSD-3-Clause"
  s.metadata    = Hash[
    "bug_tracker_uri"   => "https://github.com/irobayna/stupidedi/issues",
    "changelog_uri"     => "https://github.com/irobayna/stupidedi/blob/v#{Stupidedi::VERSION}/CHANGELOG.md",
    "homepage_uri"      => "https://github.com/irobayna/stupidedi",
    "source_code_uri"   => "https://github.com/irobayna/stupidedi",
    "documentation_uri" => "http://rubydoc.info/gems/stupidedi-core/#{Stupidedi::VERSION}"]

  s.add_runtime_dependency "stupidedi-core", "= #{Stupidedi::VERSION}"
  s.add_runtime_dependency "stupidedi-defs", "= #{Stupidedi::VERSION}"

  # Optional attributes
  s.required_ruby_version     = ">= 2.0.0"
  s.required_rubygems_version = ">= 2.5.0"
  s.requirements              # << ""
end
