local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local coords = {}
local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
for _,line in ipairs(input) do
  local x, y = line:match("(%d+), (%d+)")
  x, y = tonumber(x), tonumber(y)
  table.insert(coords, {x=x, y=y})
  if x < minX then minX = x end
  if x > maxX then maxX = x end
  if y < minY then minY = y end
  if y > maxY then maxY = y end
end

local function manhattanDist(x1, y1, x2, y2)
  return math.abs(x2-x1) + math.abs(y2-y1)
end

local function getDistances(x, y, coords)
  local dists = {}
  for _, coord in ipairs(coords) do
    dists[coord] = manhattanDist(x, y, coord.x, coord.y)
  end
  return dists
end

local function getClosestCoord(x, y, coords)
  local dists = getDistances(x, y, coords)
  local minDist, minCoord = math.huge
  for coord, dist in pairs(dists) do
    if dist < minDist then
      minDist = dist
      minCoord = coord
    end
  end
  -- ensure there's no points tied in distance
  for coord, dist in pairs(dists) do
    if dist == minDist and coord ~= minCoord then
      return nil, minDist
    end
  end
  return minCoord, minDist
end

-- Part 1
local areas = {}
for x=minX,maxX do
  for y=minY,maxY do
    local coord = getClosestCoord(x, y, coords)
    local isEdge = x == minX or x == maxX or y == minY or y == maxY
    -- any coord that is closest to a point on an edge will have infinite area
    if coord and isEdge then
      areas[coord] = math.huge
    elseif coord and areas[coord] ~= math.huge then
      areas[coord] = (areas[coord] or 0) + 1
    end
  end
end

local maxArea = -math.huge
for coord, area in pairs(areas) do
  if area ~= math.huge and area > maxArea then
    maxArea = area
  end
end
print(maxArea)

-- Part 2
local regionSize = 0
for x=minX,maxX do
  for y=minY,maxY do
    local dists = getDistances(x, y, coords)
    local sum = 0
    for _, dist in pairs(dists) do
      sum = sum + dist
    end
    if sum < 10000 then
      regionSize = regionSize + 1
    end
  end
end
print(regionSize)
