source "http://rubygems.org"

gem "cantor", "~> 1.2.1"

group :development do
  gem "rake"
  gem "rspec"      ,"3.0.0"
  gem "rspec-collection_matchers"
  gem "yard"       ,"~> 0.8.7"
  gem "redcarpet"  ,"~> 2.3.0"
  #em "rdiscount"  ,"~> 2.1.7"

  gem "term-ansicolor"
  gem "blankslate"             ,:platforms => [:ruby_18, :mri_18, :mingw_18]
  gem "rcov"       ,"~> 0.9.9" ,:platforms => [:mri_18]
  gem "simplecov"              ,:platforms => [:ruby_19, :ruby_20, :ruby_21]

  # Older versions of Bundler fail because :ruby_22 isn't allowed
  gem "simplecov"              ,:platforms => [:ruby_22] if RUBY_VERSION >= "2.2.0"

  # We're using a patched version installed in yard/ until the
  # maintainer improves the plugin. The patch has been submitted
  # to the author.
  #
  # gem "yard-rspec", "~> 0.1"
end
