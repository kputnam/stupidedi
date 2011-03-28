module Stupidedi

  BlankSlate =
    if RUBY_VERSION < "1.9"
      ::BlankSlate
    else
      ::BasicObject
    end

end
