require 'forwardable'
class Processor
  attr_reader :registers, :max_value
  def initialize
    @registers = Hash.new { |hash, key| hash[key] = Register.new(key) }
    @max_value = 0
  end

  def process!(path)
    File.read(path).each_line.reduce(registers) do |regs, line|
      id, method, delta, _if, target_id, test_method, check = line.split /\s+/

      if regs[target_id].send(test_method.to_sym, check.to_i)
        regs[id].send(method.to_sym, delta.to_i)
        @max_value = regs[id].value if regs[id].value > max_value
      end

      regs
    end
  end

  def from_file(path)
    File.read(path).each_line
  end
end

class Register
  extend Forwardable
  attr_reader :id, :value
  def_delegators :@value, :<, :>, :<=, :>=, :==, :!=

  def initialize(id, value = 0)
    @id = id
    @value = value
  end

  def inc(val) @value += val end
  def dec(val) @value -= val end

end

processor = Processor.new
processor.process! "input"
p processor.registers.max_by { |name, reg| reg.value }[1]
p processor.max_value
