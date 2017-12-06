class D6
  attr_reader :banks, :cycles, :patterns
  def initialize(starting_allocation)
    @banks = prep_banks starting_allocation
    @cycles = 0
    @patterns = {}
    patterns[store banks] = {
      appearances: 1,
      cycle: 0
    }
  end

  def cycle!
    index, blocks = pick_starting_bank

    banks[index] = 0
    blocks.times do |block|
      nb = next_bank index
      banks[nb] += 1
      index = nb
    end

    @cycles += 1
    new_pattern = store banks
    stats = patterns.fetch(new_pattern, { appearances: 0, cycle: cycles })
    appearances = stats[:appearances] + 1

    if appearances > 1
      stats.merge({ last_cycle: cycles })
    else
      patterns[new_pattern] = {
        appearances: appearances,
        cycle: cycles
      }
      cycle!
    end
  end

  private
  def pick_starting_bank
    banks.max_by { |k,v| [v,-k] }
  end

  def next_bank(index)
    banks[index + 1] ? index + 1 : 0
  end

  def prep_banks(banks)
    banks.each_with_index.reduce({}) { |acc, (v, i)| acc[i] = v; acc }
  end

  def store(banks)
    banks.values.join '-'
  end
end

test_input = [0, 2, 7, 0]
puts D6.new(test_input).cycle!

input = [11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11]
puts D6.new(input).cycle!
