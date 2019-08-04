# frozen_string_literal: true
module Stupidedi
  module Refinements

    # When `def_delegators` is given `debug: true`, this hash map will
    # have [class, method] => number of invocations.
    CALL_COUNT = Hash.new(0)

    # Kernel.at_exit do
    #   pp CALL_COUNT
    # end

    # Used as a default value for optional arguments; when this is received
    # by a delegator method we know the user didn't provide a value.
    class DEFAULT < BasicObject; end

    refine Module do
      # Creates an abstract method
      #
      # @example
      #   class Collection
      #     abstract :size
      #     abstract :add, :args => %w(item)
      #   end
      #
      # @return [void]
      def abstract(name, *params)
        if params.last.is_a?(Hash)
          # abstract :method, :args => %w(a b c)
          params = params.last[:args]
        end

        file, line, = Stupidedi.caller

        if params.empty?
          class_eval(<<-RUBY, file, line.to_i - 1)
            def #{name}(*args)
              raise NoMethodError,
                "method \#{self.class.name}.#{name} is abstract"
            end
          RUBY
        else
          class_eval(<<-RUBY, file, line.to_i - 1)
            def #{name}(*args)
              raise NoMethodError,
                "method \#{self.class.name}.#{name}(#{params.join(", ")}) is abstract"
            end
          RUBY
        end
      end

      # If we simply forward all arguments using `def foo(*args, &block)`, then
      # we allocate an extra Array to store the parameters. This can really add
      # up for methods that are called many times.
      #
      # When given a `type: Class` or `instance: Class.allocate`, we can inspect
      # the Method/UnboundMethod and see the parameter list. Then we can usually
      # declare a method that takes exactly the same parameters as the receiving
      # method. Then invoking the delegating method won't cause anything to be
      # allocated. Sometimes we have to fallback on *args though.
      #
      #   class X
      #     def_delegators_ :push, :length, to: "@ary", type: Array
      #     def_delegators_ :[], :[]=,      to: "@map", instance: {}
      #
      #     def initialize
      #       @ary, @map = [], {}
      #     end
      #   end
      #
      def def_delegators(receiver, *names, type:DEFAULT, instance:DEFAULT, debug:nil)
        file, line, = Stupidedi.caller

        if not DEFAULT.eql?(instance)
          names.each do |name|
            def_delegator(receiver, name, file, line, instance.method(name), debug)
          end
        elsif not DEFAULT.eql?(type)
          names.each do |name|
            def_delegator(receiver, name, file, line, type.instance_method(name), debug)
          end
        else
          names.each do |name|
            def_delegator(receiver, name, file, line, nil, debug)
          end
        end
      end

    private

      def def_delegator(receiver, name, file, line, method, debug)
        if method.nil?
          if name.to_s.end_with?("=")
            class_eval(<<-RUBY.tap{|s| puts s if debug }, file, line.to_i - 1)
              def #{name}(value)
                #{emit_instrumentation(name) if debug}
                #{receiver}.#{name}(value)
              end
            RUBY
          else
            class_eval(<<-RUBY.tap{|s| puts s if debug }, file, line.to_i - 1)
              def #{name}(*args, &block)
                #{emit_instrumentation(name) if debug}
                #{receiver}.#{name}(*args, &block)
              end
            RUBY
          end
        else
          new_names = String.new("__`")
          has_block = false
          optionals = []

          triples   = method.parameters.map do |k, n|
            n ||= (new_names.succ!).dup               # Get a fresh name if needed

            case k
            when :req     then [n, n, n]              # def foo(x)
            when :keyreq  then [n, n, "#{n}:#{n}"]    # def foo(x:)
            when :rest    then [n, "*#{n}", "*#{n}"]  # def foo(*x)
            when :opt     then                        # def foo(x = nil)
              optionals << n
              [n, "#{n}=#{DEFAULT}", n]
            when :key                                 # def foo(x: nil)
              optionals << n
              [n, "::#{n}:#{DEFAULT}", "#{n}:#{n}"]
            when :block                               # def foo(&x)
              has_block = true
              [n, "&#{n}", "&#{n}"]
            end
          end

          unless has_block
            # We can't know if the receiver method uses an *implicit* block
            # parameter, so we will pass along any block we are given.
            triples << [new_names.succ!, "&#{new_names}", "&#{new_names}"]
          end

          arg_names  = triples.map{|n, _, _| n }
          arguments  = Hash[triples.map{|n, _, a| [n, a] }] # How to pass
          parameters = triples.map{|_, p, _| p }.join(", ") # How to recv

          class_eval(<<-RUBY.tap{|x| puts x if debug }, file, line.to_i - 1)
            def #{name}(#{parameters})
              #{emit_instrumentation(name) if debug}
              #{emit_branches(optionals, 7) do |state|
                emit_call(receiver, name, arg_names, arguments, optionals, state)
              end.lstrip}
            end
          RUBY
        end
      end

      def emit_instrumentation(name)
        "Stupidedi::Refinements::CALL_COUNT[['#{self.name}', '#{name}']] += 1"
      end

      def emit_branches(optionals, predent, state=0, depth=0, &block)
        indent = "  " * (predent + depth)

        if optionals.empty?
          "#{indent}#{yield state}"
        else
          head, *tail = optionals
          end_state   = optionals.length.times.inject(state) do |s,n|
            s | (1 << (depth + n))
          end

          ["#{indent}if #{DEFAULT}.eql?(#{head})",
             emit_branches([], predent, end_state, depth+1, &block),
           "#{indent}else",
             emit_branches(tail, predent, state,   depth+1, &block),
           "#{indent}end"].join("\n")
        end
      end

      def emit_call(receiver, name, arg_names, arguments, optionals, state)
        "#{receiver}.#{name}(#{emit_args(arg_names, arguments, optionals, state)})"
      end

      def emit_args(arg_names, arguments, optionals, state)
        arg_names.inject([]) do |xs, name|
           if k = optionals.index(name)
             xs << arguments[name] if state[k].zero?
           else
             xs << arguments[name]
           end; xs
        end.join(", ")
      end
    end
  end
end
