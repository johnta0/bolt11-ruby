class LnAddr
  attr_accessor :currency, :amount, :multiplier, :timestamp,
              :pubkey, :signature, :description, :description_hash

  def initialize
    @currency = ""
    @amount = nil
    @multiplier = nil
    @timestamp = nil
    @pubkey = nil
    @signature = nil
    @description = ""
    @description_hash = nil
  end
end