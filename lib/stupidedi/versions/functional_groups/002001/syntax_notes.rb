module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne

        #
        # @see X222.pdf A.1.3.4 Syntax Notes
        # @see X222.pdf A.1.3.8 Condition Designator
        #
        module SyntaxNotes

          #
          # Paired or Multiple: if any element specified in the relational
          # condition is present, then all of the elements specified must
          # be present.
          #
          class P < Schema::SyntaxNote
            def required(zipper)
              if zipper.node.present?
                xs = children(zipper)
                xs.any?{|x| x.node.present? } ? xs : []
              else
                []
              end
            end

            def forbidden(zipper)
              []
            end

            def reason(zipper)
              present = indexes.select{|n| zipper.child(n - 1).node.present? }
              missing = indexes - present
              "elements #{missing.join(", ")} must be present when elements #{present.join(", ")} are present"
            end
          end

          class << P
            def build(*args)
              new(args)
            end
          end

          #
          # Required: at least one of the elements specified in the condition
          # must be present
          #
          class R < Schema::SyntaxNote
            def required(zipper)
              if zipper.node.present?
                xs = children(zipper)
                xs.any?{|x| x.node.present? } ? [] : xs
              else
                []
              end
            end

            def forbidden(zipper)
              []
            end

            def reason(zipper)
              present = indexes.select{|n| zipper.child(n - 1).node.present? }
              missing = indexes - present
              "at least one of elements #{missing.join(", ")} must be present when elements #{present.join(", ")} are present"
            end
          end

          class << R
            def build(*args)
              new(args)
            end
          end

          #
          # Exclusion: not more than one of the elements in the condition may
          # be present
          #
          class E < Schema::SyntaxNote
            def required(zipper)
              []
            end

            def forbidden(zipper)
              if zipper.node.present?
                xs = children(zipper)
                xs.count{|x| x.node.present? } <= 1 ? [] : xs
              else
                []
              end
            end

            def reason(zipper)
              present = indexes.select{|n| zipper.child(n - 1).node.present? }
              "only one of elements #{present.join(", ")} may be present"
            end
          end

          class << E
            def build(*args)
              new(args)
            end
          end

          #
          # Conditional: if the first element specified in the condition is
          # present, then all other elements must be specified.
          #
          class C < Schema::SyntaxNote
            def required(zipper)
              if zipper.node.present?
                if zipper.child(indexes.head - 1).node.present?
                  children(zipper).tail
                else
                  []
                end
              else
                []
              end
            end

            def forbidden(zipper)
              []
            end

            def reason(zipper)
              "elements #{indexes.tail.join(", ")} must be present when element #{indexes.head} is present"
            end
          end

          class << C
            def build(*args)
              new(args)
            end
          end

          #
          # List Conditional: if the first element specified in the condition is
          # present, then at least one of the remaining elements must be present
          #
          class L < Schema::SyntaxNote
            def required(zipper)
              if zipper.node.present?
                if zipper.child(indexes.head - 1).node.present?
                  xs = children(zipper).tail
                  xs.any?{|x| x.node.present? } ? [] : xs
                else
                  []
                end
              else
                []
              end
            end

            def forbidden(zipper)
              []
            end

            def reason(zipper)
              "at least one of elements #{indexes.tail.join(", ")} must be present when element #{indexes.head} is present"
            end
          end

          class << L
            def build(*args)
              new(args)
            end
          end

        end
      end
    end
  end
end
