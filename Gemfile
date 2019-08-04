source "http://rubygems.org"

gem "cantor", "~> 1.2.1"

group :development do
  gem "rake"
  gem "rake-compiler"
  gem "term-ansicolor"

  gem "rspec", "3.8.0"
  gem "rspec-collection_matchers"

  gem "yard","~> 0.9.20"
# gem "redcarpet","~> 3.4.0", :platforms => [:mri]

  # https://github.com/colszowka/simplecov#ruby-version-compatibility
  gem "simplecov",              :platforms => [:ruby_24, :ruby_25]
  gem "simplecov-inline-html",  :platforms => [:ruby_24, :ruby_25]

  gem "stackprof"
  # gem "fasterer"
  gem "benchmark-ips"
  gem "memory_profiler",        :platform => [:ruby_23, :ruby_24, :ruby_25]
  # gem "allocation_stats"
  # gem "heapy"
  # gem "derailed_benchmarks"

  # We're using a patched version installed in yard/ until the
  # maintainer improves the plugin. The patch has been submitted
  # to the author.
  #
  # gem "yard-rspec", "~> 0.1"
end
