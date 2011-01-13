module Stupidedi
  module FiftyTen

    #
    # Type 3 Technical Reports (TR3s), also known as "HIPAA standards", also
    # known as "Implementation Guides", define more explicit uses of the X12
    # standards.
    #
    # Some TR3s are adopted and put into law by mandatory federal regulations,
    # while others are not.
    #
    #     .---.             .---.
    #     |   | --- 270 --> |   | Eligibility Inquiry (X279)
    #     |   | <-- 271 --- |   | Eligibility Response (X279)
    #     |   |             |   |
    #     |   | --- 278 --> |   | Authorization (X217)
    #     | P | <-- 278 --- |   | Authorization (X217)
    #     | R |             | P |
    #     | O | --- 837 --> | A | Claim (X222, X223, X224)
    #     | V | --- 275 --> | Y | Additional Information (X210)
    #     | I |             | E |
    #     | D | --- 276 --> | R | Claim Status Inquiry (X212)
    #     | E | <-- 277 --- | S | Claim Status Response (X212)
    #     | R |             |   |
    #     | S | <-- 277 --- |   | Request for Additional Information (X213)
    #     |   | --- 275 --> |   | Additional Information (X210)
    #     |   |             |   |
    #     |   | <-- 835 --- |   | Remittance (X221)
    #     '---'             '---'
    #
    module TR3s
    # autoload :Designations,
    #   "stupidedi/5010/tr3s/designations"

      # @group TR3s adopted by HIPAA

      autoload :X212,
        "stupidedi/5010/tr3s/X212_276_and_277"

      autoload :X217,
        "stupidedi/5010/tr3s/X217_278"

      autoload :X218,
        "stupidedi/5010/tr3s/X218_820"

      autoload :X220,
        "stupidedi/5010/tr3s/X220_834"

      autoload :X221,
        "stupidedi/5010/tr3s/X221_835"

      autoload :X222,
        "stupidedi/5010/tr3s/X222_837P"

      autoload :X223,
        "stupidedi/5010/tr3s/X223_837I"

      autoload :X224,
        "stupidedi/5010/tr3s/X224_837D"

      autoload :X279,
        "stupidedi/5010/tr3s/X279_270_and_271"

      # @group TR3s not adopted by HIPAA

      autoload :X230,
        "stupidedi/5010/tr3s/X230_997"

      autoload :X231,
        "stupidedi/5010/tr3s/X231_999"
    end

  end
end
