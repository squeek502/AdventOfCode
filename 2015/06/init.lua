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

local function makeGrid(w, h, defaultValue)
  local grid = {}
  for i=0,w-1 do
    grid[i] = {}
    for j=0,h-1 do
      grid[i][j] = defaultValue
    end
  end
  return grid
end

local function iteratorCollect(iterator)
  local t = {}
  for v in iterator do
    table.insert(t, v)
  end
  return t
end

local function run(grid, instructions, eval)
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

  local total = 0
  for x=0,w-1 do
    for y=0,h-1 do
      total = eval(total, grid[x][y])
    end
  end

  return total
end

-- part 1
local grid = makeGrid(w, h, false)
local instructions = {
  ["turn on"] = function(v) return true end,
  ["toggle"] = function(v) return not v end,
  ["turn off"] = function(v) return false end,
}
local eval = function(t, v)
  return v and t+1 or t
end

local lit = run(grid, instructions, eval)
print("Total lit", lit)

-- part 2
grid = makeGrid(w, h, 0)
instructions = {
  ["turn on"] = function(v) return v+1 end,
  ["toggle"] = function(v) return v+2 end,
  ["turn off"] = function(v) return math.max(0, v-1) end,
}
eval = function(t, v)
  return t+v
end

local brightness = run(grid, instructions, eval)
print("Total brightness", brightness)
