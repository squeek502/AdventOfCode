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

local function sumRange(tbl, x1, y1, x2, y2)
  local sum = 0
  for x=x1,x2 do
    for y=y1,y2 do
      sum = sum + tbl[x][y]
    end
  end
  return sum
end

-- compute all power levels
local levels = getPowerLevels(gridSerialNumber)

local maxCoord = nil
local maxPowerLevel = -math.huge
local regionSize = 3
for x=1,300-regionSize do
  for y=1,300-regionSize do
    local regionPowerLevel = sumRange(levels, x, y, x+regionSize-1, y+regionSize-1)
    if regionPowerLevel > maxPowerLevel then
      maxPowerLevel = regionPowerLevel
      maxCoord = {x=x, y=y}
    end
  end
end

print(maxCoord.x .. "," .. maxCoord.y)
