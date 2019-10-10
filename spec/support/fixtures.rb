require "pathname"
using Stupidedi::Refinements

Fixtures = Class.new do
  def versions
    { "006020" => "SixtyTwenty",
      "005010" => "FiftyTen",
      "004010" => "FortyTen",
      "003050" => "ThirtyFifty",
      "003040" => "ThirtyForty",
      "003010" => "ThirtyTen",
      "002001" => "TwoThousandOne",
      "00501"  => "FiveOhOne",
      "00401"  => "FourOhOne",
      "00400"  => "FourHundred",
      "00300"  => "ThreeHundred",
      "00200"  => "TwoHundred" }
  end

  def initialize(root)
    @root = Pathname.new(root)
  end

  # @return [[path, "Stupidedi::TransactionSets::FiftyTen::Standards::HP835", Stupidedi::Config]]
  def passing
    Dir["#{@root}/*/*/pass/**/*.edi"].sort.flat_map{|path| all_configs(path) }
  end

  # @return [[path, "Stupidedi::TransactionSets::FiftyTen::Standards::HP835", Stupidedi::Config]]
  def failing
    Dir["#{@root}/*/*/fail/**/*.edi"].sort.flat_map{|path| all_configs(path) }
  end

  # @return [[path, "Stupidedi::TransactionSets::FiftyTen::Standards::HP835", Stupidedi::Config]]
  def skipping
    Dir["#{@root}/*/*/skip/**/*.edi"].sort.flat_map{|path| all_configs(path) }
  end

  # @return [String]
  def read(path)
    File.open(File.join(@root, path), "rb", &:read)
  end

  # @return [Stupidedi::Parser::StateMachine, Stupidedi::Reader::Result]
  def parse(path, config = nil)
    if path.is_a?(String)
      path = Pathname.new(path)
    end

    if config.nil?
      _, config, _ = mkconfig(*parts(path))
    end

    Stupidedi::Parser.build(config).read(Stupidedi::Reader.build(read(path)))
  end

  # @return [Stupidedi::Parser::StateMachine, Stupidedi::Reader::Result]
  def parse!(path, config = nil)
    machine, result = parse(path, config)

    if result.fatal?
      result.explain{|msg| raise Stupidedi::Exceptions::ParseError, "#{msg} at #{result.position.inspect}" }
    end

    return machine, result
  end

# private

  # For a single file path, returns all the configs that could parse the file
  #
  # @return [[path, "Stupidedi::TransactionSets::FiftyTen::Standards::HP835", Stupidedi::Config]]
  def all_configs(path)
    # 005010/X221 HP835 Health Care Claim Payment Advice
    path = Pathname.new(path).relative_path_from(@root)
    name = path.each_filename.to_a[1]

    case name
    when /^(X\d{3})/
      imp = parts(path)
      std = parts(path).tap{|xs| xs[1] = "Standards" }
      [mkconfig(*imp), mkconfig(*std)]

    when /^[A-Z]{2}\d{3}/
      [mkconfig(*parts(path))]
    else
      []
    end.map{|c| path.cons(c) }
  end

  # @return ["Stupidedi::TransactionSets::FiftyTen::Standards::HP835", Stupidedi::Config]
  def mkconfig(version, kind, gs01, gs08, st01)
    # Stupidedi::TransactionSets::FiftyTen::Implementations
    v = ["Stupidedi", "TransactionSets", version, kind]

    # Stupidedi::TransactionSets::FiftyTen::Implementations::X222::HC837
    m = case kind
        when "Standards"
          [v, [gs01, st01].join].join("::")
        when "Implementations"
          [v, gs08[1], [gs01, st01].join].join("::")
        else
          raise
        end

    config = Stupidedi::Config.default.customize do |c|
      c.transaction_set.customize do |x|
        x.register(gs08.join, gs01, st01) { Object.const_get(m) }
      end
    end

    [m, config]
  end

  # For a given file path, return the most specific configuration that could
  # parse the file
  #
  # @return ["FiftyTen", "Standards",       "HP", ["005010"],         "835"]
  # @return ["FiftyTen", "Implementations", "HP", ["005010", "X221"], "835"]
  def parts(pathname)
    # ["005010", "X221 HP835 Health Care Claim Payment Advice"]
    parts          = pathname.each_filename.to_a
    version, name, = parts

    case name
    when /^(X[^ ]+) ([^ ]+)/  # (X221) (HP835) Health Care Claim Payment Advice
      a, b = $1, $2
      gs01 = b[/^.{2}/]
      gs08 = [version, a]
      st01 = b[/.{3}$/]

      [versions.fetch(version, version), "Implementations", gs01, gs08, st01]

    when /^([A-Z]{2})(\d{3})/ # (HP835) Health Care Claim Payment Advice
      gs01 = $1
      gs08 = [version]
      st01 = $2

      [versions.fetch(version, version), "Standards",       gs01, gs08, st01]
    else
      raise name.inspect
    end
  end
end.new(File.expand_path("../../fixtures/", __FILE__))
