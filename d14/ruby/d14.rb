require './knot_hash'

def hex_to_binary(hex_string)
  hex_string.chars.map { |c| "%04b" % c.to_i(16) }.join
end

knot = KnotHash.new
puts ((0..127).reduce(0) do |sum, num|
  sum += hex_to_binary(knot.hash("jzgqcdpd-" << num.to_s)).gsub('0', '').length
end)
