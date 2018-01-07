local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local Layer = {}
Layer.__index = Layer

function Layer.new(depth, range)
  local self = setmetatable({}, Layer)
  self.depth = depth
  self.range = range
  return self
end

function Layer:caught(delay)
  if delay == nil then delay = 0 end
  return (self.depth + delay) % (self.range*2 - 2) == 0
end

function Layer:severity(delay)
  if self:caught(delay) then
    return self.depth * self.range
  end
  return 0
end

local firewall = {}
for _, line in ipairs(input) do
  local depth, range = line:match("(%d+): (%d+)")
  depth, range = tonumber(depth), tonumber(range)
  firewall[depth] = Layer.new(depth, range)
end

-- Part 1
local severity = 0
for _, layer in pairs(firewall) do
  severity = severity + layer:severity()
end
print(severity)

-- Part 2
local delay = 0
while true do
  local caught = false
  for _, layer in pairs(firewall) do
    if layer:caught(delay) then
      caught = true
      break
    end
  end
  if not caught then
    break
  end
  delay = delay + 1
end
print(delay)
