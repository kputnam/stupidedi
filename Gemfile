source "http://rubygems.org"

gem "called_from", :platforms => [:ruby_18, :mri_18, :mingw_18]

group :development do
  gem "rake"
  gem "rspec"      ,"~> 2.8.0"
  gem "yard"       ,"~> 0.7.4"
  gem "rdiscount"  ,"~> 1.6.8"

  gem "term-ansicolor"
  gem "blankslate"             ,:platforms => [:ruby_18, :mri_18, :mingw_18]
  gem "rcov"       ,"~> 0.9.9" ,:platforms => [:mri_18]
  gem "simplecov"              ,:platforms => [:ruby_19, :ruby_20]

  # We're using a patched version installed in yard/ until the
  # maintainer improves the plugin. The patch has been submitted
  # to the author.
  #
  # gem "yard-rspec", "~> 0.1"
end
