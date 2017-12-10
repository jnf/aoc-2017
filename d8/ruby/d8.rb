require 'forwardable'

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

registers = Hash.new { |hash, key| hash[key] = Register.new(key) }
File.read("input").each_line.reduce(registers) do |regs, line|
  id, method, delta, _if, target_id, test_method, check = line.split /\s+/

  target = regs[target_id]
  if target.send(test_method.to_sym, check.to_i)
    regs[id].send(method.to_sym, delta.to_i)
  end

  regs
end

p registers.max_by { |name, reg| reg.value }[1]
