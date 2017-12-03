local get = function(path)
  local f = io.open(path, "r")
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end
local input = get('input.txt')

local Reindeer = {}
Reindeer.__index = Reindeer

function Reindeer.new(speed, time, rest)
  local self = setmetatable({}, Reindeer)
  self.speed = speed
  self.time = time
  self.rest = rest
  self.points = 0
  return self
end

function Reindeer:getCycleLength()
  return self.time + self.rest
end

function Reindeer:getCycleDistance(time)
  if time == nil then time = math.huge end
  return self.speed * math.min(self.time, time)
end

function Reindeer:getTraveled(time)
  local numCycles = math.floor(time / self:getCycleLength())
  local leftoverTime = time % self:getCycleLength()
  return numCycles * self:getCycleDistance() + self:getCycleDistance(leftoverTime)
end

function Reindeer:addPoint()
  self.points = self.points + 1
end

local reindeer = {}

for _, line in ipairs(input) do
  local name, speed, time, rest = line:match("^(%w+) can fly (%d+) km/s for (%d+) seconds, but then must rest for (%d+) seconds")
  reindeer[name] = Reindeer.new(tonumber(speed), tonumber(time), tonumber(rest))
end

-- Part 1
local max = -math.huge
for name, r in pairs(reindeer) do
  local dist = r:getTraveled(2503)
  max = math.max(dist, max)
end
print(max)

-- Part 2
local function getLeader(time)
  local max = -math.huge
  local leader = nil
  for name, r in pairs(reindeer) do
    local dist = r:getTraveled(time)
    if dist > max then
      leader = name
      max = dist
    end
  end
  return leader, max
end

for i=1,2503 do
  local leader = getLeader(i)
  reindeer[leader]:addPoint()
end

max = -math.huge
for name, r in pairs(reindeer) do
  max = math.max(r.points, max)
end
print(max)
