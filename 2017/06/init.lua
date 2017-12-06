local input = io.open('input.txt'):read('*l')

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local banks = {}
for count in input:gmatch('%d+') do
  table.insert(banks, tonumber(count))
end

local function serialize(banks)
  return table.concat(banks, ' ')
end

local function findmax(tbl)
  local max, maxi = -math.huge
  for i, v in ipairs(tbl) do
    if v > max then
      max, maxi = v, i
    end
  end
  return maxi, max
end

local function iterate(banks, stopcond)
  local len = #banks
  local cycles = 0
  while not stopcond(banks, cycles) do
    local maxi, max = findmax(banks)
    banks[maxi] = 0
    for offset=1,max do
      local i = modIndex(maxi+offset, len)
      banks[i] = banks[i] + 1
    end
    cycles = cycles + 1
  end
  return cycles
end

-- Part 1
local seen = {}
local stopcond = function(state)
  local s = serialize(state)
  if seen[s] then return true end
  seen[s] = true
end
local cycles = iterate(banks, stopcond)
print(cycles)

-- Part 2
local target = serialize(banks)
stopcond = function(state, cycle)
  return serialize(state) == target and cycle > 0
end
cycles = iterate(banks, stopcond)
print(cycles)
