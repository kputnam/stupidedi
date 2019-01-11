Fixtures = Class.new do
  VERSIONS =
    { "005010" => "FiftyTen",
      "004010" => "FortyTen",
      "003050" => "ThirtyFifty",
      "003040" => "ThirtyForty",
      "003010" => "ThirtyTen",
      "002001" => "TwoThousandOne" }

  def initialize(root)
    @root = root
  end

  def passing
    Dir["#{@root}/*/*/pass/**"].map do |path|
      mkconfig(*parts(path.slice(@root.length+1..-1)))
    end
  end

  def failing
    Dir["#{@root}/*/*/fail/**"].map do |path|
      mkconfig(*parts(path.slice(@root.length+1..-1)))
    end
  end

  # @return [String]
  def read(path)
    File.open(File.join(@root, path), "rb", &:read)
  end

  # @return [Stupidedi::Parser::StateMachine, Stupidedi::Reader::Result]
  def parse(path, config = nil)
    if config.nil?
      _, config, _ = mkconfig(*parts(path))
    end

    Stupidedi::Parser.build(config).read(Stupidedi::Reader.build(read(path)))
  end

  # @return [Stupidedi::Parser::StateMachine, Stupidedi::Reader::Result]
  def parse!(path, config = nil)
    machine, result = parse(path, config)

    if result.fatal?
      result.explain{|msg| raise Stupidedi::Exceptions::ParseError, "#{msg} #{result.position.inspect}" }
    end

    return machine, result
  end

private

  # @return [String, String, String, String, Array<String>, String, String]
  def parts(path)
    parts   = path.split("/") # @todo
    version = parts[0]

    case parts[1]
    when /^(X[^-]+)-(.+)$/
      a, b = $1, $2
      gs01 = b[/^.{2}/]
      gs08 = [version, a]
      st01 = b[/.{3}$/]

      [VERSIONS.fetch(version), "Implementations", gs01, gs08, st01, path]
    when /^[A-Z]/
      gs01 = parts[1][/^.{2}/]
      gs08 = [version]
      st01 = parts[1][/.{3}$/]

      [VERSIONS.fetch(version), "Standards", gs01, gs08, st01, path]
    end
  end

  # @return [String, Stupidedi::Config, Stupidedi::Schema::TransactionSetDef]
  def mkconfig(version, kind, gs01, gs08, st01, path)
    # Stupidedi::TransactionSets::FiftyTen::Implementations
    v = ["Stupidedi", "TransactionSets", version, kind]

    t = if gs08.length == 1
          # Standards::HC837
          [[gs01, st01].join]
        else
          # Implementation::X222::HC837
          [gs08.last, [gs01, st01].join]
        end

    # Stupidedi::TransactionSets::FiftyTen::Implementations::X222::HC837
    m = (v + t).join("::")

    config = Stupidedi::Config.default.customize do |c|
      c.transaction_set.customize do |x|
        x.register(gs08.join, gs01, st01) { Object.const_get(m) }
      end
    end

    [path, config, m]
  end
end.new(File.expand_path("../../fixtures", __FILE__))
