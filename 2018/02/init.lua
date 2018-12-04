local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

-- Part 1
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

-- Part 2
local function letterDifferences(a, b)
  if #a ~= #b then return nil end
  local diffs = 0
  local lastDiffPos
  for i=1,#a do
    if a:sub(i,i) ~= b:sub(i,i) then
      diffs = diffs + 1
      lastDiffPos = i
    end
  end
  return diffs, lastDiffPos
end

local first, second, diffpos
for i, a in ipairs(input) do
  for j, b in ipairs(input) do
    if i ~= j then
      local diffs, pos = letterDifferences(a, b)
      if diffs == 1 then
        first, second, diffpos = a, b, pos
        break
      end
    end
  end
  if first ~= nil then
    break
  end
end

local function removePos(str, pos)
  return str:sub(1, pos-1) .. str:sub(pos+1, #str)
end

assert(removePos(first, diffpos) == removePos(second, diffpos))
print(removePos(first, diffpos))
