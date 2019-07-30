require "rubygems/package_task"

# rake gem
# rake package          == gem
# rake repackage        == clobber_package + package
# rake clobber_package
Dir["build/gemspec/*.gemspec"].each do |x|
  gem_spec = Gem::Specification.load(x)
  Gem::PackageTask.new(gem_spec) do |t|
    t.package_dir = "build/generated/pkg"
  end

  # Make gem also depend on gemspec
  gem_file = File.basename(gem_spec.cache_file)
  gem_path = File.join("build/generated/pkg", gem_file)
  file gem_file => x
end

# Build extension first with `rake compile`
Rake::Task["gem"].prerequisites << "compile"

# Hide this from the rake -T, since it's an intermediate task of `rake package`
Rake::Task["gem"].clear_comments

# The normal `clobber_package` task does `rm -rf build/generated/pkg`, rather
# than removing specific gem files and directories. Here we only remove the
# current package.
Rake::Task["clobber_package"].clear
Dir["build/gemspec/*.gemspec"].each do |x|
  gem_spec = Gem::Specification.load(x)
  gem_file = File.basename(gem_spec.cache_file)
  gem_path = File.join("build/generated/pkg", gem_file)

  task "clobber_package" do
    rm_f  gem_path
    rm_rf gem_path[/^(.+?)\.gem/, 1]
  end
end
