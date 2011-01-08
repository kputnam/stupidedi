module Stupidedi

  module Input
    autoload :AbstractInput,  "stupidedi/input/abstract_input"
    autoload :DelegatedInput, "stupidedi/input/delegated_input"
    autoload :FileInput,      "stupidedi/input/file_input"
  end

  class << Input
    # @return [Input::AbstractInput]
    def from_string(*args)
      from_delegate(*args)
    end

    # @return [Input::AbstractInput]
    def from_array(*args)
      from_delegate(*args)
    end

    # @return [Input::AbstractInput]
    def from_file(io, offset = 0, line = 1, column = 1)
      Input::FileInput.new(io, offset, line, column)
    end

    # @return [Input::AbstractInput]
    def from_delegate(s, offset = 0, line = 1, column = 1)
      Input::DelegatedInput.new(s, offset, line, column)
    end
  end

end
