module Stupidedi

  module Input
    autoload :AbstractInput,  "stupidedi/input/abstract_input"
    autoload :DelegatedInput, "stupidedi/input/delegated_input"
    autoload :FileInput,      "stupidedi/input/file_input"
  end

  class << Input
    def from_string(*args)
      from_delegate(*args)
    end

    def from_array(*args)
      from_delegate(*args)
    end

    def from_file(io, offset = 0, line = 0, column = 0)
      Input::FileInput.new(io, offset = 0, line = 0, column = 0)
    end

    def from_delegate(s, offset = 0, line = 0, column = 0)
      Input::DelegatedInput.new(s, offset, line, column)
    end
  end

end
