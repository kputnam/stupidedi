require File.expand_path("../../lib/stupidedi", __FILE__)
require "rspec"
require "pp"

begin
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |file|
    require file
  end
end

RSpec::Expectations.configuration.warn_about_potential_false_positives = false

RSpec.configure do |config|
  config.include(EitherMatchers)

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Use either of these to run only specs marked 'focus: true'
  #   config.filter_run(:focus  => true)
  #   $ rspec -I lib -t focus spec

  # Use either of these to run only randomized specs:
  #   config.filter_run(:random => true)
  #   $ rspec -I lib -t random spec

  # When a randomized test fails, it will print a seed value you
  # can use to repeat the test with the same generated inputs:
  #   srand 44182052595481443184625304627718313206

  # Use either of these to skip running randomized specs:
  #   config.filter_run_excluding(:random => true)
  #   $ rspec -I lib -t ~random spec

  # Skip platform-specific examples unless our platform matches
  config.filter_run_excluding(:ruby => lambda{|n| RUBY_VERSION !~ /^#{n}/ })
end
