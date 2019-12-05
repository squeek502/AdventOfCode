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

function Line.new(x1, y1, x2, y2, steps)
  local self = setmetatable({}, Line)
  self.x1, self.y1 = x1, y1
  self.x2, self.y2 = x2, y2
  -- steps is the number of steps to get to x1, y1
  self.steps = steps
  return self
end

-- http://www-cs.ccny.cuny.edu/~wolberg/capstone/intersection/Intersection%20point%20of%20two%20lines.html
function Line:intersection(other)
  local x21 = self.x2 - self.x1
  local x43 = other.x2 - other.x1
  local y21 = self.y2 - self.y1
  local y43 = other.y2 - other.y1

  local denom = y43 * x21 - x43 * y21
  if denom == 0 then
    return nil
  end
  local ua = (x43 * (self.y1 - other.y1) - y43 * (self.x1 - other.x1)) / denom
  local ub = (x21 * (self.y1 - other.y1) - y21 * (self.x1 - other.x1)) / denom

  if (ua >= 0 and ua <= 1) and (ub >= 0 and ub <= 1) then
    local x = self.x1 + ua * (self.x2 - self.x1)
    local y = self.y1 + ua * (self.y2 - self.y1)
    -- add in the steps to get from x1, y1 to the intersection point on both lines
    local stepsToIntersection = manhattanDist(x, y, self.x1, self.y1) + manhattanDist(x, y, other.x1, other.y1)
    return {x=x, y=y}, self.steps + other.steps + stepsToIntersection
  end
end

local Wire = {}
Wire.__index = Wire

function Wire.new(desc)
  local self = setmetatable({}, Wire)
  self.lines = {}
  local x, y = 0, 0
  local step = 0
  for _, vec in ipairs(split(desc, ',')) do
    local dir, dist = vec:match("([URDL])(%d+)")
    dist = tonumber(dist)
    local x2, y2 = x, y
    if dir == 'U' then y2 = y + dist end
    if dir == 'R' then x2 = x + dist end
    if dir == 'D' then y2 = y - dist end
    if dir == 'L' then x2 = x - dist end
    local line = Line.new(x, y, x2, y2, step)
    table.insert(self.lines, line)
    x, y = x2, y2
    step = step + dist
  end
  return self
end

function Wire:intersections(other)
  local points = {}
  for _, line1 in ipairs(self.lines) do
    for _, line2 in ipairs(other.lines) do
      local point, steps = line1:intersection(line2)
      if point then
        table.insert(points, {point=point, steps=steps})
      end
    end
  end
  -- remove the intersection at the origin point if it exists; its not a
  -- 'real' intersection point for this problem
  if points[1] and points[1].steps == 0 then
    table.remove(points, 1)
  end
  return points
end

local wires = {}
for i, line in ipairs(input) do
  wires[i] = Wire.new(line)
end

local closestDist, closestSteps = math.huge, math.huge
for _, intersection in ipairs(wires[1]:intersections(wires[2])) do
  local dist = manhattanDist(intersection.point.x, intersection.point.y, 0, 0)
  if dist < closestDist then
    closestDist = dist
  end
  if intersection.steps < closestSteps then
    closestSteps = intersection.steps
  end
end

-- Part 1
print(closestDist)
-- Part 2
print(closestSteps)
