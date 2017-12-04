def valid?(line)
  splits = line.split(/\s+/)
  splits.uniq.length == splits.length
end

[
  "aa bb cc dd ee",
  "aa bb cc dd aa",
  "aa bb cc dd aaa"
].each do |line|
  puts "#{ line } is #{ valid?(line) ? 'valid' : 'invalid' }."
end

puts File.read("input").each_line.select { |l| valid?(l) }.length
