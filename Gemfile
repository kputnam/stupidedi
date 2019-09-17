source "http://rubygems.org"

gemspec(path: "build/gemspec", name: "stupidedi")
gemspec(path: "build/gemspec", name: "stupidedi-core")
gemspec(path: "build/gemspec", name: "stupidedi-defs")
gemspec(path: "build/gemspec", name: "stupidedi-exts")

group :development do
  gem "yard",      "= 0.9.16"
  gem "rdiscount", "~> 2.2"

  gem "irb"#                       "~> 1.0"
  gem "rake",                      "~> 12.3"
  gem "rspec",                     "~> 3.8"
  gem "rspec-collection_matchers"# " "
  gem "stackprof",                 "~> 0.2"
  gem "benchmark-ips"#             ""
  gem "simplecov"#                 ""
  gem "simplecov-inline-html"      if RUBY_VERSION >= "2.4"
end
