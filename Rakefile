require "pathname"
abspath = Pathname.new(File.dirname(__FILE__)).expand_path
relpath = abspath.relative_path_from(Pathname.pwd)

task :default => :spec

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new do |t|
  t.verbose    = false
  t.rspec_opts = %w(-w --format doc -rspec_helper)
end

# Note options are loaded from .yardopts
require "yard"
YARD::Rake::YardocTask.new(:yard => :clobber_yard)
task :clobber_yard do
  rm_rf "#{relpath}/doc/generated"
  mkdir_p "#{relpath}/doc/generated/images"
end

task :console do
  exec(*%w(irb -I lib -r stupidedi))
end
