module Stupidedi
  using Refinements

  #
  # @example
  #   t = ThreadLocalVal("default")
  #   t.get           #=> "default"
  #   t.set("value")  #=> "value"
  #
  #   Thread.new { t.get }.value                  #=> "default"
  #   Thread.new { t.set(:vanish); t.get }.value  #=> :vanish
  #
  #   t.get           #=> "value"
  #
  class ThreadLocalVar
    include Inspect

    def initialize(value)
      @value   = value
      @threads = Hash.new
      @cleaner = lambda {|key| @threads.delete(key) }
    end

    def get
      @threads.fetch(key) do
        case @value
        when Numeric, Symbol, nil
          # These are immutable values and can't be cloned
          @value
        else
          finalizer(Thread.current)
          @threads[key] = @value.clone
        end
      end
    end

    # @return value
    def set(value)
      unless @threads.include?(key)
        finalizer(Thread.current)
      end

      @threads[key] = value
    end

    def unset
      @threads.delete(key)
    end

    def set?
      @threads.include?(key)
    end

  private

    # @return [Numeric]
    def key
      Thread.current.object_id
    end

    # @return [void]
    def finalizer(thread)
      ObjectSpace.define_finalizer(thread, @cleaner)
    end

  end

  #
  # @example
  #   class Counter
  #     delegate :current, :current=, :to => @threadlocal
  #
  #     def counter(start)
  #       @threadlocal = ThreadLocalHash.new(:current => start)
  #     end
  #   end
  #
  #   counter = Counter.new(50)
  #
  #   x = Thread.new { 200.times { counter.current += 1 }; counter.current }
  #   y = Thread.new { 300.times { counter.current += 1 }; counter.current }
  #
  #   x.value         #=> 250
  #   x.value         #=> 350
  #   counter.current #=> 50
  #
  class ThreadLocalHash
    include Inspect

    def initialize(defaults = {})
      @defaults = defaults.clone
      @threads  = Hash.new
      @cleaner  = lambda {|key| @threads.delete_if{|(t,_),_| t == key }}

      defaults.keys.each do |name|
        case defaults[name]
        when Numeric, Symbol, nil
          # These are immutable values and can't be cloned
          instance_eval <<-RUBY
            def #{name}
              @threads.fetch([key, :#{name}]) do
                @defaults[:#{name}]
              end
            end
          RUBY
        else
          instance_eval <<-RUBY
            def #{name}
              @threads.fetch([key, :#{name}]) do
                finalizer(Thread.current)
                @threads[[key, :#{name}]] =
                  @defaults[:#{name}].clone
              end
            end
          RUBY
        end

        instance_eval <<-RUBY
          def #{name}=(value)
            unless @threads.include?(key)
              finalizer(Thread.current)
            end

            @threads[[key, :#{name}]] = value
          end
        RUBY
      end
    end

    def [](name)
      @threads.fetch([Thread.current, name]) do
        case value = @defaults[name]
        when Numeric, Symbol, nil
          # These are immutable values and can't be cloned
          value
        else
          finalizer(Thread.current)
          @threads[[key, name]] = value.clone
        end
      end
    end

    def []=(name, value)
      unless @threads.include?(key)
        finalizer(Thread.current)
      end

      @threads[[key, name]] = value
    end

  private

    def key
      Thread.current.object_id
    end

    # @return [void]
    def finalizer(thread)
      ObjectSpace.define_finalizer(thread, @cleaner)
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
end
