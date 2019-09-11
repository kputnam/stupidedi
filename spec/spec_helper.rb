# NOTE: If you want change RSpec options for your own use, please create .rspec
# and add CLI options to it. That file is in .gitignore, so it will remain out
# of the repository. For starters, you probably want to add:
#
#   --require spec_helper
#   --require stupidedi

Bundler.setup(:default, :development, :test)

begin
  require "simplecov"
rescue LoadError
end

begin
  require "memory_profiler"
rescue
end

require "stupidedi"
require "ostruct"
require "pp"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each(&method(:require))

RSpec.configure do |config|
  config.include(MemMatchers)
  config.include(EitherMatchers)
  config.include(Quickcheck::Macro)
  config.extend(RSpecHelpers)

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Skip platform-specific examples unless our platform matches (exclude non-matches)
  config.filter_run_excluding(ruby: lambda do |expected|
    case expected
    when String
      /^#{expected}/ !~ RUBY_VERSION
    when Proc
      not expected.call(RUBY_VERSION)
    end
  end)

  config.filter_run_excluding(:skip)
  config.filter_run_excluding(:mem) unless defined? MemoryProfiler

  # This only applies if examples exist with :focus tag; then only :focus is
  # run. You can mark examples with :focus by using "fdescribe", "fcontext",
  # and "fit" instead of the normal RSpec syntax.
  config.filter_run_when_matching(:focus)
end
