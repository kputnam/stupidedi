require "bundler"
Bundler::GemHelper.install_tasks

task :default => :spec

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new do |t|
  t.verbose    = false
  t.rspec_opts = %w(-w -rspec_helper)

  if ENV.include?("CI") or ENV.include?("TRAVIS")
    t.rspec_opts += %w(--format progress)
  else
    t.rspec_opts += %w(--format documentation)
  end
end

# Note options are loaded from .yardopts
require "yard"
require "pathname"
abspath = Pathname.new(File.dirname(__FILE__)).expand_path
relpath = abspath.relative_path_from(Pathname.pwd)
YARD::Rake::YardocTask.new(:yard => :clobber_yard)
task :clobber_yard do

  rm_rf "#{relpath}/build/generated/doc"
  mkdir_p "#{relpath}/build/generated/doc/images"
end

task :console do
  exec(*%w(irb -I lib -r stupidedi))
end

if RUBY_PLATFORM !~ /java/
  require "rake/extensiontask"
  gemspec = Gem::Specification.load("stupidedi.gemspec")

  Rake::ExtensionTask.new("strncmp") do |x|
    x.lib_dir = "lib/strncmp"
  end
end
