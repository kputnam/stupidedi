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
