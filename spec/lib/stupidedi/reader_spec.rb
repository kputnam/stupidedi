describe "Stupidedi::Reader" do
  describe ".is_basic_character?(c)" do
    def is_basic?(c)
      Stupidedi::Reader.is_basic_character?(c)
    end

    it "excludes extended characters" do
      b = Stupidedi::Reader.basic_characters
      e = Stupidedi::Reader.extended_characters
      expect(b - (b - e)).to be_empty
    end

    it "excludes control characters" do
      b = Stupidedi::Reader.basic_characters
      c = Stupidedi::Reader.control_characters
      expect(b - (b - c)).to be_empty
    end

    it "includes uppercase letters" do
      ("A".."Z").each{|c| expect(is_basic?(c)).to be true }
    end

    it "includes digits 0-9" do
      expect(is_basic?("0")).to be true
      expect(is_basic?("1")).to be true
      expect(is_basic?("2")).to be true
      expect(is_basic?("3")).to be true
      expect(is_basic?("4")).to be true
      expect(is_basic?("5")).to be true
      expect(is_basic?("6")).to be true
      expect(is_basic?("7")).to be true
      expect(is_basic?("8")).to be true
      expect(is_basic?("9")).to be true
    end

    it "includes special characters" do
      expect(is_basic?("!")).to be true
      expect(is_basic?('"')).to be true
      expect(is_basic?("&")).to be true
      expect(is_basic?("'")).to be true
      expect(is_basic?("(")).to be true
      expect(is_basic?(")")).to be true
      expect(is_basic?("*")).to be true
      expect(is_basic?("+")).to be true
      expect(is_basic?(",")).to be true
      expect(is_basic?("-")).to be true
      expect(is_basic?(".")).to be true
      expect(is_basic?("/")).to be true
      expect(is_basic?(":")).to be true
      expect(is_basic?(";")).to be true
      expect(is_basic?("?")).to be true
      expect(is_basic?("=")).to be true
    end

    it "includes the space character" do
      expect(is_basic?(" ")).to be true
    end
  end

  describe ".is_extended_character?(c)" do
    def is_extended?(c)
      Stupidedi::Reader.is_extended_character?(c)
    end

    it "excludes basic characters" do
      e = Stupidedi::Reader.extended_characters
      b = Stupidedi::Reader.basic_characters
      expect(e - (e - b)).to be_empty
    end

    it "excludes control characters" do
      e = Stupidedi::Reader.extended_characters
      c = Stupidedi::Reader.control_characters
      expect(e - (e - c)).to be_empty
    end

    it "includes lowercase letters" do
      ("a".."z").each{|c| expect(is_extended?(c)).to be true }
    end

    it "includes other special characters" do
      expect(is_extended?("%")).to  be true
      expect(is_extended?("@")).to  be true
      expect(is_extended?("[")).to  be true
      expect(is_extended?("]")).to  be true
      expect(is_extended?("_")).to  be true
      expect(is_extended?("{")).to  be true
      expect(is_extended?("}")).to  be true
      expect(is_extended?("|")).to  be true
      expect(is_extended?("<")).to  be true
      expect(is_extended?(">")).to  be true
      expect(is_extended?("~")).to  be true
      expect(is_extended?("^")).to  be true
      expect(is_extended?("`")).to  be true
      expect(is_extended?("\\")).to be true
    end

    it "includes national characters" do
      expect(is_extended?("#")).to be true
      expect(is_extended?("$")).to be true
    end

    it "includes select language characters" do
      expect(is_extended?("À")).to be true
      expect(is_extended?("Á")).to be true
      expect(is_extended?("Â")).to be true
      expect(is_extended?("Ä")).to be true
      expect(is_extended?("à")).to be true
      expect(is_extended?("á")).to be true
      expect(is_extended?("â")).to be true
      expect(is_extended?("ä")).to be true
      expect(is_extended?("È")).to be true
      expect(is_extended?("É")).to be true
      expect(is_extended?("Ê")).to be true
      expect(is_extended?("è")).to be true
      expect(is_extended?("é")).to be true
      expect(is_extended?("ê")).to be true
      expect(is_extended?("ë")).to be true
      expect(is_extended?("Ì")).to be true
      expect(is_extended?("Í")).to be true
      expect(is_extended?("Î")).to be true
      expect(is_extended?("ì")).to be true
      expect(is_extended?("í")).to be true
      expect(is_extended?("î")).to be true
      expect(is_extended?("ï")).to be true
      expect(is_extended?("Ò")).to be true
      expect(is_extended?("Ó")).to be true
      expect(is_extended?("Ô")).to be true
      expect(is_extended?("Ö")).to be true
      expect(is_extended?("ò")).to be true
      expect(is_extended?("ó")).to be true
      expect(is_extended?("ô")).to be true
      expect(is_extended?("ö")).to be true
      expect(is_extended?("Ù")).to be true
      expect(is_extended?("Ú")).to be true
      expect(is_extended?("Û")).to be true
      expect(is_extended?("Ü")).to be true
      expect(is_extended?("ù")).to be true
      expect(is_extended?("ú")).to be true
      expect(is_extended?("û")).to be true
      expect(is_extended?("ü")).to be true
      expect(is_extended?("Ç")).to be true
      expect(is_extended?("ç")).to be true
      expect(is_extended?("Ñ")).to be true
      expect(is_extended?("ñ")).to be true
      expect(is_extended?("¿")).to be true
      expect(is_extended?("¡")).to be true
    end
  end

  describe ".is_control_character?" do
    it "excludes basic characters" do
      c = Stupidedi::Reader.control_characters
      b = Stupidedi::Reader.basic_characters
      expect(c - (c - b)).to be_empty
    end

    it "excludes extended characters" do
      c = Stupidedi::Reader.control_characters
      e = Stupidedi::Reader.extended_characters
      expect(c - (c - e)).to be_empty
    end
  end
end
