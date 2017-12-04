def parse(path)
  lines = []
  File.read(path).each_line do |line|
    lines.push(line.split(/\s+/).map &:to_i)
  end
  lines
end

def p1(lines)
  lines.reduce(0) { |sum, line| sum += line.minmax.reduce(:-).abs }
end

def p2(lines)
  lines.reduce(0) do |a, x|
    index = 0

    while index < x.length
      y = x[index]
      index += 1
      break if z = (x - [y]).find { |n| y % n == 0}
    end

    a += y/z
  end
end

lines = parse("input")
puts "Part 1 Answer: #{p1 lines}"
puts "Part 2 Answer: #{p2 lines}"
