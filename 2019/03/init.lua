local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function manhattanDist(x1, y1, x2, y2)
  return math.abs(x2-x1) + math.abs(y2-y1)
end

local function split(str, delim)
  if not delim then delim = "," end
  local fields = {}
  str:gsub("([^"..delim.."]+)", function(c) fields[#fields+1] = c end)
  return fields
end

local Line = {}
Line.__index = Line

function Line.new(x1, y1, x2, y2)
  local self = setmetatable({}, Line)
  self.x1, self.y1 = x1, y1
  self.x2, self.y2 = x2, y2
  return self
end

function Line:intersection(other)
  local x12 = self.x1 - self.x2
  local x34 = other.x1 - other.x2
  local y12 = self.y1 - self.y2
  local y34 = other.y1 - other.y2

  local denom = y34 * x12 - x34 * y12
  if denom == 0 then
    return nil
  end
  local ua = (-x34 * (self.y1 - other.y1) + y34 * (self.x1 - other.x1)) / denom
  local ub = (-x12 * (self.y1 - other.y1) + y12 * (self.x1 - other.x1)) / denom

  if ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1 then
    local a = self.x1 * self.y2 - self.y1 * self.x2
    local b = other.x1 * other.y2 - other.y1 * other.x2
    local x = (a * x34 - b * x12) / denom
    local y = (a * y34 - b * y12) / denom
    return {x=x, y=y}
  end
end

local Wire = {}
Wire.__index = Wire

function Wire.new(desc)
  local self = setmetatable({}, Wire)
  self.lines = {}
  local x, y = 0, 0
  for _, vec in ipairs(split(desc, ',')) do
    local dir, dist = vec:match("([URDL])(%d+)")
    dist = tonumber(dist)
    local x2, y2 = x, y
    if dir == 'U' then y2 = y + dist end
    if dir == 'R' then x2 = x + dist end
    if dir == 'D' then y2 = y - dist end
    if dir == 'L' then x2 = x - dist end
    local line = Line.new(x, y, x2, y2)
    table.insert(self.lines, line)
    x, y = x2, y2
  end
  return self
end

function Wire:intersections(other)
  local points = {}
  for _, line1 in ipairs(self.lines) do
    for _, line2 in ipairs(other.lines) do
      local point = line1:intersection(line2)
      if point then
        table.insert(points, point)
      end
    end
  end
  -- remove the origin intersection
  if #points > 0 then
    table.remove(points, 1)
  end
  return points
end

local wires = {}
for i, line in ipairs(input) do
  wires[i] = Wire.new(line)
end

local closestPoint, closestDist = nil, math.huge
for _, point in ipairs(wires[1]:intersections(wires[2])) do
  local dist = manhattanDist(point.x, point.y, 0, 0)
  if dist < closestDist then
    closestPoint = point
    closestDist = dist
  end
end

print(closestDist)
