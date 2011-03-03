module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementReqs

          Mandatory = Class.new(Schema::ElementReq) do
            # @private
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

          Optional = Class.new(Schema::ElementReq) do
            # @private
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

          Relational = Class.new(Schema::ElementReq) do
            # @private
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
