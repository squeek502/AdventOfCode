local input = io.open('input.txt'):read('*l')

local gridSerialNumber = tonumber(input)

local function getPowerLevel(x, y, serial)
  if not serial then serial = gridSerialNumber end
  local rackID = x + 10
  local powerLevel = rackID * y
  powerLevel = powerLevel + serial
  powerLevel = powerLevel * rackID
  local strPowerLevel = tostring(powerLevel)
  if #strPowerLevel >= 3 then
    powerLevel = tonumber(strPowerLevel:sub(-3,-3))
  else
    powerLevel = 0
  end
  return powerLevel - 5
end

assert(getPowerLevel(3,5,8) == 4)
assert(getPowerLevel(122,79,57) == -5)
assert(getPowerLevel(217,196,39) == 0)
assert(getPowerLevel(101,153,71) == 4)

local function getPowerLevels(serial)
  local powerLevels = {}
  for x=1,300 do
    powerLevels[x] = {}
    for y=1,300 do
      powerLevels[x][y] = getPowerLevel(x, y, serial)
    end
  end
  return powerLevels
end

local function getOrZero(tbl, x, y)
  return (tbl[x] and tbl[x][y]) or 0
end

-- https://en.wikipedia.org/wiki/Summed-area_table
local function getSummedAreaTable(tbl)
  local summedAreaTable = {}
  for x, yTable in ipairs(tbl) do
    summedAreaTable[x] = {}
    for y, v in ipairs(yTable) do
      summedAreaTable[x][y] = tbl[x][y]
        + getOrZero(summedAreaTable, x, y-1)
        + getOrZero(summedAreaTable, x-1, y)
        - getOrZero(summedAreaTable, x-1, y-1)
    end
  end
  return summedAreaTable
end

local function sumRange(tbl, x1, y1, x2, y2)
  -- sum is calculated with A,B,C points outside of the rectangle
  -- (only point D is inclusive); e.g. with the points
  --
  --  A - - - B
  --  - x x x x
  --  C x x x D
  --
  -- the calculated sum is of the area marked with x's,
  -- so we subtract 1 from x1 and y1 here to make this function's
  -- parameters take the *inclusive* points
  x1, y1 = x1-1, y1-1
  return tbl[x2][y2] - getOrZero(tbl, x2, y1) - getOrZero(tbl, x1, y2) + getOrZero(tbl, x1, y1)
end

-- compute all power levels
local levels = getPowerLevels(gridSerialNumber)
local summedLevels = getSummedAreaTable(levels)

local function getMaxRegionPowerLevel(summedLevels, regionSize)
  local maxCoord = nil
  local maxPowerLevel = -math.huge
  for x=1,300-regionSize-1 do
    for y=1,300-regionSize-1 do
      local regionPowerLevel = sumRange(summedLevels, x, y, x+regionSize-1, y+regionSize-1)
      if regionPowerLevel > maxPowerLevel then
        maxPowerLevel = regionPowerLevel
        maxCoord = {x=x, y=y}
      end
    end
  end
  return maxCoord, maxPowerLevel
end

-- Part 1
local max3x3 = getMaxRegionPowerLevel(summedLevels, 3)
print(max3x3.x .. "," .. max3x3.y)

-- Part 2
local maxCoord, maxSize, maxPowerLevel = nil, nil, -math.huge
for regionSize=1,300 do
  local sizeMaxCoord, sizeMaxPowerLevel = getMaxRegionPowerLevel(summedLevels, regionSize)
  if sizeMaxPowerLevel > maxPowerLevel then
    maxCoord = sizeMaxCoord
    maxSize = regionSize
    maxPowerLevel = sizeMaxPowerLevel
  end
end
print(maxCoord.x .. "," .. maxCoord.y .. "," .. maxSize)
