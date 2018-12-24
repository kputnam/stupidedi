source "http://rubygems.org"

gem "cantor", "~> 1.2.1"

group :development do
  gem "rake"
  gem "rspec"      , "3.8.0"

  gem "rspec-collection_matchers"
  gem "yard"       ,"~> 0.9.12"
  gem "redcarpet"  ,"~> 3.4.0", :platforms => [:mri]


  gem "term-ansicolor"
  gem "blankslate"             ,:platforms => [:ruby_18, :mri_18, :mingw_18]

  gem "rcov"       ,"~> 1.0.0" ,:platforms => [:mri_18]

  # https://github.com/colszowka/simplecov#ruby-version-compatibility
  gem "simplecov"              ,:platforms => [:ruby_19, :ruby_20, :ruby_21,
                                               :ruby_22, :ruby_23, :ruby_24,
                                               :ruby_25]
  # We're using a patched version installed in yard/ until the
  # maintainer improves the plugin. The patch has been submitted
  # to the author.
  #
  # gem "yard-rspec", "~> 0.1"
end
