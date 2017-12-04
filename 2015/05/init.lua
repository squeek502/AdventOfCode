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

local illegalStrings = {
  'ab', 'cd', 'pq', 'xy'
}

local function strContains(haystack, needle)
  return haystack:find(needle, 1, true)
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
  local hasDoubleLetter = str:find('(.)%1')
  local hasIllegalStrings = strContainsAny(str, illegalStrings)
  return numVowels >= 3 and hasDoubleLetter and not hasIllegalStrings
end

local function isNice2(str)
  local hasPair = str:find('(..)(.-)%1')
  local hasRepeatedWithSep = str:find('(.).%1')
  return hasPair and hasRepeatedWithSep
end

local niceStrings = 0
local nice2Strings = 0

for _,line in ipairs(input) do
  if isNice(line) then
    niceStrings = niceStrings + 1
  end
  if isNice2(line) then
    nice2Strings = nice2Strings + 1
  end
end

print("# Nice Strings", niceStrings)
print("# Nice2 Strings", nice2Strings)
