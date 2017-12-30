module Pipes
  BASE_CONNECTOR = 0
  SPLITTER = ' <-> '

  class Connector
    attr_reader :connections, :key
    def initialize(key, connections = [])
      @key = key
      @connections = connections
      @connected = false
    end

    def add_connection(key)
      @connections << key
    end

    def connected?
      @connected
    end

    def connect!
      @connected = true
    end
  end

  class Piper
    attr_reader :connections
    def initialize()
      @connections = Hash.new { |hash, key| hash[key] = Connector.new(key) }
    end

    def add(row, splitter = SPLITTER)
      key, connectors = row.split splitter
      connectors.split(/\D+/).each do |connector|
        connections[connector.to_i].add_connection connections[key.to_i]
      end
      self
    end

    def connect!(connections = [@connections[BASE_CONNECTOR]])
      connections.each &:connect!
      connectable = connections.map(&:connections).flatten.reject(&:connected?)
      connect!(connectable) unless connectable.empty?
    end

    def reject_connected!
      connections.reject! { |_key, conn| conn.connected? }
    end

    def self.build_from_file(path)
      File.read(path).each_line.reduce(self.new) do |inst, row|
        inst.add row
      end
    end
  end
end

# ---part 1---
# test_piper = Pipes::Piper.build_from_file('test')
# test_piper.connect!
# p test_piper.connections.select { |key, conn| conn.connected? }.count

# input_piper = Pipes::Piper.build_from_file('input')
# input_piper.connect!
# p input_piper.connections.select { |key, conn| conn.connected? }.count

# ---part 2---
input_piper = Pipes::Piper.build_from_file('input')
groups = 0

until input_piper.connections.empty?
  _key, connector = input_piper.connections.first
  input_piper.connect!([connector])
  groups += 1
  input_piper.reject_connected!
end

p "Found #{groups} groups."
