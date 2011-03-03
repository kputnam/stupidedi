module Stupidedi
  module Guides
    module FiftyTen

      module GuideBuilder
      end

      class << GuideBuilder
        def build(transaction_set_def, *table_defs)
          transaction_set_def.copy(:table_defs => table_defs)
        end

        def Values(*values)
          [:Values, values]
        end

        def MaxLength(n)
          [:MaxLength, n]
        end

        def MaxPrecision(n)
          [:MaxPrecision, n]
        end

        def Element(requirement, name, *args)
          [:Element, requirement, name, args]
        end

        # @return [SegmentUse]
        def Segment(position, segment_def, name, requirement, repeat_count, *elements)
          unless elements.length == segment_def.element_uses.length
            raise Exceptions::InvalidSchemaError,
              "Segment #{segment_def.id} has #{segment_def.element_uses.length}" <<
              " elements but #{elements.length} arguments were specified"
          end

          element_index = "00"
          element_uses  = elements.zip(segment_def.element_uses).map do |e, u|
            e_tag, e_requirement, e_name, e_arguments = e
            element_index.succ!

            unless e_tag == :Element
              raise Exceptions::InvalidSchemaError,
                "Given argument for #{segment_def.id}#{element_index} must be Element(...)"
            end

            if u.composite?
              repeat_count, e_arguments = e_arguments.partition{|x| x.is_a?(Schema::RepeatCount) }

              changes = Hash.new
              changes[:requirement] = e_requirement

              if repeat_count.length == 1
                changes[:repeat_count] = repeat_count.head
              elsif repeat_count.length > 1
                raise Exceptions::InvalidSchemaError,
                  "More than one RepeatCount was specified"
              end

              unless e_requirement.forbidden?
                unless e_arguments.length == u.definition.element_uses.length
                  raise Exceptions::InvalidSchemaError,
                    "Composite element #{u.definition.id} at #{segment_def.id}" <<
                    "#{element_index} has #{u.definition.element_uses.length}" <<
                    " component elements but #{e_arguments.length} were given"
                end

                # ComponentElementUses
                component_index = "00"
                component_uses  = e_arguments.zip(u.definition.element_uses).map do |e, c|
                  c_tag, c_requirement, c_name, c_arguments = e
                  component_index.succ!

                  unless c_tag == :Element
                    raise Exceptions::InvalidSchemaError,
                      "Given argument for #{segment_def.id}#{element_index}" <<
                      "-#{component_index} must be Element(...)"
                  end

                  mod_element(c, c_requirement, c_name, c_arguments)
                end

                changes[:definition] = u.definition.copy(:name         => e_name,
                                                         :element_uses => component_uses)
              else
                changes[:definition] = u.definition.copy(:name => e_name)
              end

              u.copy(changes)
            else
              mod_element(u, e_requirement, e_name, e_arguments)
            end
          end

          segment_def.copy(:name => name).
            copy(:element_uses => element_uses).
            use(position, requirement, repeat_count)
        end

        def mod_element(element_use, requirement, name, arguments)
          unless requirement.is_a?(Schema::ElementReq)
            raise ArgumentError,
              "First argument to Element must be a Schema::ElementReq but got #{requirement.inspect}"
          end

          unless name.is_a?(String)
            raise ArgumentError,
              "Element name must be a String"
          end

          changes = Hash.new
          changes[:requirement] = requirement
          changes[:definition] = element_use.definition.copy(:name => name)

          repeat_count = arguments.select{|x| x.is_a?(Schema::RepeatCount) }

          if repeat_count.length == 1
            changes[:repeat_count] = repeat_count.head
          elsif repeat_count.length > 1
            raise ArgumentError, "RepeatCount specified more than once for this Element"
          end

          allowed_values = arguments.select{|x| x.is_a?(Array) and x.head == :Values }

          if allowed_values.length == 1
            changes[:allowed_values] = element_use.allowed_values.replace(allowed_values.head.last)
          elsif allowed_values.length > 1
            raise ArgumentError, "Values specified more than once for this Element"
          end

          max_length = arguments.select{|x| x.is_a?(Array) and x.head == :MaxLength }

          if max_length.length == 1
            changes[:max_length] = max_length.head
          elsif max_length.length > 1
            raise ArgumentError, "MaxLength specified more than once for this Element"
          end

          element_use.copy(changes)
        end
      end

    end
  end
end
