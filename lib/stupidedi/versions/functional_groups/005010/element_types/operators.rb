module Stupidedi
  using Refinements

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
                      copy(:value => value.#{op}(&block))
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

                # Note that we can't test respond_to?(coerce) because coerce is
                # often a refinement method, like #to_d, #to_time, etc. Currently
                # respond_to? returns false on refinment methods, so we just call
                # the method and assume a NoMethodError is due to coerce (hopefully
                # not some other missing method)
                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(other, &block)
                      begin
                        copy(:value => value.#{op}(other.#{coerce}, &block))
                      rescue NoMethodError
                        begin
                          me, he = other.coerce(self)
                          copy(:value => me.#{op}(he, &block).#{coerce})
                        rescue NoMethodError
                          raise TypeError,
                            "cannot coerce \#{other.class} to \#{self.class}"
                        end
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

                # Note that we can't test respond_to?(coerce) because coerce is
                # often a refinement method, like #to_d, #to_time, etc. Currently
                # respond_to? returns false on refinment methods, so we just call
                # the method and assume a NoMethodError is due to coerce (hopefully
                # not some other missing method)
                ops.each do |op|
                  class_eval(<<-RUBY, file, line.to_i - 1)
                    def #{op}(other, &block)
                      begin
                        value.#{op}(other.#{coerce}, &block)
                      rescue NoMethodError
                        begin
                          me, he = other.coerce(self)
                          me.#{op}(he, &block)
                        rescue NoMethodError
                          raise TypeError,
                            "cannot coerce \#{other.class} to \#{self.class}"
                        end
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
                      copy(:value => value.#{op}(*args, &block))
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
