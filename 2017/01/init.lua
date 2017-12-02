local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local function arraySum(tbl)
  local sum = 0
  for _, v in ipairs(tbl) do
    sum = sum + v
  end
  return sum
end

local function getMatchingDigits(str, step)
  if step == nil then step = 1 end
  local matching = {}
  for i=1, #str do
    local iNext = modIndex(i+step, #str)
    local cur, nex = tonumber(str:sub(i,i)), tonumber(str:sub(iNext,iNext))
    if cur == nex then
      table.insert(matching, cur)
    end
  end
  return matching
end

-- Part 1
local matching = getMatchingDigits(input)
local sum = arraySum(matching)

print("Sum of matching digits", sum)

-- Part 2
matching = getMatchingDigits(input, #input/2)
sum = arraySum(matching)

print("Sum of matching digits (step=len/2)", sum)
