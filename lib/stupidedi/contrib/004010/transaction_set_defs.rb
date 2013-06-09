module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs

        SegmentReqs = Versions::FunctionalGroups::FortyTen::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::FortyTen::SegmentDefs

        autoload :PO850, # Purchase Order
          "stupidedi/contrib/004010/transaction_set_defs/PO850"

        autoload :OW940, # Warehouse Shipping Order
          "stupidedi/contrib/004010/transaction_set_defs/OW940"

        autoload :AR943, # Warehouse Stock Transfer
          "stupidedi/contrib/004010/transaction_set_defs/AR943"

        autoload :RE944, # Warehouse Stock Transfer Receipt Advice
          "stupidedi/contrib/004010/transaction_set_defs/RE944"

        autoload :SW945, # Warehouse Shipping Advice
          "stupidedi/contrib/004010/transaction_set_defs/SW945"

        autoload :FA997, #Functional Acknowledgement
          "stupidedi/contrib/004010/transaction_set_defs/FA997"

        autoload :SM204, # Motor Carrier Load Tender
          "stupidedi/contrib/004010/transaction_set_defs/SM204"

        autoload :QM214,
          "stupidedi/contrib/004010/transaction_set_defs/QM214"

        autoload :GF990, # Response to a Load Tender
          "stupidedi/contrib/004010/transaction_set_defs/GF990"

      end
    end
  end
end
