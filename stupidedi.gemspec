# NOTE: This gemspec is not used for packaging, it's only to satisfy bundler's
# requirement for a *.gemspec when someone adds "gem 'stupidedi', git: ..." or
# "gem 'stupidedi', path: ..." or "gem 'stupidedi', github: ...".
#
# The actual published gem(s) are built from build/gemspec/*
#
Gem::Specification.new do |s|
  # Required attributes
  s.name    = "stupidedi"
  s.version = "0.0.0-rc"
  s.summary = "Parse, generate, validate ASC X12 EDI"
  s.authors = ["Kyle Putnam", "Isi Robayna"]

  s.files       = Dir[*%w(*.md)]
  s.files      += [__FILE__]
  s.files      += Dir[*%w(lib/**/*.rb)]
  s.files      += Dir[*%w(native/**/*.{c,h,rb})]
  s.extensions += Dir[*%w(native/**/extconf.rb)]

  s.add_runtime_dependency "cantor",         "~> 1.2"
  s.add_runtime_dependency "term-ansicolor", "~> 1.3"

  # Optional attributes
  s.executables               = %w(edi-pp edi-ed edi-obfuscate)
  s.required_ruby_version     = ">= 2.0.0"
  s.required_rubygems_version = ">= 2.5.0"
  s.requirements              # << ""

  s.add_development_dependency "rake-compiler",       "~> 1.0"
  s.add_development_dependency "rake-compiler-dock",  "~> 0.7"
end
