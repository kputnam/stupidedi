module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementReqs

          # Singleton
          Mandatory = Class.new(Schema::ElementReq) do
            # @return [void]
            def pretty_print(q)
              q.text "M"
            end

            def required?
              true
            end

            def forbidden?
              false
            end
          end.new

          # Singleton
          Optional = Class.new(Schema::ElementReq) do
            # @return [void]
            def pretty_print(q)
              q.text "O"
            end

            def required?
              false
            end

            def forbidden?
              false
            end
          end.new

          # Singleton
          Relational = Class.new(Schema::ElementReq) do
            # @return [void]
            def pretty_print(q)
              q.text "X"
            end

            def required?
              false
            end

            def forbidden?
              false
            end
          end.new

        end
      end
    end
  end
end
