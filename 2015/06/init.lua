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

local w, h = 1000, 1000

local grid = {}

for i=1,w do
  grid[i] = {}
  for j=1,h do
    grid[i][j] = false
  end
end

local instructions = {
  ["turn on"] = function(v) return true end,
  ["toggle"] = function(v) return not v end,
  ["turn off"] = function(v) return false end,
}

local function iteratorCollect(iterator)
  local t = {}
  for v in iterator do
    table.insert(t, v)
  end
  return t
end

for _, line in ipairs(input) do
  local coords = iteratorCollect(line:gmatch('%d+'))
  local x1, y1, x2, y2 = unpack(coords)
  local instruction = line:match('^[^%d]+'):sub(1,-2)
  for x=x1, x2 do
    for y=y1, y2 do
      grid[x][y] = instructions[instruction](grid[x][y])
    end
  end
end

local lit = 0
for _, row in ipairs(grid) do
  for _, v in ipairs(row) do
    if v then
      lit = lit + 1
    end
  end
end

print("Lights lit", lit)
