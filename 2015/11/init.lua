local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

local bounds = {a=string.byte('a'), z=string.byte('z')}
local illegalChars = {'i', 'o', 'l'}

local function incrementChar(char)
  local byte, wrapped = string.byte(char)+1, false
  if byte > bounds.z then
    byte = bounds.a
    wrapped = true
  end
  return string.char(byte), wrapped
end

local function incrementPassword(pw)
  local i = -1
  local sub = ""
  repeat
    local c = pw:sub(i,i)
    local inc, wrapped = incrementChar(c)
    sub = inc .. sub
    i = i-1
  until not wrapped
  return pw:sub(1, i) .. sub
end

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

local function findNonOverlappingLetterPairs(str)
  local letterPairs = {}
  local found = {}
  for i=1, #str-1 do
    if str:sub(i,i) == str:sub(i+1,i+1) and not found[str:sub(i,i+1)] then
      local pair = str:sub(i,i+1)
      found[pair] = true
      table.insert(letterPairs, pair)
    end
  end
  return letterPairs
end

local function hasIncreasingSeries(str, len)
  local consecutive = 1
  local last = str:sub(1,1)
  for i=2, #str do
    if string.byte(last)+1 == string.byte(str, i) then
      consecutive = consecutive + 1
    else
      consecutive = 1
    end
    if consecutive >= len then
      return true
    end
    last = str:sub(i,i)
  end
  return false
end

local function isPasswordValid(pw)
  if strContainsAny(pw, illegalChars) then
    return false
  end
  if #findNonOverlappingLetterPairs(pw) < 2 then
    return false
  end
  return hasIncreasingSeries(pw, 3)
end

local function nextValidPassword(pw)
  repeat
    pw = incrementPassword(pw)
  until isPasswordValid(pw)
  return pw
end

local nextPassword = nextValidPassword(input)
print(nextPassword)

nextPassword = nextValidPassword(nextPassword)
print(nextPassword)
