require "rake/extensiontask"
require "rake/extensioncompiler"

spec = Gem::Specification.load("build/gemspec/stupidedi-native.gemspec")

# rake compile
Rake::ExtensionTask.new("native", spec) do |t|
  t.ext_dir = "native"                # Where source is located
  t.lib_dir = "lib/stupidedi/native"  # Where binaries will go
  t.tmp_dir = "build/generated/native"

  if (Rake::ExtensionCompiler.mingw_host rescue nil)
    t.cross_compile         = true
    t.cross_platform        = %w(x86-mingw32 x64-mingw32 x86-linux x86_64-linux)
    t.cross_config_options << "--enable-cross-build"

    t.cross_compiling do |s|
      # Modify gemspec for Windows binary
      s.files     -= Dir[*%w(native/**/*)]
      s.files     += Dir[*%w(lib/**.dll)]
      s.extensions = []
    end
  end
end
