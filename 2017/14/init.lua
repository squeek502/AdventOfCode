local input = io.open('input.txt'):read('*l')
local knothash = require('day10')

local usedCounts = {
  ['0'] = 0, ['1'] = 1, ['2'] = 1, ['3'] = 2,
  ['4'] = 1, ['5'] = 2, ['6'] = 2, ['7'] = 3,
  ['8'] = 1, ['9'] = 2, ['a'] = 2, ['b'] = 3,
  ['c'] = 2, ['d'] = 3, ['e'] = 3, ['f'] = 4,
}

local hexToBin = {
  ['0'] = {0,0,0,0}, ['1'] = {0,0,0,1}, ['2'] = {0,0,1,0}, ['3'] = {0,0,1,1},
  ['4'] = {0,1,0,0}, ['5'] = {0,1,0,1}, ['6'] = {0,1,1,0}, ['7'] = {0,1,1,1},
  ['8'] = {1,0,0,0}, ['9'] = {1,0,0,1}, ['a'] = {1,0,1,0}, ['b'] = {1,0,1,1},
  ['c'] = {1,1,0,0}, ['d'] = {1,1,0,1}, ['e'] = {1,1,1,0}, ['f'] = {1,1,1,1},
}

local disk = {}
for x=0,127 do disk[x] = {} end

local used = 0
for y=0,127 do
  local key = string.format("%s-%d", input, y)
  local hash = knothash(key)
  for x=0,31 do
    local c = hash:sub(x+1,x+1)
    used = used + usedCounts[c]
    for offset, bit in ipairs(hexToBin[c]) do
      disk[x*4+offset-1][y] = bit
    end
  end
end
print(used)

local function fillRegion(region, x, y, regions)
  if disk[x][y] == 0 or regions[x][y] then return end

  regions[x][y] = region
  if x > 0 then fillRegion(region, x-1, y, regions) end
  if x < 127 then fillRegion(region, x+1, y, regions) end
  if y > 0 then fillRegion(region, x, y-1, regions) end
  if y < 127 then fillRegion(region, x, y+1, regions) end
end

local regions = {}
for x=0,127 do regions[x] = {} end

local numRegions = 0
for x=0,127 do
  for y=0,127 do
    if disk[x][y] == 1 and not regions[x][y] then
      numRegions = numRegions + 1
      fillRegion(numRegions, x, y, regions)
    end
  end
end
print(numRegions)
