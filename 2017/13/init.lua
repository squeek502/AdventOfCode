local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local Layer = {}
Layer.__index = Layer

function Layer.new(depth, range)
  local self = setmetatable({}, Layer)
  self.depth = depth
  self.range = range
  self.cur = 1
  self.dir = -1
  return self
end

function Layer:step()
  if self.cur == 1 or self.cur >= self.range then
    self.dir = -self.dir
  end
  self.cur = self.cur + self.dir
end

function Layer:severity()
  if self.cur == 1 then
    return self.depth * self.range
  end
  return 0
end

local firewall = {}
local firewallSize
for _, line in ipairs(input) do
  local depth, range = line:match("(%d+): (%d+)")
  depth, range = tonumber(depth), tonumber(range)
  firewall[depth] = Layer.new(depth, range)
  firewallSize = depth
end

local packetPos = 0
local severity = 0
for picosecond = 0, firewallSize do
  if firewall[packetPos] then
    severity = severity + firewall[packetPos]:severity()
  end
  for i=0,firewallSize do
    if firewall[i] then firewall[i]:step() end
  end
  packetPos = packetPos + 1
end

print(severity)
