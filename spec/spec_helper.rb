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

require "stupidedi"
require "tempfile"
require "ostruct"
require "pp"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each(&method(:require))

RSpec.configure do |config|
  config.include(EitherMatchers)
  config.include(AllocationMatchers)
  config.include(SmallcheckMatchers)
  config.include(Quickcheck::Macro) # @todo deprecate

  # Use --tag "~mem" to skip these specs
  config.alias_example_to :allocation, mem: true

  # Use --tag "~todo" to skip these specs
  config.alias_example_to :todo, todo: true, skip: "TODO"

  config.expect_with(:rspec){|c| c.syntax = :expect }

  # Skip platform-specific examples unless our platform matches (exclude non-matches)
  #   ruby: "2.3."               # excludes Ruby 2.3.*
  #   ruby: /^2.[12]./           # excludes Ruby 2.1.*, 2.2.*
  #   ruby:->(v){|v| v < "2.3" } # excludes Ruby < 2.3
  config.filter_run_excluding(ruby: lambda do |expected|
    case expected
    when String
      not RUBY_VERSION.start_with?(expected)
    when Regexp
      expected !~ RUBY_VERSION
    when Proc
      not expected.call(RUBY_VERSION)
    end
  end)

  # This only applies if examples exist with :focus tag; then only :focus is
  # run. You can mark examples with :focus by using "fdescribe", "fcontext",
  # and "fit" instead of the normal RSpec syntax.
  config.filter_run_when_matching :focus
end
