require "bolt11/version"
require "bech32"
require "bolt11/lnaddr"

module Bolt11

  # 実装済み
  # - human readable part のデコード
  # - timestamp の、5-bit array からint へのデコード
  #
  # TODO
  # - pubkey,
  # - signature,
  # - description,
  # - などの tagged fields のデコード

  module_function

  def lndecode(invoice)
    # hrp, data = Bech32.decode(invoice, 1024) # FIXME: max_length should be maximum number, but this expression should be changed in the future
    hrp, data = Bech32.decode(invoice) # TODO: Temporarily using Fork version of mine, but original gem should be used (will upjjjjjjjjjjjj after gem is updated)
    return nil if hrp.nil?
    # A reader MUST fail if it does not understand the `prefix`.
    return nil unless hrp.start_with?('ln')
    # return nil if data.length < 65 * 8

    lnaddr = LnAddr.new
    lnaddr.pubkey = nil

    lnaddr.currency, lnaddr.amount, lnaddr.multiplier = split_hrp(hrp)
    lnaddr.timestamp = from_base32_to_base10(data[0..6])

    # A reader MUST use the `n` field to validate the signature instead of
    # performing signature recovery if a valid `n` field is provided.

    # return object of LnAddr class so that you can see instance variables
    lnaddr
  end

  def split_hrp(hrp)
    m = hrp[2..-1].match(/^([a-zA-Z]+)(\d*)([munp]?)$/)
    currency, amount, multiplier = nil, nil, nil
    unless m.nil?
      currency = m[1]
      amount = m[2] if m.length > 2
      multiplier = m[3] if m.length > 3
    end
    [currency, amount, multiplier]
  end

  def split_data(data)

  end

  def checksig
    # A reader MUST check that the signature is valid

  end

  def from_base32_to_base10(base32) # the argument should be array
    len = base32.length
    base10 = 0
    base32.each_with_index do |val, i|
        i = len - 1 - i
        base10 += val * (32 ** i)
    end
    base10
  end
end
