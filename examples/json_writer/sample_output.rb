{:interchanges=>
  [{:ISA=>
     [{:I01=>{:name=>"Authorization Information Qualifier", :value=>{:raw=>"00", :description=>"No Authorization Information Present (No Meaningful Information in I02)"}, :type=>:simple}},
      {:I02=>{:name=>"Authorization Information", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
      {:I03=>{:name=>"Security Information Qualifier", :value=>{:raw=>"00", :description=>"No Security Information (No Meaningful Information in I04)"}, :type=>:simple}},
      {:I04=>{:name=>"Security Information", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
      {:I05=>{:name=>"Interchange ID Qualifier", :value=>{:raw=>"ZZ", :description=>"Mutually Defined"}, :type=>:simple}},
      {:I06=>{:name=>"Interchange Sender ID", :value=>{:raw=>"123456789", :description=>nil}, :type=>:simple}},
      {:I05=>{:name=>"Interchange ID Qualifier", :value=>{:raw=>"ZZ", :description=>"Mutually Defined"}, :type=>:simple}},
      {:I07=>{:name=>"Interchange Receiver ID", :value=>{:raw=>"987654321", :description=>nil}, :type=>:simple}},
      {:I08=>{:name=>"Interchange Date", :value=>{:raw=>"XX041117", :description=>nil}, :type=>:simple}},
      {:I09=>{:name=>"Interchange Time", :value=>{:raw=>"1024ss", :description=>nil}, :type=>:simple}},
      {:I65=>{:name=>"Repetition Separator", :value=>{:raw=>"^", :description=>nil}, :type=>:simple}},
      {:I11=>{:name=>"Interchange Control Version Number", :value=>{:raw=>"00501", :description=>"Standards Approved for Publication by ASC X12 Procedures Review Board through October 2003"}, :type=>:simple}},
      {:I12=>{:name=>"Interchange Control Number", :value=>{:raw=>"286", :description=>nil}, :type=>:simple}},
      {:I13=>{:name=>"Acknowledgment Requested", :value=>{:raw=>"0", :description=>"No Interchange Acknowledgment Requested"}, :type=>:simple}},
      {:I14=>{:name=>"Interchange Usage Indicator", :value=>{:raw=>"P", :description=>"Production Data"}, :type=>:simple}},
      {:I15=>{:name=>"Component Element Separator", :value=>{:raw=>":", :description=>nil}, :type=>:simple}}]},
   {:functional_groups=>
     [{:GS=>
        [{:E479=>{:name=>"Functional Identifier Code", :value=>{:raw=>"FA", :description=>"Functional or Implementation Acknowledgment Transaction Sets"}, :type=>:simple}},
         {:E142=>{:name=>"Application's Sender Code", :value=>{:raw=>"RCVR", :description=>nil}, :type=>:simple}},
         {:E124=>{:name=>"Application Receiver's Code", :value=>{:raw=>"SNDR", :description=>nil}, :type=>:simple}},
         {:E373=>{:name=>"Date", :value=>{:raw=>"2004-11-17", :description=>nil}, :type=>:simple}},
         {:E337=>{:name=>"Time", :value=>{:raw=>"1024ss", :description=>nil}, :type=>:simple}},
         {:E28=>{:name=>"Group Control Number", :value=>{:raw=>"287", :description=>nil}, :type=>:simple}},
         {:E455=>{:name=>"Responsible Agency Code", :value=>{:raw=>"X", :description=>"Accredited Standards Committee X12"}, :type=>:simple}},
         {:E480=>{:name=>"Version / Release / Identifier Code", :value=>{:raw=>"005010X231A1", :description=>nil}, :type=>:simple}}]},
      {:transactions=>
        [{"Table 1 - Header"=>
           [{:ST=>
              [{:E143=>{:name=>"Transaction Set Identifier Code", :value=>{:raw=>"999", :description=>"Implementation Acknowledgement"}, :type=>:simple}},
               {:E329=>{:name=>"Transaction Set Control Number", :value=>{:raw=>"2870001", :description=>nil}, :type=>:simple}},
               {:E1705=>{:name=>"Implementation Guide Version Name", :value=>{:raw=>"005010X231", :description=>nil}, :type=>:simple}}]},
            {:AK1=>
              [{:E479=>{:name=>"Functional Identifier Code", :value=>{:raw=>"HC", :description=>"Health Care Claim"}, :type=>:simple}},
               {:E28=>{:name=>"Group Control Number", :value=>{:raw=>"17456", :description=>nil}, :type=>:simple}},
               {:E480=>{:name=>"Version, Release, or Industry Identifier Code", :value=>{:raw=>"004010X098A1", :description=>nil}, :type=>:simple}}]},
            {"2000 TRANSACTION SET RESPONSE HEADER"=>
              [{:AK2=>
                 [{:E143=>{:name=>"Transaction Set Identifier Code", :value=>{:raw=>"837", :description=>"Health Care Claim"}, :type=>:simple}},
                  {:E329=>{:name=>"Transaction Set Control Number", :value=>{:raw=>"0001", :description=>nil}, :type=>:simple}},
                  {:E1705=>{:name=>"Implementation Convention Reference", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]},
               {:IK5=>
                 [{:E717=>{:name=>"Transaction Set Acknowledgement Code", :value=>{:raw=>"A", :description=>"Accepted"}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]}]},
            {"2000 TRANSACTION SET RESPONSE HEADER"=>
              [{:AK2=>
                 [{:E143=>{:name=>"Transaction Set Identifier Code", :value=>{:raw=>"837", :description=>"Health Care Claim"}, :type=>:simple}},
                  {:E329=>{:name=>"Transaction Set Control Number", :value=>{:raw=>"0002", :description=>nil}, :type=>:simple}},
                  {:E1705=>{:name=>"Implementation Convention Reference", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]},
               {"2100 ERROR IDENTIFICATION"=>
                 [{:IK3=>
                    [{:E721=>{:name=>"Segment ID Code", :value=>{:raw=>"CLM", :description=>"CLM"}, :type=>:simple}},
                     {:E719=>{:name=>"Segment Position in Transaction Set", :value=>{:raw=>"22", :description=>nil}, :type=>:simple}},
                     {:E447=>{:name=>"Loop Identifier Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:E620=>{:name=>"Implementation Segment Syntax Error Code", :value=>{:raw=>"8", :description=>"Segment Has Data Element Errors"}, :type=>:simple}}]},
                  {:CTX=>
                    [{:C998=>{:name=>"CONTEXT IDENTIFICATION", :value=>[[{:raw=>"CLM01", :description=>nil}, {:raw=>"123456789", :description=>nil}]], :type=>:repeated}},
                     {:E721=>{:name=>"Segment ID Code", :value=>{:raw=>"", :description=>""}, :type=>:simple}},
                     {:E719=>{:name=>"Segment Position in Transaction Set", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:E447=>{:name=>"Loop Identifier Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:C030=>{:name=>"POSITION IN SEGMENT", :value=>[], :type=>:composite}},
                     {:C999=>{:name=>"REFERENCE IN SEGMENT", :value=>[], :type=>:composite}}]},
                  {"2110 IMPLEMENTATION DATA ELEMENT NOTE"=>
                    [{:IK4=>
                       [{:C030=>{:name=>"POSITION IN SEGMENT", :value=>[{:raw=>"2", :description=>nil}, {:raw=>"", :description=>nil}, {:raw=>"", :description=>nil}], :type=>:composite}},
                        {:E725=>{:name=>"Data Element Reference Number", :value=>{:raw=>"782", :description=>nil}, :type=>:simple}},
                        {:E621=>{:name=>"Implementation Data Element Syntax Error Code", :value=>{:raw=>"1", :description=>"Required Data Element Missing"}, :type=>:simple}},
                        {:E724=>{:name=>"Copy of Bad Data Element", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]}]}]},
               {:IK5=>
                 [{:E717=>{:name=>"Transaction Set Acknowledgement Code", :value=>{:raw=>"R", :description=>"Rejected"}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"5", :description=>"One or More Segments in Error"}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]}]},
            {"2000 TRANSACTION SET RESPONSE HEADER"=>
              [{:AK2=>
                 [{:E143=>{:name=>"Transaction Set Identifier Code", :value=>{:raw=>"837", :description=>"Health Care Claim"}, :type=>:simple}},
                  {:E329=>{:name=>"Transaction Set Control Number", :value=>{:raw=>"0003", :description=>nil}, :type=>:simple}},
                  {:E1705=>{:name=>"Implementation Convention Reference", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]},
               {"2100 ERROR IDENTIFICATION"=>
                 [{:IK3=>
                    [{:E721=>{:name=>"Segment ID Code", :value=>{:raw=>"REF", :description=>"REF"}, :type=>:simple}},
                     {:E719=>{:name=>"Segment Position in Transaction Set", :value=>{:raw=>"57", :description=>nil}, :type=>:simple}},
                     {:E447=>{:name=>"Loop Identifier Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:E620=>{:name=>"Implementation Segment Syntax Error Code", :value=>{:raw=>"3", :description=>"Required Segment Missing"}, :type=>:simple}}]},
                  {:CTX=>
                    [{:C998=>{:name=>"CONTEXT IDENTIFICATION", :value=>[[{:raw=>"SITUATIONAL TRIGGER", :description=>nil}, {:raw=>"", :description=>nil}]], :type=>:repeated}},
                     {:E721=>{:name=>"Segment ID Code", :value=>{:raw=>"CLM", :description=>"CLM"}, :type=>:simple}},
                     {:E719=>{:name=>"Segment Position in Transaction Set", :value=>{:raw=>"43", :description=>nil}, :type=>:simple}},
                     {:E447=>{:name=>"Loop Identifier Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:C030=>{:name=>"POSITION IN SEGMENT", :value=>[{:raw=>"5", :description=>nil}, {:raw=>"3", :description=>nil}, {:raw=>"", :description=>nil}], :type=>:composite}},
                     {:C999=>{:name=>"REFERENCE IN SEGMENT", :value=>[], :type=>:composite}}]},
                  {:CTX=>
                    [{:C998=>{:name=>"CONTEXT IDENTIFICATION", :value=>[[{:raw=>"CLM01", :description=>nil}, {:raw=>"987654321", :description=>nil}]], :type=>:repeated}},
                     {:E721=>{:name=>"Segment ID Code", :value=>{:raw=>"", :description=>""}, :type=>:simple}},
                     {:E719=>{:name=>"Segment Position in Transaction Set", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:E447=>{:name=>"Loop Identifier Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                     {:C030=>{:name=>"POSITION IN SEGMENT", :value=>[], :type=>:composite}},
                     {:C999=>{:name=>"REFERENCE IN SEGMENT", :value=>[], :type=>:composite}}]}]},
               {:IK5=>
                 [{:E717=>{:name=>"Transaction Set Acknowledgement Code", :value=>{:raw=>"R", :description=>"Rejected"}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"5", :description=>"One or More Segments in Error"}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
                  {:E618=>{:name=>"Implementation Transaction Set Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]}]},
            {:AK9=>
              [{:E715=>{:name=>"Functional Group Acknowledgement Code", :value=>{:raw=>"P", :description=>"Partially Accepted, At Least One Transaction Set Was Rejected"}, :type=>:simple}},
               {:E97=>{:name=>"Number of Transaction Sets Included", :value=>{:raw=>"3", :description=>nil}, :type=>:simple}},
               {:E123=>{:name=>"Number of Received Transaction Sets", :value=>{:raw=>"3", :description=>nil}, :type=>:simple}},
               {:E2=>{:name=>"Number of Accepted Transaction Sets", :value=>{:raw=>"1", :description=>nil}, :type=>:simple}},
               {:E716=>{:name=>"Functional Group Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
               {:E716=>{:name=>"Functional Group Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
               {:E716=>{:name=>"Functional Group Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
               {:E716=>{:name=>"Functional Group Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}},
               {:E716=>{:name=>"Functional Group Syntax Error Code", :value=>{:raw=>"", :description=>nil}, :type=>:simple}}]},
            {:SE=>
              [{:E96=>{:name=>"Transaction Segment Count", :value=>{:raw=>"16", :description=>nil}, :type=>:simple}}, {:E329=>{:name=>"Transaction Set Control Number", :value=>{:raw=>"2870001", :description=>nil}, :type=>:simple}}]}]}]},
      {:GE=>[{:E97=>{:name=>"Number of Transaction Sets Included", :value=>{:raw=>"1", :description=>nil}, :type=>:simple}}, {:E28=>{:name=>"Group Control Number", :value=>{:raw=>"287", :description=>nil}, :type=>:simple}}]}]},
   {:IEA=>[{:I16=>{:name=>"Number of Included Functional Groups", :value=>{:raw=>"1", :description=>nil}, :type=>:simple}}, {:I12=>{:name=>"Interchange Control Number", :value=>{:raw=>"286", :description=>nil}, :type=>:simple}}]}]}