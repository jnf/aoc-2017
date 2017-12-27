class HexWalk
  PATH = {
    #d   => [x, y, z]
    'n'  => [0, 1, -1],
    's'  => [0, -1, 1],
    'ne' => [1, 0, -1],
    'nw' => [-1, 1, 0],
    'se' => [1, -1, 0],
    'sw' => [-1, 0, 1]
  }

  attr_reader :position, :distance, :home, :max_travel
  def initialize(starting_coordinate = [0, 0, 0])
    @home = starting_coordinate
    @position = starting_coordinate
    @max_travel = 0
  end

  def travel(path = '')
    path.split(/,/).each { |direction| step direction }
    position
  end

  def step(direction)
    x, y, z = position
    a, b, c = PATH.fetch direction, home
    @position = [x + a, y + b, z + c]
    @max_travel = steps_from_home if steps_from_home > max_travel
  end

  def steps_from_home
    position.max
  end

  def reset!
    @position = home
  end
end

#part 1 - tests
hw = HexWalk.new
[
  'ne,ne,ne',
  'ne,ne,sw,sw',
  'ne,ne,s,s',
  'se,sw,se,sw,sw'
].each do |travels|
  p [travels, hw.travel(travels), hw.steps_from_home, hw.max_travel]
  hw.reset!
end

# part 1 & 2
travels = File.read('input').strip
p [hw.travel(travels), hw.steps_from_home, hw.max_travel]
