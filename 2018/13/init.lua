local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local TURN_LEFT = 0
local TURN_NONE = 1
local TURN_RIGHT = 2

local Train = {}
Train.__index = Train

function Train.new(x, y, xvel, yvel)
  local self = setmetatable({}, Train)
  self.x = x
  self.y = y
  self.xvel = xvel or 0
  self.yvel = yvel or 0
  self.turnIndex = 0
  self.collided = false
  return self
end

function Train:move(tracks)
  if self.collided then return end
  self.x = self.x + self.xvel
  self.y = self.y + self.yvel
  local trackType = tracks[self.x] and tracks[self.x][self.y]
  if trackType ~= nil then
    local turnType
    if trackType == '+' then
      turnType = self.turnIndex % 3
      self.turnIndex = self.turnIndex + 1
    else
      if self.xvel ~= 0 then
        turnType = trackType == '\\' and TURN_RIGHT or TURN_LEFT
      else
        turnType = trackType == '\\' and TURN_LEFT or TURN_RIGHT
      end
    end
    self:turn(turnType)
  end
end

function Train:turn(turnType)
  local modifier
  if turnType == TURN_NONE then
    return
  elseif turnType == TURN_LEFT then
    -- > => ^ : +x => -y
    -- < => v : -x => +y
    -- ^ => < : -y => -x
    -- v => > : +y => +x
    modifier = self.yvel == 0 and -1 or 1
  elseif turnType == TURN_RIGHT then
    -- > => v : +x => +y
    -- < => ^ : -x => -y
    -- ^ => > : -y => +x
    -- v => < : +y => -x
    modifier = self.xvel == 0 and -1 or 1
  end
  local xvel = self.xvel
  self.xvel = modifier * self.yvel
  self.yvel = modifier * xvel
end

function Train:char()
  if self.yvel ~= 0 then
    return self.yvel == -1 and '^' or 'v'
  else
    return self.xvel == -1 and '<' or '>'
  end
end

function Train:__tostring()
  return string.format("%s(%d,%d)", self:char(), self.x, self.y)
end

local function loadFromInput(input)
  local tracks, trains = {}, {}
  for y, line in ipairs(input) do
    for x=1,#line do
      local c = line:sub(x,x)
      if c:match('[\\/+]') then
        if not tracks[x] then tracks[x] = {} end
        tracks[x][y] = c
      elseif c:match('[v^<>]') then
        local xvel, yvel = 0, 0
        if c == '^' then
          yvel = -1
        elseif c == 'v' then
          yvel = 1
        elseif c == '<' then
          xvel = -1
        elseif c == '>' then
          xvel = 1
        end
        local train = Train.new(x, y, xvel, yvel)
        table.insert(trains, train)
      end
    end
  end
  return tracks, trains
end

local tracks, trains = loadFromInput(input)

local function checkForCollisions(trains)
  local collisions = {}
  local seen = {}
  for _, train in ipairs(trains) do
    if not train.collided then
      if seen[train.x] and seen[train.x][train.y] then
        train.collided = true
        seen[train.x][train.y].collided = true
        table.insert(collisions, {x=train.x, y=train.y, train1=train, train2=seen[train.x][train.y]})
      else
        if not seen[train.x] then seen[train.x] = {} end
        seen[train.x][train.y] = train
      end
    end
  end
  return collisions
end

local function tick(tracks, trains)
  local collisions = {}
  table.sort(trains, function(a, b)
    if a.y == b.y then
      return a.x < b.x
    end
    return a.y < b.y
  end)
  for _, train in ipairs(trains) do
    train:move(tracks)
    local curCollisions = checkForCollisions(trains)
    for _, collision in ipairs(curCollisions) do
      table.insert(collisions, collision)
    end
  end
  return collisions
end

local function findTrain(trains, needle)
  for i, train in ipairs(trains) do
    if train == needle then
      return i
    end
  end
end

local firstCollisionPoint
repeat
  local collisions = tick(tracks, trains)
  if #collisions > 0 then
    firstCollisionPoint = firstCollisionPoint or collisions[1]
    -- remove collided trains
    for _, collision in ipairs(collisions) do
      for _, v in ipairs({collision.train1, collision.train2}) do
        local i = assert(findTrain(trains, v))
        table.remove(trains, i)
      end
    end
  end
until #trains==1

-- Part 1
print(string.format('%d,%d', firstCollisionPoint.x-1, firstCollisionPoint.y-1))

-- Part 2
print(string.format('%d,%d', trains[1].x-1, trains[1].y-1))
