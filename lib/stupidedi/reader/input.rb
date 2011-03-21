module Stupidedi
  module Reader

    module Input
    end

    class << Input
      #########################################################################
      # @group Constructor Methods

      # @return [Input]
      def build(o, *args)
        case o
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
