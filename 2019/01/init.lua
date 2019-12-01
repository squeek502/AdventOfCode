local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function getFuelReq(mass)
  return math.floor(mass/3) - 2
end

assert(getFuelReq(12) == 2)
assert(getFuelReq(14) == 2)
assert(getFuelReq(1969) == 654)
assert(getFuelReq(100756) == 33583)

-- Part 1
local totalFuelReq = 0
for _, line in ipairs(input) do
  local mass = tonumber(line)
  totalFuelReq = totalFuelReq + getFuelReq(mass)
end
print(totalFuelReq)

local function getFuelReqRecursive(mass)
  local fuelReq = getFuelReq(mass)
  if fuelReq <= 0 then
    return 0
  end
  return fuelReq + getFuelReqRecursive(fuelReq)
end

-- Part 2
local totalFuelReq2 = 0
for _, line in ipairs(input) do
  local mass = tonumber(line)
  totalFuelReq2 = totalFuelReq2 + getFuelReqRecursive(mass)
end
print(totalFuelReq2)
