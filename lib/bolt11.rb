require "bolt11/version"

module Bolt11
  def lndecode(invoice)
    # hrp, data = Bech32.decode(invoice, 1024) # FIXME: max_length should be maximum number, but this expression should be changed in the future
    hrp, data = Bech32.decode(invoice) # TODO: Temporarily using Fork version of mine, but original gem should be used (will update after gem is updated)
    return nil if hrp.nil?
    # A reader MUST fail if it does not understand the `prefix`.
    return nil unless hrp.start_with?('ln')
    return nil if data.length < 65 * 8

    currency, amount, multiplier = split_hrp(hrp)
    data = data[35]

    # BOLT #11:
    #
    # A reader MUST skip over unknown fields, an `f` field with unknown
    # `version`, or a `p`, `h`, or `n` field which does not have
    # `data_length` 52, 52, or 53 respectively.
    # BOLT #11:
    #
    # * `r` (3): `data_length` variable.  One or more entries
    # containing extra routing information for a private route;
    # there may be more than one `r` field, too.
    #    * `pubkey` (264 bits)
    #    * `short_channel_id` (64 bits)
    #    * `feebase` (32 bits, big-endian)
    #    * `feerate` (32 bits, big-endian)
    #    * `cltv_expiry_delta` (16 bits, big-endian)

    # BOLT #11:
    #
    # A reader MUST check that the `signature` is valid (see the `n` tagged
    # field specified below).

    # BOLT #11:
    #
    # A reader MUST use the `n` field to validate the signature instead of
    # performing signature recovery if a valid `n` field is provided.

  end

  def split_hrp(hrp)
    m = hrp[2..-1].match(/^([a-zA-Z]+)(\d*)([munp]?)$/)

    unless m.nil?
      currency = m[1]
      amount = m[2]
      multiplier = m[3] if m.length > 3
      # BOLT #11:
      #
      # A reader SHOULD indicate if amount is unspecified, otherwise it MUST
      # multiply `amount` by the `multiplier` value (if any) to derive the
      # amount required for payment.
    end
    {currency: currency, amount: amount, multiplier: multiplier}
  end

  def split_data(data)

  end

  def checksig
  end
end
