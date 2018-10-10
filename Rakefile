require "pathname"
abspath = Pathname.new(File.dirname(__FILE__)).expand_path
relpath = abspath.relative_path_from(Pathname.pwd)

task :default => :spec

task :console do
  exec(*%w(irb -I lib -r stupidedi))
end

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new do |t|
    t.verbose = false

    t.rspec_opts  = %w(--color --format p)
    t.rspec_opts << "-I#{abspath}/spec"
  end
rescue LoadError => first
  begin
    require "spec/rake/spectask"

    Spec::Rake::SpecTask.new do |t|
      t.spec_opts << "--color"
      t.spec_opts << "--format p"
      t.libs << "#{abspath}/spec"
    end
  rescue LoadError => second
    task :spec do
      warn "couldn't load rspec version 1 or 2:"
      warn "  #{first}"
      warn "  #{second}"
      exit 1
    end
  end
end

begin
  require "rcov"

  begin
    require "rspec/core/rake_task"
    RSpec::Core::RakeTask.new(:rcov) do |t|
      t.rcov = true
      t.rcov_opts = "--exclude spec/,gems/,00401"

      t.verbose = false

      t.rspec_opts  = %w(--color --format p)
      t.rspec_opts << "-I#{abspath}/spec"
    end
  rescue LoadError => first
    begin
      require "spec/rake/spectask"
      Spec::Rake::SpecTask.new(:rcov) do |t|
        t.rcov = true
        t.rcov_opts = %w(--exclude spec/,gems/)

        t.spec_opts << "--color"
        t.spec_opts << "--format=p"
        t.libs << "#{abspath}/spec"
      end
    rescue LoadError => second
      task :rcov do
        warn "couldn't load rspec version 1 or 2:"
        warn "  #{first}"
        warn "  #{second}"
        exit 1
      end
    end
  end
rescue LoadError => e
  task :rcov do
    warn "couldn't load rcov:"
    warn "  #{e}"
    exit 1
  end
end if RUBY_VERSION <= "1.9"

if RUBY_VERSION >= "1.9"
  # spec/spec_helper.rb will load SimpleCov
  task :rcov => :spec do
  end
end

begin
  require "yard"

  # Note options are loaded from .yardopts
  YARD::Rake::YardocTask.new(:yard => :clobber_yard)

  task :clobber_yard do
    rm_rf "#{relpath}/doc/generated"
    mkdir_p "#{relpath}/doc/generated/images"
  end

rescue LoadError => e
  task :yard do
    warn "couldn't load yard:"
    warn "  #{e}"
    exit 1
  end
end
