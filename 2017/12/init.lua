local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local directConnections = {}

local function connect(a, b)
  if not directConnections[a] then directConnections[a] = {} end
  table.insert(directConnections[a], b)
end

for _, line in ipairs(input) do
  local id, connectedStr = line:match("(%d+) <%-> (.+)")
  for cid in connectedStr:gmatch("%d+") do
    connect(tonumber(id), tonumber(cid))
  end
end

local function arrayContains(tbl, needle)
  for _, v in ipairs(tbl) do
    if v == needle then return true end
  end
  return false
end

local function getAllConnections(id, seen)
  if seen == nil then seen = {} end
  local connections = {id}
  seen[id] = true
  for _, cid in ipairs(directConnections[id] or {}) do
    if not seen[cid] then
      for _, indirectcid in ipairs(getAllConnections(cid, seen)) do
        if not arrayContains(connections, indirectcid) then
          table.insert(connections, indirectcid)
        end
      end
    end
  end
  return connections
end

local connections = getAllConnections(0)
print(#connections)
