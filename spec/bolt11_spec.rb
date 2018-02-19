RSpec.describe Bolt11 do
  it "has a version number" do
    expect(Bolt11::VERSION).not_to be nil
  end

  describe "#lndecode" do

    invoice = "lnbc2500u1pvjluezpp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqypqdpquwpc4curk03c9wlrswe78q4eyqc7d8d0xqzpuyk0sg5g70me25alkluzd2x62aysf2pyy8edtjeevuv4p2d5p76r4zkmneet7uvyakky2zr4cusd45tftc9c5fh0nnqpnl2jfll544esqchsrny"
    addr = Bolt11.lndecode(invoice)

    it "returns the object of LnAddr class" do
      expect(addr.class).to eq LnAddr
    end

    it "has some instance variables" do
      expect(addr.currency).not_to be nil
      expect(addr.amount).not_to be nil
      expect(addr.timestamp).not_to be nil
      # expect(addr.payment_hash).not_to be nil
      # expect(addr.signature).not_to be nil
    end
  end
end
