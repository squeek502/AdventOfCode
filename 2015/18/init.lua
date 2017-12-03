local get = function(path)
  local lines = {}
  for line in io.lines(path) do
    table.insert(lines, line)
  end
  return lines
end
local input = get('input.txt')

local function makeGrid()
  local grid = {}
  for x, line in ipairs(input) do
    grid[x] = {}
    for y=1,#line do
      local c = line:sub(y,y)
      grid[x][y] = c == '#'
    end
  end
  return grid
end

local grid = makeGrid()

local neighborOffsets = {
  {1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}, {0,-1}, {1,-1}
}

local function getLitNeighbors(x, y)
  local count = 0
  for _, offset in ipairs(neighborOffsets) do
    local dx, dy = unpack(offset)
    if grid[x+dx] and grid[x+dx][y+dy] == true then
      count = count + 1
    end
  end
  return count
end

local function step()
  local toggle = {}
  for x=1,#grid do
    for y=1,#grid[x] do
      local on = grid[x][y]
      local neighbors = getLitNeighbors(x, y)
      if on and neighbors ~= 2 and neighbors ~= 3 then
        table.insert(toggle, {x,y})
      elseif not on and neighbors == 3 then
        table.insert(toggle, {x,y})
      end
    end
  end

  for _, coord in ipairs(toggle) do
    local x, y = unpack(coord)
    grid[x][y] = not grid[x][y]
  end
end

local function countLit()
  local lit = 0
  for x=1,#grid do
    for y=1,#grid[x] do
      if grid[x][y] then
        lit = lit + 1
      end
    end
  end
  return lit
end

for i=1,100 do
  step()
end

print(countLit())

-- Part 2
local function stuckOn()
  local w,h = #grid, #grid[1]
  grid[1][1] = true
  grid[w][h] = true
  grid[1][h] = true
  grid[w][1] = true
end

grid = makeGrid()
stuckOn()

for i=1,100 do
  step()
  stuckOn()
end

print(countLit())
