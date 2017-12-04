local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function isValid(phrase)
  local seen = {}
  for word in phrase:gmatch("%w+") do
    if seen[word] then
      return false
    end
    seen[word] = true
  end
  return true
end

local function sortString(str)
  local letters = {}
  for letter in str:gmatch('.') do
    table.insert(letters, letter)
  end
  table.sort(letters)
  return table.concat(letters)
end

local function isValid2(phrase)
  local seen = {}
  for word in phrase:gmatch("%w+") do
    local sorted = sortString(word)
    if seen[sorted] then
      return false
    end
    seen[sorted] = true
  end
  return true
end

local valid = 0
local valid2 = 0

for _,line in ipairs(input) do
  if isValid(line) then
    valid = valid+1
    if isValid2(line) then
      valid2 = valid2+1
    end
  end
end

print(valid)
print(valid2)
