module Bolt11
  class LnAddr
    attr_accessor :currency, :amount, :multiplier, :timestamp,
                  :pubkey, :signature, :short_description, :description,
                  :payment_hash, :description_hash, :expiry, :routing_info,
                  :fallback_addr

    def initialize
      @currency = ""
      @amount = nil
      @multiplier = nil
      @timestamp = nil
      @unknown_tags = []
      @payment_hash = nil
      @pubkey = nil
      @signature = nil
      @short_description = nil
      @description = nil
      @description_hash = nil
      @expiry = nil
      @fallback_addr = nil
      @routing_info = []
    end
  end
end