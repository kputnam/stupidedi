module NavigationMatchers

  def have_structure(structure)
    HaveStructure.new(structure)
  end

  def Ss(*segments)
    if segments.first.is_a?(Hash)
      segments
    else
      segments
    end
  end

  # composite
  def C(*components)
    [:composite, components, nil]
  end

  # reachable and exists
  def S(id, *elements)
    :S.cons(id.cons(elements))
  end

  # reacheable and doesn't exist
  def R(id, *elements)
    :R.cons(id.cons(elements))
  end

  # unreachable
  def X(id, *elements)
    :X.cons(id.cons(elements))
  end

  class HaveStructure
    def initialize(structure)
      @structure = structure
    end

    def matches?(machine)
      navigate(machine, @structure)
    end

    def description
      "have structure"
    end

  private

    def navigate(machine, selectors)
      if selectors.is_a?(Hash)
        selectors.each do |selector, children|
          tag, *selector = selector

          result =
            begin
              machine.find(*selector).tap do |m|
                if children.is_a?(Enumerable) and children.present?
                  navigate(m, children)
                end
              end
            rescue => ex
              Stupidedi::Either.failure(ex)
            end

          begin
            interpret(tag, result, selector)
          rescue Exception
            $!.message << " from #{PP.pp(machine, "")}"
            raise
          end
        end
      elsif selectors.is_a?(Array)
        selectors.each do |selector|
          return navigate(machine, selector) if selector.is_a?(Hash)

          tag, *selector = selector

          result =
            begin
              machine.find(*selector)
            rescue => ex
              Stupidedi::Either.failure(ex)
            end

          begin
            interpret(tag, result, selector)
          rescue Exception
            $!.message << " from #{PP.pp(machine, "")}"
            raise
          end
        end
      end

      true
    end

    def interpret(tag, result, selector)
      case tag
      when :X # Shouldn't be reachable
        result.explain do |e|
          unless e.is_a?(Exception)
            # Didn't find a match, but it was reachable
            raise "#{selector.first} was reachable"
          end
        end.tap do |m|
          # Found a match
          raise "#{selector.first} exists #{PP.pp(m, "")}"
        end
      when :R # Should be reachable, but shouldn't occur
        result.explain do |e|
          if e.is_a?(Exception)
            # Not reachable
            raise e
          end
        end.tap do |m|
          # Found
          raise "#{selector.first} exists #{PP.pp(m, "")}"
        end
      when :S # Should be reachable, and should occur
        result.explain do |e|
          # Not found or not reachable
          if e.is_a?(Exception)
            raise e
          else
            raise e
          end
        end
      end
    end
  end

end
