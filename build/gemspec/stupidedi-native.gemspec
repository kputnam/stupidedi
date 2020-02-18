require_relative "../../lib/stupidedi/version"

Gem::Specification.new do |s|
  # Required attributes
  s.name    = "stupidedi-exts"
  s.summary = "Native extensions to accelerate stupidedi"
  s.authors = ["Kyle Putnam", "Isi Robayna"]
  s.version = Stupidedi::VERSION
  s.files  += [__FILE__]

  # Recommended attributes
  if Gem.win_platform?
    s.platform    = Gem::Platform::CURRENT
    s.files      += Dir[*%w(*.md lib/**/*.dll)]
  else
    s.platform    = Gem::Platform::RUBY
    s.files      += Dir[*%w(*.md native/**/*.{c,h,rb})]
    s.extensions += Dir[*%w(native/**/extconf.rb)]
  end

  s.description = "Ruby API for parsing and generating ASC X12 EDI transactions"
  s.email       = "irobayna@gmail.com"
  s.homepage    = "https://github.com/irobayna/stupidedi"
  s.license     = "BSD-3-Clause"
  s.metadata    = Hash[
    "bug_tracker_uri"   => "https://github.com/irobayna/stupidedi/issues",
    "changelog_uri"     => "https://github.com/irobayna/stupidedi/blob/v#{Stupidedi::VERSION}/CHANGELOG.md",
    "homepage_uri"      => "https://github.com/irobayna/stupidedi",
    "source_code_uri"   => "https://github.com/irobayna/stupidedi",
    "documentation_uri" => "http://rubydoc.info/gems/stupidedi-exts/#{Stupidedi::VERSION}"]

  s.add_runtime_dependency "stupidedi-core", "= #{Stupidedi::VERSION}"

  # Optional attributes
  s.required_ruby_version     = ">= 2.0.0"
  s.required_rubygems_version = ">= 2.5.0"
  s.requirements              # << ""

  # Development dependencies
  s.add_development_dependency "rake-compiler",       "~> 1.0"
  s.add_development_dependency "rake-compiler-dock",  "~> 0.7"
end
