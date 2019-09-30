require "rake/clean"

# rake clean -- remove temporary files, but leave final build artifacts
CLEAN.include("build/generated/coverage")
CLEAN.include("tmp/#{RUBY_PLATFORM}")

# rake clobber -- remove build artifacts + everything in CLEAN
CLOBBER.include("build/generated")
CLOBBER.include("pkg")
CLOBBER.include("Gemfile.lock")
