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
  local hasDoubleLetter = strContainsAny(str, doubleLetters)
  local hasIllegalStrings = strContainsAny(str, illegalStrings)
  return numVowels >= 3 and hasDoubleLetter and not hasIllegalStrings
end

local function findNonOverlappingLetterPair(str)
  for i=1, #str-1 do
    local pair = str:sub(i, i+1)
    if str:find(pair, i+2, true) then
      return pair
    end
  end
  return nil
end

local function findRepeatedLetterWithSeperator(str)
  for i=1, #str-2 do
    local possible = str:sub(i, i+2)
    if possible:sub(-1) == possible:sub(1,1) then
      return possible
    end
  end
  return nil
end

local function isNice2(str)
  local hasPair = findNonOverlappingLetterPair(str) ~= nil
  local hasRepeatedWithSep = findRepeatedLetterWithSeperator(str) ~= nil
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
