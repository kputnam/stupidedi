# frozen_string_literal: true
module Stupidedi
  module Refinements
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

      def def_delegators(target, *methods)
        file, line, = Stupidedi.caller

        for m in methods
          if m.to_s.end_with?("=")
            class_eval(<<-RUBY, file, line.to_i - 1)
              def #{m}(value)
                #{target}.#{m}(value)
              end
            RUBY
          else
            class_eval(<<-RUBY, file, line.to_i - 1)
              def #{m}(*args, &block)
                #{target}.#{m}(*args, &block)
              end
            RUBY
          end
        end
      end
    end
  end
end
