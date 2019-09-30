# encoding: utf-8
describe Stupidedi::Reader::Input do
  describe ".build" do
    let(:chars) { "àáâãäåæçèéêëìíîï" }

    context "when string encoding is not valid" do
      specify do
        chars_ = chars.force_encoding("us-ascii")
        expect { Stupidedi::Reader::Input.build(chars_) }.to \
          raise_error(Encoding::InvalidByteSequenceError)
      end
    end

    context "when file encoding is not valid" do
      specify do
        io   = Tempfile.new("input.build", encoding: "utf-8")
        path = Pathname.new(io.path)
        io.write(chars)
        io.close

        expect { Stupidedi::Reader::Input.build(path, encoding: "us-ascii") }.to \
          raise_error(Encoding::InvalidByteSequenceError)
      end
    end
  end
end
