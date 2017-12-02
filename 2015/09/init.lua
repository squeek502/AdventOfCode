local get = function(path)
  local f = io.open(path, "r")
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end
local input = get('input.txt')

local graph = {}

for _, line in ipairs(input) do
  local from, to, dist = line:match("(%w+) to (%w+) = (%d+)")
  dist = tonumber(dist)
  if not graph[from] then graph[from] = {} end
  if not graph[to] then graph[to] = {} end
  graph[from][to] = dist
  graph[to][from] = dist
end

local function copy(tbl)
  local cp = {}
  for k,v in pairs(tbl) do
    cp[k] = v
  end
  return cp
end

local function getAllPossiblePathLengths(from, traveled, visited)
  if visited == nil then visited = {[from]=true} end
  if traveled == nil then traveled = 0 end
  local lengths = {}
  local wasVisited = visited
  for place, dist in pairs(graph[from]) do
    if not wasVisited[place] then
      visited = copy(wasVisited)
      visited[place] = true
      local future = getAllPossiblePathLengths(place, traveled + dist, visited)
      for _, length in ipairs(future) do
        table.insert(lengths, length)
      end
    end
  end
  if wasVisited == visited then
    lengths = {traveled}
  end
  return lengths
end

local shortestPaths = {}

for place, connected in pairs(graph) do
  local possible = getAllPossiblePathLengths(place)
  local smallest = math.min(unpack(possible))
  table.insert(shortestPaths, smallest)
end

local shortest = math.min(unpack(shortestPaths))
print("Shortest path", shortest)
