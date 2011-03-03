#
# t = ThreadLocalVal("default")
# t.get           #=> "default"
# t.set("value")
#
# Thread.new { t.get }.value                  #=> "default"
# Thread.new { t.set(:vanish); t.get }.value  #=> :vanish
#
# t.get           #=> "value"
#
class ThreadLocalVar

  def initialize(value)
    @value   = value
    @threads = Hash.new
  end

  def get
    @threads.fetch(Thread.current) do
      case @value
      when Numeric, Symbol, nil
        # These are immutable values and can't be cloned
        @value
      else
        @threads[Thread.current] = @value.clone
      end
    end
  end

  def set(value)
    @threads[Thread.current] = value
  end

  def gc
    @threads = @threads.inject({}) do |threads, (t,v)|
      if t.alive?
        threads.update(t => v)
      else
        threads
      end
    end
  end

end

#
# class Counter
#   delegate :current, :current=, :to => @threadlocal
#
#   def counter(start)
#     @threadlocal = ThreadLocalHash.new(:current => start)
#   end
# end
#
# counter = Counter.new(50)
#
# x = Thread.new { 200.times { counter.current += 1 }; counter.current }
# y = Thread.new { 300.times { counter.current += 1 }; counter.current }
#
# x.value         #=> 250
# x.value         #=> 350
# counter.current #=> 50
#
class ThreadLocalHash

  def initialize(defaults = {})
    @defaults = defaults.clone
    @clones   = Hash.new

    defaults.keys.each do |name|
      case defaults[name]
      when Numeric, Symbol, nil
        # These are immutable values and can't be cloned
        instance_eval <<-RUBY
          def #{name}
            @clones.fetch([Thread.current, :#{name}]) do
              @defaults[:#{name}]
            end
          end
        RUBY
      else
        instance_eval <<-RUBY
          def #{name}
            @clones.fetch([Thread.current, :#{name}]) do
              @clones[[Thread.current, :#{name}]] =
                @defaults[:#{name}].clone
            end
          end
        RUBY
      end

      instance_eval <<-RUBY
        def #{name}=(value)
          @clones[[Thread.current, :#{name}]] = value
        end
      RUBY
    end
  end

  def [](name)
    @clones.fetch([Thread.current, name]) do
      case value = @defaults[name]
      when Numeric, Symbol, nil
        # These are immutable values and can't be cloned
        value
      else
        @clones[[Thread.current, name]] = value.clone
      end
    end
  end

  def []=(name, value)
    @clones[[Thread.current, name]] = value
  end

  def gc
    @clones = @clones.inject({}) do |clones, ((t,n),v)|
      if t.alive?
        clones.update([t,n] => v)
      else
        clones
      end
    end
  end

  def method_missing(name, value = (getter = true))
    if getter
      self[name]
    else
      if name.to_s =~ /^(.+)=$/
        self[$1.to_sym] = value
      else
        super
      end
    end
  end

end
