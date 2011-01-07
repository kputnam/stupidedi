require 'rubygems'
require 'rake/gempackagetask'
require 'spec'
require 'spec/rake/spectask'
require 'yard'

WINDOWS = (PLATFORM =~ /win32|cygwin/ ? true : false) rescue false
SUDO = WINDOWS ? '' : 'sudo'

task :default => :install

load 'yard-rspec.gemspec'
Rake::GemPackageTask.new(SPEC) do |pkg|
  pkg.gem_spec = SPEC
  pkg.need_zip = true
  pkg.need_tar = true
end

desc "Install the gem locally"
task :install => :package do 
  sh "#{SUDO} gem install pkg/#{SPEC.name}-#{SPEC.version}.gem --local --no-rdoc --no-ri"
  sh "rm -rf pkg/yard-#{SPEC.version}" unless ENV['KEEP_FILES']
end

YARD::Rake::YardocTask.new
