local get = function(path)
  local f = io.open(path, "r")
  local all = f:read("*all")
  f:close()
  return all
end
local input = get('input.txt')

local instructions = {
  ['^'] = function(x, y) return x, y+1 end,
  ['v'] = function(x, y) return x, y-1 end,
  ['>'] = function(x, y) return x+1, y end,
  ['<'] = function(x, y) return x-1, y end,
}

local visited = {}
local x, y = 0, 0

local function visit(x, y)
  if not visited[x] then visited[x] = {} end
  if not visited[x][y] then visited[x][y] = 0 end
  visited[x][y] = visited[x][y]+1
end

local function len2d(tbl)
  local count = 0
  for _, v in pairs(tbl) do
    for _ in pairs(v) do
      count = count + 1
    end
  end
  return count
end

for c in input:gmatch('.') do
  visit(x, y)
  x, y = instructions[c](x, y)
  visit(x, y)
end

local numVisited = len2d(visited)
print("Houses that got at least one present", numVisited)
