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

local Deliverer = {}
Deliverer.__index = Deliverer

function Deliverer.new()
  local self = setmetatable({}, Deliverer)
  self.x, self.y = 0, 0
  visit(self.x, self.y)
  return self
end

function Deliverer:move(instruction)
  self.x, self.y = instructions[instruction](self.x, self.y)
  visit(self.x, self.y)
end

-- Part 1
local santa = Deliverer.new()

for c in input:gmatch('.') do
  santa:move(c)
end

local numVisited = len2d(visited)
print("Houses that got at least one present", numVisited)

-- Part 2
visited = {}
santa = Deliverer.new()
local roboSanta = Deliverer.new()
local robo = false

for c in input:gmatch('.') do
  local cur = robo and roboSanta or santa
  cur:move(c)
  robo = not robo
end

local numVisitedWithRobo = len2d(visited)
print("Houses that got at least one present (with robo)", numVisitedWithRobo)
