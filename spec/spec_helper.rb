require File.expand_path("../../lib/stupidedi", __FILE__)

begin
  # RSpec-1: https://github.com/dchelimsky/rspec
  require "spec"
rescue LoadError
  # RSpec-2: https://github.com/rspec/rspec
  require "rspec"
end

begin
  require "simplecov"
  SimpleCov.start
rescue LoadError
  warn $!
end if RUBY_VERSION >= "1.9"

begin
  require "pry"
rescue LoadError
  warn $!
end if RUBY_VERSION = "1.9"

begin
  require "pry-byebug"
rescue LoadError
  warn $!
end if RUBY_VERSION >= "2.0"

# Require supporting files with custom matchers and macros
Pathname.new(File.dirname(__FILE__)).tap do |specdir|
  Dir["#{specdir}/support/**/*.rb"].each do |file|
    require Pathname.new(file).relative_path_from(specdir)
  end
end

RSpec.configure do |config|
  config.include(EitherMatchers)

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  
  # rspec -I lib -t random spec
  # config.filter_run :random => true

  # rspec -I lib -t ~random spec
  # config.filter_run_excluding :random => true

  # Skip platform-specific examples unless our platform matches
  config.filter_run_excluding(:ruby => lambda{|n| RUBY_VERSION !~ /^#{n}/ })

# config.filter_run(:random => true)
# config.filter_run(:focus  => true)

# srand 44182052595481443184625304627718313206
end
