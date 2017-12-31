class Firewall
  attr_reader :scanners, :delay
  attr_accessor :max
  def initialize
    @scanners = Hash.new(0)
    @delay = 0
    @max = 0
  end

  def self.build_from_file(path)
    File.read(path).each_line.reduce(self.new) do |inst, line|
      key, depth = line.strip.split /:\s+/
      inst.scanners[key.to_i] = depth.to_i
      inst.max = key.to_i if key.to_i > inst.max
      inst
    end
  end

  def calculate_severity
    (0..max).reduce(0) do |severity, time|
      severity += caught?(scanners[time], time) ? scanners[time] * time : 0
    end
  end

  def caught?(scanner, time)
    return false if scanner == 0
    (time + delay) % (scanner * 2 - 2) == 0
  end

  def escaped?
    (0..max).none? do |time|
      caught? scanners[time], time
    end
  end

  def find_safe_delay
    until escaped?
      @delay += 1
    end
    delay
  end
end

# part 1 -- tests
# fw = Firewall.build_from_file('test')
# p fw.calculate_severity

# part 1 -- input
# fw = Firewall.build_from_file('input')
# p fw.calculate_severity

# part 2 -- tests
# fw = Firewall.build_from_file('test')
# p fw.find_safe_delay

# part 2 -- input
fw = Firewall.build_from_file('input')
p fw.find_safe_delay
