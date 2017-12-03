local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

-- functions to travel along each edge starting from the bottom right
-- of each ring and going clockwise from there (left, up, right, down)
local spiralEdgeTraversal = {
  function(x, y, dist) return x - dist, y end,
  function(x, y, dist) return x, y + dist end,
  function(x, y, dist) return x + dist, y end,
  function(x, y, dist) return x, y - dist end,
}

-- each ring's max value is in the bottom right of the ring
-- and is an odd square (9, 25, 49, etc)
-- we can get the ring of the number by getting the closest odd square
-- and then traversing the ring from there until we get to the number
local function getCoords(num)
  local sqrt = math.sqrt(num)
  local closestOddSqrt = math.ceil(sqrt)
  if closestOddSqrt % 2 == 0 then closestOddSqrt = closestOddSqrt + 1 end
  local ringMax = closestOddSqrt * closestOddSqrt
  local ring = (closestOddSqrt-1)/2
  local edgeSize = closestOddSqrt
  local distFromMax = ringMax - num
  local distRemaining = distFromMax
  local x, y = ring, -ring
  for i=1,4 do
    if distRemaining <= 0 then break end
    local edgeDist = math.min(edgeSize-1, distRemaining)
    x, y = spiralEdgeTraversal[i](x, y, edgeDist)
    distRemaining = distRemaining - edgeDist
  end
  return x, y
end

local x,y = getCoords(tonumber(input))
print(math.abs(x) + math.abs(y))

-- Part 2
local spiral = {[0]={[0]=1}}

-- returns an iterator that returns x,y coordinates in an infinite spiral
local infiniteSpiral = function()
  local x, y = 0, 0
  local dx, dy = 1, 0
  return function()
    x, y = x + dx, y + dy
    -- if at an appropriate point in the spiral, change direction
    if x == y or (x < 0 and x == -y) or (x > 0 and y-1 == -x) then
      dx, dy = -dy, dx
    end
    return x, y
  end
end

local neighborOffsets = {
  {1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}, {0,-1}, {1,-1}
}

local function getNeighborsSum(x, y)
  local sum = 0
  for _, offset in ipairs(neighborOffsets) do
    local dx, dy = unpack(offset)
    if spiral[x+dx] and spiral[x+dx][y+dy] ~= nil then
      sum = sum + spiral[x+dx][y+dy]
    end
  end
  return sum
end

local biggerSum

for x, y in infiniteSpiral() do
  if not spiral[x] then spiral[x] = {} end
  local sum = getNeighborsSum(x, y)
  spiral[x][y] = sum
  if sum > tonumber(input) then
    biggerSum = sum
    break
  end
end

print(biggerSum)
