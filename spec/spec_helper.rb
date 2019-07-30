Bundler.setup(:default, :development, :test)
begin
  require "simplecov"
rescue LoadError
end

require "stupidedi"
require "ostruct"
require "pp"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each(&method(:require))

RSpec.configure do |config|
  config.include(EitherMatchers)
  config.include(Quickcheck::Macro)
  config.extend(RSpecHelpers)

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Use either of these to run only specs marked 'focus: true'
  #   config.filter_run(:focus  => true)
  #   $ rspec -r spec_helper -t focus

  # Use either of these to run only randomized specs:
  #   config.filter_run(:random => true)
  #   $ rspec -r spec_helper -t random

  # When a randomized test fails, it will print a seed value you
  # can use to repeat the test with the same generated inputs:
  #   srand 44182052595481443184625304627718313206

  # Use either of these to skip running randomized specs:
  #   config.filter_run_excluding(:random => true)
  #   $ rspec -r spec_helper -t ~random

  # Skip platform-specific examples unless our platform matches (exclude non-matches)
  config.filter_run_excluding(ruby: lambda{|expected| /^#{expected}/ !~ RUBY_VERSION })
  config.filter_run_excluding(:skip)
  #onfig.filter_run_including(:focus)

  config.profile_examples     = true
  #onfig.fail_fast            = true
  config.fail_if_no_examples  = true

  # https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/custom-deprecation-stream
  # https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/overriding-global-ordering
end
