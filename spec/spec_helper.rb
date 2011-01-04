begin
  # https://github.com/dchelimsky/rspec
  require 'spec'
rescue LoadError
  # https://github.com/rspec/rspec
  require 'rspec'
end

spec = File.expand_path(File.dirname(__FILE__))

$:.unshift(spec)
$:.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require "stupidedi"

# Require supporting files with custom matchers and macros
Dir["#{spec}/support/**/*.rb"].each{|f| require f.slice(spec.length + 1 .. -1) }

RSpec.configure do |config|
  config.include(EitherMatchers)

  # rspec -I lib -t random spec
  # config.filter_run :random => true

  # rspec -I lib -t ~random spec
  # config.filter_run_excluding :random => true

  # Skip platform-specific examples unless our platform matches
  config.filter_run_excluding(:ruby => lambda{|n| RUBY_VERSION !~ /^#{n}/ })

# config.filter_run(:focused => true)
end
