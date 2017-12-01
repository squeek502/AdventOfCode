local get = function(path)
  local f = io.open(path, "r")
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end
local input = get('input.txt')

local doubleLetters = {}
for i = string.byte('a'), string.byte('z') do
  local c = string.char(i)
  table.insert(doubleLetters, string.rep(c, 2))
end
local illegalStrings = {
  'ab', 'cd', 'pq', 'xy'
}

local function strContains(haystack, needle)
  return haystack:find(needle, 0, true)
end

local function strContainsAny(haystack, needles)
  for _, needle in ipairs(needles) do
    if strContains(haystack, needle) then
      return true
    end
  end
  return false
end

local function iteratorCount(iterator)
  local count = 0
  for _ in iterator do
    count = count + 1
  end
  return count
end

local function isNice(str)
  local numVowels = iteratorCount(str:gmatch('[aeiou]'))
  local hasDoubleLetter = strContainsAny(str, doubleLetters)
  local hasIllegalStrings = strContainsAny(str, illegalStrings)
  return numVowels >= 3 and hasDoubleLetter and not hasIllegalStrings
end

local niceStrings = 0

for _,line in ipairs(input) do
  if isNice(line) then
    niceStrings = niceStrings + 1
  end
end

print("# Nice Strings", niceStrings)
