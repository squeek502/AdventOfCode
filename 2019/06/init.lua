local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

-- [orbitor] => orbitee
local objects = {}

for _, line in ipairs(input) do
  local orbitee, orbitor = line:match("(%w+)%)(%w+)")
  objects[orbitor] = orbitee
end

local function getOrbitees(orbitor, orbitees)
  if not orbitees then orbitees = {} end
  local orbitee = objects[orbitor]
  if orbitee then
    table.insert(orbitees, orbitee)
    return getOrbitees(orbitee, orbitees)
  else
    return orbitees
  end
end

-- lookup table for all orbitees of each object
-- [orbitor] => {orbitee, ...}
local allOrbitees = {}
for orbitor, orbitee in pairs(objects) do
  allOrbitees[orbitor] = getOrbitees(orbitor)
end

-- Part 1
local total = 0
for orbitor, orbitee in pairs(objects) do
  local numIndirects = #(allOrbitees[orbitee] or {})
  total = total + 1 + numIndirects
end
print(total)

-- because the arrays in the allOrbitees table are created walking backwards
-- up the tree, the keys of each orbitee corresponds exactly to its distance from
-- the orbitor (i.e. if A orbits B and B orbits C then allOrbitors.A = {B, C})
-- so we can simply find the first common orbitee and return the sum of
-- their keys
local function calcPath(tbl1, tbl2)
  local lookup = {}
  for k, v in ipairs(tbl2) do
    lookup[v] = k
  end
  for k, v in ipairs(tbl1) do
    if lookup[v] ~= nil then
      -- this returns (total dist), (common orbitee that the path goes through)
      return k + lookup[v], v
    end
  end
end

-- Part 2
local YOU_initial = objects.YOU
local SAN_initial = objects.SAN
local dist = calcPath(allOrbitees[YOU_initial], allOrbitees[SAN_initial])
print(dist)
