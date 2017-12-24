class Array
  def cyclic_select(position, desired)
    self[position, desired] + (self[0, desired - (length - position)] || [])
  end

  def cyclic_replace(start, set)
    if set.length > length - start # wraps
      prewrap = set[0, length - start]
      postwrap = set[length - start, set.length]
      postwrap + self[postwrap.length, length - set.length] + prewrap
    else # doesn't wrap
      self[0, start] + set + self[start + set.length, length]
    end
  end
end

class KnotHash
  attr_reader :config
  def initialize(opts = {})
    @config = {
      suffix: [17, 31, 73, 47, 23],
      rounds: 64,
      range: (0..255).to_a
    }.merge(opts)
  end

  def hash(string = "")
    sparse_hash(string).each_slice(16).map do |set|
      ("00" + set.reduce(&:^).to_s(16))[-2,2]
    end.join
  end

  private
  def sparse_hash(string = "", skip = 0, position = 0)
    lengths = string.chars.map(&:bytes).flatten + config[:suffix]
    hashed = config[:range]
    config[:rounds].times do
      hashed, skip, position = twist(lengths, hashed, skip, position)
    end

    hashed
  end

  def twist(lengths, list, skip = 0, position = 0)
    final_list = lengths.reduce(list) do |list, length|
      # find the subset and reverse it
      set = list.cyclic_select(position, length).reverse

      # slice it back into the list
      new_list = list.cyclic_replace position, set

      # move position forward by length + skip (wrap if necessary)
      position = (position + length + skip) % list.length

      # increment skip
      skip += 1

      # return the new list
      new_list
    end

    [final_list, skip, position]
  end
end

# part 2
knot2 = KnotHash.new()
p knot2.hash "212,254,178,237,2,0,1,54,167,92,117,125,255,61,159,164"

# part 1
p1_lengths = [212, 254, 178, 237, 2, 0, 1, 54, 167, 92, \
              117, 125, 255, 61, 159, 164]
knot1 = KnotHash.new(suffix: [], rounds: 1)
p knot1.send(:twist, p1_lengths, knot1.config[:range]).first.slice(0,2)
