def uncancel(stream) stream.gsub(/!./, '') end # remove canceled characters
def untrash(stream)  stream.gsub(/<.*?>/, '') end # remove garbage groups

def count_garbage(raw)
  uncancel(raw).scan(/<.*?>/).reduce(0) do |sum, match|
    sum += match.length - 2
  end
end

def count_groups(raw)
  total = 0
  score = 0
  stream = untrash uncancel raw
  while stream.length > 0
    head = stream.slice! 0
    if head == "{"
      score += 1
    elsif head == "}"
      total += score
      score -= 1
    end
  end

  total
end

p count_groups(File.read("input"))
p count_garbage(File.read("input"))
