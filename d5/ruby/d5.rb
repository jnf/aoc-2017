class Stepper
  attr_reader :steps, :instruction, :tape, :config
  def initialize(tape, opts = {})
    @steps = 0
    @instruction = 0
    @tape = tape.split(/\n+/).map &:to_i
    @config = {
      strange: false,
      strange_offset: 3
    }.merge opts
  end

  def walk!
    while instruction < tape.length
      move tape[instruction]
    end

    puts "Walked #{steps} #{config[:strange] ? 'strange' : 'regular'} steps."
    puts "Final instruction is #{instruction} on a #{tape.length} tape."
  end

  private
  def move(distance = 0)
    tape[instruction] += strange_move?(distance) ? -1 : 1
    @steps += 1
    @instruction += distance
  end

  def strange_move?(distance)
    config[:strange] && distance >= config[:strange_offset]
  end
end

test_tape = "0\n3\n0\n1\n-3"
Stepper.new(test_tape).walk!
Stepper.new(test_tape, strange: true).walk!

Stepper.new(File.read("input")).walk!
Stepper.new(File.read("input"), strange: true).walk!
