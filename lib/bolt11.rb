require "bolt11/version"
require "bolt11/lnaddr"
require "bech32"

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
    hrp, data_part = Bech32.decode(invoice, 1024) # FIXME: max_length should be maximum number, but this expression should be changed in the future since it's not DRY enough
    return nil if hrp.nil?
    # A reader MUST fail if it does not understand the `prefix`.
    return nil unless hrp.start_with?('ln')

    data_part_bn = convert_to_binary(data_part)
    return nil if data_part_bn.length < 65 * 8

    lnaddr = LnAddr.new
    lnaddr.pubkey = nil
    lnaddr.currency, lnaddr.amount, lnaddr.multiplier = split_hrp(hrp)
    lnaddr.timestamp = from_base32_to_base10(data_part[0..6])

    tagged_fields = data_part[7..data_part.length - 105] # ∵ 520 bits == 5 bits * 104

    cursor = 0
    while cursor < tagged_fields.length
      type = tagged_fields[cursor]
      data_length = (tagged_fields[cursor + 1] << 5) + (tagged_fields[cursor + 2])
      data = tagged_fields[cursor + 3..cursor + 3 + data_length]

      cursor += 3 + data_length

      case type
        when 1
          if data_length != 52
            lnaddr.unknown_tags.push([type, data_length])
            next
          end
          lnaddr.payment_hash = data
        when 13
          lnaddr.short_description = data
        when 19
          lnaddr.pubkey = data
        when 23
          lnaddr.description = data
        when 6
          lnaddr.expiry = data
        when 24
          # min_final_cltv_expiry
        when 9
          # fallback on-chain address
        when 3
          # line
        else
          p "Unknown type: #{type}"
      end
    end

    # A reader MUST use the `n` field to validate the signature instead of
    # performing signature recovery if a valid `n` field is provided.

    # return object of LnAddr class so that you can see instance variables
    lnaddr
  end

  def split_hrp(hrp)
    currency, amount, multiplier = nil, nil, nil
    m = hrp[2..-1].match(/^([a-zA-Z]+)(\d*)([munp]?)$/)
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

  def from_base32_to_base10(arr)
    len = arr.length
    base10 = 0
    arr.each_with_index do |val, i|
      i = len - 1 - i
      base10 |= val << (5 * i)
    end
    base10
  end

  def convert_to_binary(bech32_arr)
    binary = String.new
    bech32_arr.each {|a| binary += format("%05d", a.to_s(2))}
    binary
  end
end
