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
