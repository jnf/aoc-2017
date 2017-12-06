def build_pivots(input, seed = [[2], [4], [6], [8]])
  offset = 1
  while seed.last.last < input
    seed.map! do |list|
      list << list.last + (8 * offset + list.first - 1)
    end
    offset += 1
  end

  [offset, seed.map(&:last)]
end

def p1(input = 0)
  grid_size, pivot_points = build_pivots input
  pivot_distance = pivot_points.map { |pp| (pp - input).abs }.min
  "#{input}: distance to pivot: #{pivot_distance}, distance from center: #{grid_size}, total: #{pivot_distance + grid_size}"
end

INPUT = 312051
[12,23,1024,INPUT].each do |input|
  puts p1 input
end
