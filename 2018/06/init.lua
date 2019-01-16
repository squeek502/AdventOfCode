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

local function isFinite(coord, coords)
  local hasLeftBound = false
  for x = coord.x, minX, -1 do
    if coord ~= getClosestCoord(x, coord.y, coords) then
      hasLeftBound = true
    end
  end
  local hasRightBound = false
  for x = coord.x, maxX, 1 do
    if coord ~= getClosestCoord(x, coord.y, coords) then
      hasRightBound = true
    end
  end
  local hasUpBound = false
  for y = coord.y, minY, -1 do
    if coord ~= getClosestCoord(coord.x, y, coords) then
      hasUpBound = true
    end
  end
  local hasDownBound = false
  for y = coord.y, maxY, 1 do
    if coord ~= getClosestCoord(coord.x, y, coords) then
      hasDownBound = true
    end
  end
  return hasLeftBound and hasRightBound and hasUpBound and hasDownBound
  --return coord.x > minX and coord.x < maxX and coord.y > minY and coord.y < maxY
end

local function numClosestInRing(coord, ring)
  local num = 0
  for off=-ring, ring do
    if getClosestCoord(coord.x+off, coord.y+ring, coords) == coord then
      num = num + 1
    end
    if getClosestCoord(coord.x+off, coord.y-ring, coords) == coord then
      num = num + 1
    end
    if math.abs(off) ~= ring then
      if getClosestCoord(coord.x+ring, coord.y+off, coords) == coord then
        num = num + 1
      end
      if getClosestCoord(coord.x-ring, coord.y+off, coords) == coord then
        num = num + 1
      end
    end
  end
  return num
end

local function getArea(coord, coords)
  local ring = 1
  local area = 1
  while true do
    local numClosest = numClosestInRing(coord, ring)
    if numClosest == 0 then
      break
    end
    area = area + numClosest
    ring = ring + 1
  end
  return area
end

local maxArea = -math.huge
for i, coord in ipairs(coords) do
  if isFinite(coord, coords) then
    local area = getArea(coord, coords)
    if area > maxArea then
      maxArea = area
    end
    print(i, coord.x, coord.y, getArea(coord, coords))
  end
end
print(maxArea)
