INPUT = 312051

def build_pivots(n)
  pivots = [[2], [4], [6], [8]]
  o = 1
  while pivots.last.last < n
    pivots.map! do |m|
      m << m.last + (8 * o + m.first - 1)
    end
    o += 1
  end

  pivots
end

def p1(n)
  pivots = build_pivots n
  grid_size = pivots.first.length
  pivot_points = pivots.map { |p| p[grid_size - 1]}
  pivot_distance = pivot_points.map { |p| (p - n).abs }.min
  "#{n}: distance to pivot: #{pivot_distance}, distance from center: #{grid_size}, total: #{pivot_distance + grid_size}"
end

[12,23,1024,INPUT].each do |n|
  puts p1 n
end
