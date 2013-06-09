module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          module Operators

            module Unary
              def unary_operators(*ops)
                file, line, = Stupidedi.caller

                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(&block)
                      copy(:value => value.__send__(:#{op}, &block))
                    end
                  RUBY
                end
              end
            end

            module Binary
              def binary_operators(*ops)
                file, line, = Stupidedi.caller

                if ops.last.is_a?(Hash)
                  options = ops.pop

                  case options[:coerce]
                  when String, Symbol
                    coerce = options[:coerce]
                  else
                    raise ArgumentError,
                      "must pass :coerce => :method"
                  end
                else
                  raise ArgumentError,
                    "must pass :coerce => :method"
                end

                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(other, &block)
                      if other.respond_to?(:#{coerce})
                        copy(:value => value.__send__(:#{op}, other.#{coerce}, &block))
                      elsif other.respond_to?(:coerce)
                        me, he = other.coerce(self)
                        copy(:value => me.__send__(:#{op}, he, &block).#{coerce})
                      else
                        raise TypeError,
                          "cannot coerce \#{other.class} to \#{self.class}"
                      end
                    end
                  RUBY
                end
              end
            end

            module Relational
              def relational_operators(*ops)
                file, line, = Stupidedi.caller

                if ops.last.is_a?(Hash)
                  options = ops.pop

                  case options[:coerce]
                  when String, Symbol
                    coerce = options[:coerce]
                  else
                    raise ArgumentError,
                      "must pass :coerce => :method"
                  end
                else
                  raise ArgumentError,
                    "must pass :coerce => :method"
                end

                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(other, &block)
                      if other.respond_to?(:#{coerce})
                        value.__send__(:#{op}, other.#{coerce}, &block)
                      elsif other.respond_to?(:coerce)
                        me, he = other.coerce(self)
                        me.__send__(:#{op}, he, &block)
                      else
                        raise TypeError,
                          "cannot coerce \#{other.class} to \#{self.class}"
                      end
                    end
                  RUBY
                end
              end
            end

            module Wrappers
              def wrappers(*ops)
                file, line, = Stupidedi.caller

                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(*args, &block)
                      copy(:value => value.__send__(:#{op}, *args, &block))
                    end
                  RUBY
                end
              end
            end

          end

        end
      end
    end
  end
end
