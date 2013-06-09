Fixtures = Class.new do
  def initialize(root)
    @root  = root
    @files = Hash.new{|h,k| h[k] = parse(k) }

    @config  = Stupidedi::Config.hipaa
    @machine = Stupidedi::Builder::StateMachine.build(@config)
  end

  def file(path)
    @files[path]
  end

  # @return [StateMachine]
  def parse(path)
    path = File.join(@root, path)
    pair = File.open(path){|io| @machine.read(Stupidedi::Reader.build(io)) }

    machine, result = pair
    if result.fatal?
      result.explain{|msg| raise msg }
    end

    machine
  end
end.new(File.expand_path("../../fixtures", __FILE__))
