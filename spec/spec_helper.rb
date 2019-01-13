# The SimpleCov.start must be issued before any of your application code is required!
begin
  require "simplecov"
  SimpleCov.start do
    add_filter %r{/segment_defs}
    add_filter %r{/element_defs}
    add_filter %r{/spec}
    add_filter %r{/transaction_sets/[0-9]+/[A-Z0-9-]+\.rb}

    add_group "Refinements",      "lib/ruby"
    add_group "Config",           "lib/stupidedi/config"
    add_group "Editor",           "lib/stupidedi/editor"
    add_group "Exceptions",       "lib/stupidedi/exceptions"
    add_group "Interchanges",     "lib/stupidedi/interchanges"
    add_group "Parser",           "lib/stupidedi/parser"
    add_group "Reader",           "lib/stupidedi/reader"
    add_group "Schema",           "lib/stupidedi/schema"
    add_group "TransactionSets",  "lib/stupidedi/transaction_sets"
    add_group "Values",           "lib/stupidedi/values"
    add_group "Versions",         "lib/stupidedi/versions"
    add_group "Writer",           "lib/stupidedi/writer"
    add_group "Zipper",           "lib/stupidedi/zipper"
  end
rescue LoadError
end

require File.expand_path("../../lib/stupidedi", __FILE__)
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
