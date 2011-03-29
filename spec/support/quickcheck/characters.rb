class QuickCheck
  module Characters
    class << self
      ASCII = (0..127).inject(""){|string, n| string << n }
      ALL   = (0..255).inject(""){|string, n| string << n }

      def of(regexp, set = ALL)
        set.scan(regexp)
      end
    end

    CLASSES = Hash[
      :alnum  => Characters.of(/[[:alnum:]]/),
      :alpha  => Characters.of(/[[:alpha:]]/),
      :blank  => Characters.of(/[[:blank:]]/),
      :cntrl  => Characters.of(/[[:cntrl:]]/),
      :digit  => Characters.of(/[[:digit:]]/),
      :graph  => Characters.of(/[[:graph:]]/),
      :lower  => Characters.of(/[[:lower:]]/),
      :print  => Characters.of(/[[:print:]]/),
      :punct  => Characters.of(/[[:punct:]]/),
      :space  => Characters.of(/[[:space:]]/),
      :upper  => Characters.of(/[[:upper:]]/),
      :xdigit => Characters.of(/[[:xdigit:]]/),
      :ascii  => (class << self; ASCII; end),
      :any    => (class << self; ALL;   end)]
  end
end
