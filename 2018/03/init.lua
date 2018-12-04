local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local function mapArrayInPlace(tbl, fn)
  for i, v in ipairs(tbl) do
    tbl[i] = fn(v)
  end
  return tbl
end

local function addClaim(claims, x, y, id)
  if claims[x] == nil then claims[x] = {} end
  if claims[x][y] == nil then claims[x][y] = {} end
  table.insert(claims[x][y], id)
end

local ids = {}
local claims = {}
for _, line in ipairs(input) do
  local id, x, y, w, h = unpack(mapArrayInPlace({line:match("#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")}, tonumber))
  for i=x,x+w-1 do
    for j=y,y+h-1 do
      addClaim(claims, i, j, id)
    end
  end
  table.insert(ids, id)
end

local numOverlapping = 0
local overlappingIDs = {}
for x, col in pairs(claims) do
  for y, ids in pairs(col) do
    if #ids >= 2 then
      numOverlapping = numOverlapping + 1
      for _, id in ipairs(ids) do
        overlappingIDs[id] = true
      end
    end
  end
end

-- Part 1
print(numOverlapping)

local nonOverlappingID = nil
for _, id in ipairs(ids) do
  if not overlappingIDs[id] then
    nonOverlappingID = id
    break
  end
end

-- Part 2
print(nonOverlappingID)
