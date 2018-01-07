local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local Generator = {}
Generator.__index = Generator

function Generator.new(factor, start)
  local self = setmetatable({}, Generator)
  self.start = start
  self.value = start
  self.factor = factor
  return self
end

function Generator:next()
  self.value = (self.value * self.factor) % 2147483647
  return self.value
end

local A, B

for _, line in ipairs(input) do
  local gen, startingValue = line:match("Generator (%w+) starts with (%d+)")
  if gen == "A" then
    A = Generator.new(16807, tonumber(startingValue))
  elseif gen == "B" then
    B = Generator.new(48271, tonumber(startingValue))
  end
end

-- Note: this runs *way* faster with Luajit
local ok, bit = pcall(require, "bit")
local function compare(a, b)
  if ok then
    return bit.band(a, 0xffff) == bit.band(b, 0xffff)
  else
    local aHex = string.format("%x", a)
    local bHex = string.format("%x", b)
    return aHex:sub(-4) == bHex:sub(-4)
  end
end

-- Part 1
local matches = 0
for i=1,40000000 do
  local a = A:next()
  local b = B:next()
  if compare(a, b) then
    matches = matches + 1
  end
end
print(matches)

-- Part 2
A.value, B.value = A.start, B.start
matches = 0
for i=1,5000000 do
  local a, b
  repeat
    a = A:next()
  until a % 4 == 0
  repeat
    b = B:next()
  until b % 8 == 0
  if compare(a, b) then
    matches = matches + 1
  end
end
print(matches)
