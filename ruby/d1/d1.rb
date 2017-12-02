def parse(path)
  file = File.open(path, "r")
  file.read.strip.chars
end

def successive_match_reducer(input)
  input.each_cons(2).reduce(Hash.new(0)) do |acc, (a, b)|
    acc[a.to_i] += 1 if a == b
    acc
  end
end

def halfsies_match_reducer(input)
  half = input.length / 2
  left, right = [input[0, half], input[half, input.length]]
  counts = Hash.new 0

  while left.any? do
    lv, rv = [left.pop, right.pop]
    counts[lv.to_i] += 2 if lv == rv
  end
  
  counts
end

def sum_of_products(list, default = 0)
  list.reduce(default) { |acc, (k, v)| acc += k * v }
end

def p1(input)
  counts = successive_match_reducer(input)
  counts[input.first.to_i] += 1 if input.first == input.last
  counts
end

def p2(input)
  halfsies_match_reducer(input)
end

input = parse("input")
puts "Part 1 answer: #{sum_of_products p1 input}"
puts "Part 2 answer: #{sum_of_products p2 input}"
