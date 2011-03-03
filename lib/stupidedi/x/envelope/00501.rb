module Stupidedi
  module Interchange

    module FiveOhOne
      autoload :FunctionalGroupHeaderReader,  "stupidedi/interchange/00501/functional_group_header_reader"
      autoload :FunctionalGroupHeader,        "stupidedi/interchange/00501/functional_group_header"
      autoload :InterchangeHeader,            "stupidedi/interchange/00501/interchange_header"
    end

    class << FiveOhOne
      def interchange_header(*args)
        FiveOhOne::InterchangeHeader.new(*args)
      end
    end

  end
end

