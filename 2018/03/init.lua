local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function mapArrayInPlace(tbl, fn)
  for i, v in ipairs(tbl) do
    tbl[i] = fn(v)
  end
  return tbl
end

local function addClaim(claims, x, y)
  if claims[x] == nil then claims[x] = {} end
  claims[x][y] = (claims[x][y] or 0) + 1
end

local claims = {}
for _, line in ipairs(input) do
  local id, x, y, w, h = unpack(mapArrayInPlace({line:match("#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")}, tonumber))
  for i=x,x+w-1 do
    for j=y,y+h-1 do
      addClaim(claims, i, j)
    end
  end
end

local numOverlapping = 0
for x, col in pairs(claims) do
  for y, num in pairs(col) do
    if num >= 2 then
      numOverlapping = numOverlapping + 1
    end
  end
end

print(numOverlapping)
