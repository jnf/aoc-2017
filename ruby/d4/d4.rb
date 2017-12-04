def p1_valid?(line)
  splits = line.split(/\s+/)
  splits.uniq.length == splits.length
end

def p2_valid?(line)
  splits = line.split(/\s+/).map { |split| split.chars.sort.join }
  splits.uniq.length == splits.length
end

[
  "aa bb cc dd ee",
  "aa bb cc dd aa",
  "aa bb cc dd aaa"
].each do |line|
  puts "P1: #{ line } is #{ p1_valid?(line) ? 'valid' : 'invalid' }."
end

[
  "abcde fghij",
  "abcde xyz ecdab",
  "a ab abc abd abf abj",
  "iiii oiii ooii oooi oooo",
  "oiii ioii iioi iiio"
].each do |line|
  puts "P2: #{ line } is #{ p2_valid?(line) ? 'valid' : 'invalid' }."
end

puts File.read("input").each_line.select { |l| p1_valid?(l) }.length
puts File.read("input").each_line.select { |l| p2_valid?(l) }.length
