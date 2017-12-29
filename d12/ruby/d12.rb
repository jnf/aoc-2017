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
      connections.each { |connection| connection.connect! }

      connectable = connections.reduce([]) do |list, connection|
        list << connection.connections if connection.connected?
      end

      # reject anything that's already connected
      # recurse if there's more to connect
      connectable.flatten!
      connectable.reject!(&:connected?)
      connect!(connectable) unless connectable.empty?
    end

    def self.build_from_file(path)
      File.read(path).each_line.reduce(self.new) do |inst, row|
        inst.add row
      end
    end
  end
end

test_piper = Pipes::Piper.build_from_file('test')
test_piper.connect!
p test_piper.connections.select { |key, conn| conn.connected? }.count

input_piper = Pipes::Piper.build_from_file('input')
input_piper.connect!
p input_piper.connections.select { |key, conn| conn.connected? }.count
