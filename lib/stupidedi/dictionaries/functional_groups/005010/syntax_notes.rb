module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen

        #
        # @see X222.pdf B.1.1.3.5 Syntax Notes
        #
        module SyntaxNotes

          #
          # Paired or Multiple
          #
          class P < Schema::SyntaxNote
            def copy(changes = {})
              self
            end
          end

          class << P
            def build(*args)
              new
            end
          end

          #
          # Required
          #
          class R < Schema::SyntaxNote
            def copy(changes = {})
              self
            end
          end

          class << R
            def build(*args)
              new
            end
          end

          #
          # Exclusion
          #
          class E < Schema::SyntaxNote
            def copy(changes = {})
              self
            end
          end

          class << E
            def build(*args)
              new
            end
          end

          #
          # Conditional
          #
          class C < Schema::SyntaxNote
            def copy(changes = {})
              self
            end
          end

          class << C
            def build(*args)
              new
            end
          end

          #
          # List Conditional
          #
          class L < Schema::SyntaxNote
            def copy(changes = {})
              self
            end
          end

          class << L
            def build(*args)
              new
            end
          end

        end
      end
    end
  end
end
