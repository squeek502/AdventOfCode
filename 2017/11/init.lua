local input = io.open('input.txt'):read('*l')

--[[
X:   0  1  2  3  4  5  6
------------------------
Y:   0     0     0     0
        0     0     0
     1     1     1     1
        1     1     1
     2     2     2     2
]]--

local function dist(x1, y1, x2, y2)
  local y1d, y2d = y1*2, y2*2
  if x1 % 2 ~= 0 then y1d = y1d+1 end
  if x2 % 2 ~= 0 then y2d = y2d+1 end
  local dx = math.abs(x2 - x1)
  local dyd = math.abs(y2d - y1d)
  return (dx < dyd) and ((dyd - dx) / 2 + dx) or dx
end

local moves = {
  sw = function(x, y) return x-1, y end,
  s = function(x, y) return x, y+1 end,
  se = function(x, y) return x+1, y end,
  nw = function(x, y) return x-1, y+1 end,
  n = function(x, y) return x, y-1 end,
  ne = function(x, y) return x+1, y-1 end,
}

local furthest = -math.huge
local x, y = 1, 1
for move in input:gmatch("(%w+)") do
  x, y = moves[move](x, y)
  local d = dist(1, 1, x, y)
  if d > furthest then
    furthest = d
  end
end
print(dist(1, 1, x, y))
print(furthest)
