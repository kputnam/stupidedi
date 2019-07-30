require_relative "../../lib/stupidedi/version"

Gem::Specification.new do |s|
  # Required attributes
  s.name    = "stupidedi-core"
  s.summary = "Parse, generate, validate ASC X12 EDI"
  s.authors = ["Kyle Putnam", "Isi Robayna"]
  s.version = Stupidedi::VERSION
  s.files   = Dir[*%w(*.md lib/**/*.rb)]
  s.files  += [__FILE__]
  s.files.reject!{|x| x =~ %r(lib/stupidedi/versions/\d) }
  s.files.reject!{|x| x =~ %r(lib/stupidedi/interchanges/\d) }
  s.files.reject!{|x| x =~ %r(lib/stupidedi/transaction_sets/\d) }
  s.files.reject!{|x| x =~ %r(lib/stupidedi/functional_groups/\d) }

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

  s.add_runtime_dependency "cantor",         "~> 1.2"
  s.add_runtime_dependency "term-ansicolor", "~> 1.3"

  # Optional attributes
  s.executables               = %w(edi-pp edi-ed edi-obfuscate)
  s.required_ruby_version     = ">= 2.0.0"
  s.required_rubygems_version = ">= 2.5.0"
  s.requirements              # << ""

  # Development dependencies
  s.add_development_dependency "irb"#                       "~> 1.0"
  s.add_development_dependency "rake",                      "~> 12.3"
  s.add_development_dependency "rspec",                     "~> 3.8"
  s.add_development_dependency "rspec-collection_matchers"# " "
  s.add_development_dependency "simplecov"#                 ""
  s.add_development_dependency "simplecov-inline-html"#     ""        # requires ruby 2.4+
  s.add_development_dependency "stackprof",                 "~> 0.2"
  s.add_development_dependency "benchmark-ips"#             ""
  s.add_development_dependency "memory_profiler"#           ""        # requires ruby 2.3+
end
