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

local function getClosestCoord(x, y, coords)
  local minDist, minCoord = math.huge
  local dists = {}
  for _, coord in ipairs(coords) do
    local dist = manhattanDist(x, y, coord.x, coord.y)
    dists[dist] = (dists[dist] or 0) + 1
    if dist < minDist then
      minDist = dist
      minCoord = coord
    end
  end
  -- ensure there's no points tied in distance
  if dists[minDist] > 1 then
    return nil, minDist
  end
  return minCoord, minDist
end

local areas = {}
for x=minX,maxX do
  for y=minY,maxY do
    local coord = getClosestCoord(x, y, coords)
    local isEdge = x == minX or x == maxX or y == minY or y == maxY
    -- any coord that is closest to a point on an edge will have infinite area
    if coord and isEdge then
      areas[coord] = math.huge
    elseif coord and not isEdge and areas[coord] ~= math.huge then
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
