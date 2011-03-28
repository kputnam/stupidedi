begin
  # RSpec-1: https://github.com/dchelimsky/rspec
  require "spec"
rescue LoadError
  # RSpec-2: https://github.com/rspec/rspec
  require "rspec"
end

specdir = File.expand_path(File.dirname(__FILE__))

$:.unshift(specdir)
$:.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require "stupidedi"

# Require supporting files with custom matchers and macros
Dir["#{specdir}/support/**/*.rb"].each do |f|
  require f.slice(specdir.length + 1 .. -1)
end

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
