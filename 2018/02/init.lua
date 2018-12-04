local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function letterCounts(str)
  local counts = {}
  for i=1,#str do
    local letter = str:sub(i,i)
    counts[letter] = (counts[letter] or 0) + 1
  end
  return counts
end

local function twoThree(counts)
  local two, three = false, false
  for _, count in pairs(counts) do
    if count == 2 then
      two = true
    elseif count == 3 then
      three = true
    end
  end
  return two, three
end

local twos, threes = 0, 0
for _, id in ipairs(input) do
  local counts = letterCounts(id)
  local two, three = twoThree(counts)
  if two then
    twos = twos + 1
  end
  if three then
    threes = threes + 1
  end
end

print(twos * threes)
