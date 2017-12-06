class D6
  attr_reader :banks, :cycles, :patterns
  def initialize(starting_allocation)
    @banks = prep_banks starting_allocation
    @cycles = 0
    @patterns = {}
    patterns[store banks] = cycles
  end

  def cycle!
    while true
      index, blocks = banks.max_by { |k,v| [v,-k] }
      banks[index] = 0
      blocks.times do |block|
        nb = banks[index + 1] ? index + 1 : 0
        banks[nb] += 1
        index = nb
      end

      @cycles += 1
      new_pattern = store banks
      if patterns[new_pattern]
        return { pattern: new_pattern, start: patterns[new_pattern], end: cycles }
      else
        patterns[new_pattern] = cycles
      end
    end
  end

  private
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
