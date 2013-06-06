module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module TransactionSetDefs

          # 004010X... Purchase Order
          autoload :PO850, # Purchase Order
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/PO850"

          # 004010X... Warehouse Shipping Order
          autoload :OW940, # Warehouse Shipping Order
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/OW940"

          # 004010X... Warehouse Stock Transfer
          autoload :AR943, # Warehouse Stock Transfer
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/AR943"

          # 004010X... Warehouse Stock Transfer Receipt Advice
          autoload :RE944, # Warehouse Stock Transfer Receipt Advice
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/RE944"

          # 004010X... Warehouse Shipping Advice
          autoload :SW945, # Warehouse Shipping Advice
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/SW945"

          # 004010X... Functional Acknowledgement
          autoload :FA997, #Functional Acknowledgement
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/FA997"

          # 004010X... Motor Carrier Load Tender
          autoload :SM204, # Motor Carrier Load Tender
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/SM204"
          #
          # 004010X... Transportation Carrier Shipment Status Message
          autoload :QM214,
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/QM214"

          # 004010X... Response to a Load Tender
          autoload :GF990, # Response to a Load Tender
            "stupidedi/versions/functional_groups/004010/transaction_set_defs/GF990"
        end
      end
    end
  end
end
