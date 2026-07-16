# frozen_string_literal: true
require "spec_helper"

describe "Interleaved segments and loops" do
  let(:config) do
    Stupidedi::Config.hipaa.customize do |c|
      c.transaction_set.register("005010", "SO", "317") do
        Stupidedi::TransactionSets::FiftyTen::Standards::SO317
      end
    end
  end

  context "317 Delivery/Pickup Order" do
    it "loads the transaction set schema without raising errors" do
      # The 317 has: Loop N1 -> G62, N9, TD5 (segments) -> Loop L0
      # This demonstrates interleaved segments and loops
      expect {
        Stupidedi::TransactionSets::FiftyTen::Standards::SO317
      }.not_to raise_error
    end

    it "parses interleaved structure correctly" do
      # The 317 has: Loop N1 -> G62, N9, TD5 (segments) -> Loop L0
      # This tests the interleaved pattern: segments appearing between loops
      edi = <<~EDI.gsub("\n", "~")
        ISA*00*          *00*          *ZZ*SENDER         *ZZ*RECEIVER       *230101*1200*U*00501*000000001*0*P*>
        GS*SO*SENDER*RECEIVER*20230101*1200*1*X*005010
        ST*317*0001
        N1*SH*Shipper Name
        N3*123 Main St
        N4*Chicago*IL*60601
        G62*10*20230115
        N9*BM*BOL123
        TD5*B*2*SCAC*M*Route Info
        L0*1*100*FR*1000*L
        SE*10*0001
        GE*1*1
        IEA*1*000000001
      EDI

      machine, result = Stupidedi::Parser.build(config).read(Stupidedi::Reader.build(edi))

      # Parsing should succeed
      if result.fatal?
        result.explain { |msg| fail "Parse error: #{msg}" }
      end
      expect(result).to be_success

      # Verify the machine contains parsed data
      expect(machine).not_to be_nil

      # The key test: parsing should complete without errors despite the
      # interleaved structure (G62, N9, TD5 between Loop N1 and Loop L0)
    end

    it "parses multiple iterations of interleaved loops" do
      # Test with multiple N1 loops and multiple L0 loops
      edi = <<~EDI.gsub("\n", "~")
        ISA*00*          *00*          *ZZ*SENDER         *ZZ*RECEIVER       *230101*1200*U*00501*000000001*0*P*>
        GS*SO*SENDER*RECEIVER*20230101*1200*1*X*005010
        ST*317*0001
        N1*SH*Shipper Name
        N4*Chicago*IL*60601
        N1*CN*Consignee Name
        N4*New York*NY*10001
        G62*10*20230115
        N9*BM*BOL123
        TD5*B*2*SCAC*M*Route Info
        L0*1*100*FR*1000*L
        L0*2*200*FR*2000*L
        SE*12*0001
        GE*1*1
        IEA*1*000000001
      EDI

      machine, result = Stupidedi::Parser.build(config).read(Stupidedi::Reader.build(edi))

      if result.fatal?
        result.explain { |msg| fail "Parse error: #{msg}" }
      end
      expect(result).to be_success
    end
  end
end
