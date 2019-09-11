require "base64"
require "term/ansicolor"

# If you want to disable coverage, it's annoying to manually edit spec_helper.rb
# to comment-out `require "simplecov"`, then be certain not to commit that edit.
#
# Two other ways to accomplish this that don't require editing a tracked file:
#   1. Set/test a global ENV variable: `NOCOV=1 bundle exec rake spec`
#   2. Edit .rspec and add some flag. While RSpec doesn't have a way to let us
#      add our own CLI options, we can sneak in via --tag '~coverage'.
#
# But #2 is tricky, because RSpec doesn't parse the options in .rspec until well
# after spec_helper.rb has executed. That means RSpec.configure {...} cannot
# check if '--tag ~coverage' was passed on the CLI or in .rspec file
#
# So, at best we can wait until after RSpec has run and peek at RSpec.world,
# which is the global configuration that's setup sometime after spec_helper.rb
# is executed. Then we can reconfigure the output of SimpleCov according to
# the RSpec filters.
#
# This handler must be registered *before* calling SimpleCov.start, because it
# registers its own at_exit handler that prints the results.
at_exit do
  if RSpec.world.exclusion_filter.rules[:coverage] == true
    SimpleCov.formatter = Class.new { def format(*args); end }
  else
    if defined?(SimpleCov::Formatter::CustomHtmlFormatter)
      SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::SummaryFormatter,
        SimpleCov::Formatter::CustomHtmlFormatter])
    else
      SimpleCov.formatter = SimpleCov::Formatter::SummaryFormatter
    end
  end
end

SimpleCov.start do
  coverage_dir "build/generated/coverage"

  add_filter %r{/spec}
  add_filter %r{/segment_defs}
  add_filter %r{/element_defs}
  add_filter %r{/transaction_sets/[0-9]+/[A-Z0-9-]+\.rb}
  add_filter %r{/stupidedi/editor}

  add_group "Refinements",      "lib/stupidedi/ruby"
  add_group "Config",           "lib/stupidedi/config"
  add_group "Editor",           "lib/stupidedi/editor"
  add_group "Exceptions",       "lib/stupidedi/exceptions"
  add_group "Interchanges",     "lib/stupidedi/interchanges"
  add_group "Parser",           "lib/stupidedi/parser"
  add_group "Reader",           "lib/stupidedi/reader"
  add_group "Tokens",           "lib/stupidedi/tokens"
  add_group "Position",         "lib/stupidedi/position"
  add_group "Schema",           "lib/stupidedi/schema"
  add_group "TransactionSets",  "lib/stupidedi/transaction_sets"
  add_group "Values",           "lib/stupidedi/values"
  add_group "Versions",         "lib/stupidedi/versions"
  add_group "Writer",           "lib/stupidedi/writer"
  add_group "Zipper",           "lib/stupidedi/zipper"
end unless ENV.include?("NOCOV")
