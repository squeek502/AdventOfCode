local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local points = {}
for _, line in ipairs(input) do
  local x, y, velocityX, velocityY = line:match("position=<%s*([%d-]+),%s*([%d-]+)> velocity=<%s*([%d-]+),%s*([%d-]+)>")
  x, y, velocityX, velocityY = tonumber(x), tonumber(y), tonumber(velocityX), tonumber(velocityY)
  local point = {
    pos = {x=x, y=y},
    vel = {x=velocityX, y=velocityY}
  }
  table.insert(points, point)
end

local function update(dt)
  local minX, maxX, minY, maxY
  minX, maxX, minY, maxY = nil, nil, nil, nil
  for i,v in ipairs(points) do
    v.pos.x = v.pos.x + v.vel.x * dt
    v.pos.y = v.pos.y + v.vel.y * dt
    if not minX or v.pos.x < minX then minX = v.pos.x end
    if not maxX or v.pos.x > maxX then maxX = v.pos.x end
    if not minY or v.pos.y < minY then minY = v.pos.y end
    if not maxY or v.pos.y > maxY then maxY = v.pos.y end
  end
  return {x=minX, y=minY}, {x=maxX, y=maxY}
end

local function getArea(a, b)
  return math.abs(b.y - a.y) * math.abs(b.x - a.x)
end

-- Find smallest area
local lastArea = math.huge
local i = 1
local min, max
while true do
  min, max = update(1)
  local area = getArea(min, max)
  if area > lastArea then
    -- go back to the last timestep, since it was smallest
    i = i-1
    min, max = update(-1)
    break
  end
  i = i+1
  lastArea = area
end

-- Build lookup table
local pointMap = {}
for _, point in ipairs(points) do
  if not pointMap[point.pos.x] then pointMap[point.pos.x] = {} end
  pointMap[point.pos.x][point.pos.y] = true
end

-- Dump to screen
print('After '..i..' seconds:\n')
for y=min.y,max.y do
  for x=min.x,max.x do
    if pointMap[x] and pointMap[x][y] then
      io.write('#')
    else
      io.write('.')
    end
  end
  io.write('\n')
end
