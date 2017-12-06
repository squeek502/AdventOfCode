local input = io.open('input.txt'):read('*l')

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local banks = {}
local i = 1
for count in input:gmatch('%d+') do
  banks[i] = tonumber(count)
  i = i+1
end

local function serialize(banks)
  local str = ""
  for i=1,#banks do
    str = str .. i..':' .. banks[i] .. ' '
  end
  return str
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

local seen = {}
local len = #banks
local cycles = 0
while not seen[serialize(banks)] do
  seen[serialize(banks)] = true
  local maxi, max = findmax(banks)
  local blocks = max
  banks[maxi] = 0
  for offset=1,blocks do
    local i = modIndex(maxi+offset, len)
    banks[i] = banks[i] + 1
  end
  cycles = cycles + 1
end

print(cycles)

