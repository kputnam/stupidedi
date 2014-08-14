class Stupidedi
  module Editor

    class FortyTenEd
      module N4

        def critique_n4(n4, acc)
          edit(:N4) do
            usa_canada =
              n4.element(2).select(&:is_present?).defined? ||
              n4.element(4).select(&:blankness?).defined?   ||
              n4.element(4).select{|e| e.node == "US" }.defined? ||
              n4.element(7).select(&:blankness?).defined?

            # State or Province Code
            n4.element(2).tap do |e|
              if usa_canada
                if e.node.blankness? and e.node.situational?
                  # Required
                end
              else
                if e.node.is_present? and e.node.situational?
                  # Forbidden
                end
              end
            end

            # Postal Code
            n4.element(3).tap do |e|
              if usa_canada and e.node =~ /^(\d{1,8}|\d{10,})$/
                acc.warn(e, "must be 9-digits for usa")
              end
            end

            # Country Code
            n4.element(4).tap do |e|
              if usa_canada
                if e.node.is_present? and e.node.situational?
                  # Forbidden
                end
              else
                # Country codes 2-digit from ISO 3166
              end
            end

            # Country Subdivision Code
          # n4.element(7).tap do |e|
          #   if usa_canada
          #     if e.node.is_present? and e.node.situational?
          #       # Forbidden
          #     end
          #   else
          #     # Country subdivision codes from ISO 3166
          #   end
          # end
          end
        end

      end
    end

  end
end
