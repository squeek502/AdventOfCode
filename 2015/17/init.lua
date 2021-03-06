local get = function(path)
  local lines = {}
  for line in io.lines(path) do
    table.insert(lines, line)
  end
  return lines
end
local input = get('input.txt')

local sizes = {}

for _, line in ipairs(input) do
  table.insert(sizes, tonumber(line))
end

-- https://rosettacode.org/wiki/Power_set#Lua
local function powerset(s, start)
  start = start or 1
  if(start > #s) then return {{}} end
  local ret = powerset(s, start + 1)
  for i = 1, #ret do
    ret[#ret + 1] = {s[start], unpack(ret[i])}
  end
  return ret
end

local function filterCombos(combos, target)
  local valid = {}
  for i,combo in ipairs(combos) do
    local sum = 0
    for _,size in ipairs(combo) do
      sum = sum + size
    end
    if sum == target then
      table.insert(valid, combo)
    end
  end
  return valid
end

local combos = powerset(sizes)
combos = filterCombos(combos, 150)
print(#combos)

local function filterCombosForMinContainers(combos)
  local min = math.huge
  for i,combo in ipairs(combos) do
    min = math.min(min, #combo)
  end
  local valid = {}
  for i,combo in ipairs(combos) do
    if #combo == min then
      table.insert(valid, combo)
    end
  end
  return valid
end

combos = filterCombosForMinContainers(combos)
print(#combos)
