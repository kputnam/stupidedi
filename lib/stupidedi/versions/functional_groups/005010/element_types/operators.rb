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
                    def #{op}
                      copy(:value => @value.__send__(:#{op}))
                    end
                  RUBY
                end
              end
            end

            module Binary
              def binary_operators(*ops)
                file, line, = Stupidedi.caller

                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(other)
                      if other.respond_to?(:to_d)
                        copy(:value => @value.__send__(:#{op}, other.to_d))
                      else
                        me, he = other.coerce(self)
                        copy(:value => me.__send(:#{op}, he).to_d)
                      end
                    end
                  RUBY
                end
              end
            end

            module Relational
              def relational_operators(*ops)
                file, line, = Stupidedi.caller

                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(other)
                      if other.respond_to?(:to_d)
                        @value.__send__(:#{op}, other.to_d)
                      else
                        me, he = other.coerce(self)
                        me.__send(:#{op}, he)
                      end
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
