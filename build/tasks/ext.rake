require "rake/extensiontask"
require "rake/extensioncompiler"

spec_ext = Gem::Specification.load("build/gemspec/stupidedi-exts.gemspec")

# rake compile
Rake::ExtensionTask.new("native_ext", spec_ext) do |t|
  t.ext_dir = "ext/c/stupidedi/reader"  # Where source is located
  t.lib_dir = "lib/stupidedi/reader"    # Where binaries will go
  t.tmp_dir = "build/generated/ext"

  if (Rake::ExtensionCompiler.mingw_host rescue nil)
    t.cross_compile         = true
    t.cross_platform        = %w(x86-mingw32 x64-mingw32 x86-linux x86_64-linux)
    t.cross_config_options << "--enable-cross-build"

    t.cross_compiling do |s|
      # Modify gemspec for Windows binary
      s.files     -= Dir[*%w(ext/c/**/*)]
      s.files     += Dir[*%w(lib/**.dll)]
      s.extensions = []
    end
  end
end
