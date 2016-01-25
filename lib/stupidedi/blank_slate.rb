# frozen_string_literal: true
module Stupidedi

  BlankSlate =
    if RUBY_VERSION < "1.9"
      require "blankslate"
      ::BlankSlate
    else
      ::BasicObject
    end

end
