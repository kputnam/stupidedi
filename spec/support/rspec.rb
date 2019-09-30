RSpec::Expectations.configuration.warn_about_potential_false_positives = true

# Don't let rspec abbreviate result of #inspect (especially for exceptions)
RSpec::Support::ObjectFormatter.
  default_instance.max_formatted_output_length = 1.0/0.0

# Silence warning about redefining `description_separator`
verbose, $VERBOSE = $VERBOSE, nil

# Print this
#   Stupidedi::Parser::Generation: loops, when too many are present, raises an exception
#
# Instead of this
#   Stupidedi::Parser::Generation loops when too many are present raises an exception
module RSpec
  module Core
    module Metadata
      class HashPopulator

        # https://github.com/rspec/rspec-core/blob/v3.8.0/lib/rspec/core/metadata.rb#L171
        def description_separator(parent_part, child_part)
          if is_module?(parent_part)
            if child_part =~ /^(#|::|\.)/
              "".freeze
            else
              ": ".freeze
            end
          else
            ", ".freeze
          end
        end

        def is_module?(parent_part)
          case parent_part
          when Module
            true
          when String
            begin
              Object.const_get(parent_part)
              true
            rescue
              false
            end
          else
            false
          end
        end
      end
    end
  end
end
$VERBOSE = verbose
