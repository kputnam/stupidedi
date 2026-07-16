describe Stupidedi::Config::TransactionSetConfig do
  describe "#register" do
    it "warns before replacing an existing transaction set" do
      config = described_class.new
      original = Object.new
      replacement = Object.new

      expect do
        config.register("004010", "SM", "204") { original }
      end.not_to output.to_stderr

      expect do
        config.register("004010", "SM", "204") { replacement }
      end.to output(
        "Transaction set [\"004010\", \"SM\", \"204\"] is already registered; replacing it\n"
      ).to_stderr

      expect(config.at("004010", "SM", "204")).to be(replacement)
    end
  end
end
