# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Reader

    module Input
    end

    class << Input
      # @group Constructors
      #########################################################################

      # @return [Input]
      def build(o, *args)
        case o
        when AbstractInput
          o
        when IO
          FileInput.new(o, *args)
        when String, Array
          DelegatedInput.new(o, *args)
        else
          raise TypeError
        end
      end

      # @endgroup
      #########################################################################
    end

  end
end
