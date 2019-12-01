local input = (function(f) local t={}; for l in assert(io.lines(f)) do t[#t+1] = l end; return t end)('input.txt')

local tracks = {}
local trains = {}
local TURN_LEFT = 0
local TURN_NONE = 1
local TURN_RIGHT = 2

local TRACK_TURN_ONE = '\\'
local INTERSECTION = '+'
local TRACK_TURN_TWO = '/'

local Train = {}
Train.__index = Train

local TRAIN_NEXT_ID = 1
function Train.new(x, y, xvel, yvel)
  local self = setmetatable({}, Train)
  self.x = x
  self.y = y
  self.xvel = xvel or 0
  self.yvel = yvel or 0
  self.turnIndex = 0
  self.id = TRAIN_NEXT_ID
  TRAIN_NEXT_ID = TRAIN_NEXT_ID + 1
  return self
end

function Train:move(tracks)
  self.x = self.x + self.xvel
  self.y = self.y + self.yvel
  local trackType = tracks[self.x] and tracks[self.x][self.y]
  if trackType ~= nil then
    io.write(string.format('hit %s => ', trackType))
    local turnType
    if trackType == INTERSECTION then
      turnType = self.turnIndex % 3
      self.turnIndex = self.turnIndex + 1
    else
      if self.xvel ~= 0 then
        turnType = trackType == TRACK_TURN_ONE and TURN_RIGHT or TURN_LEFT
      else
        turnType = trackType == TRACK_TURN_ONE and TURN_LEFT or TURN_RIGHT
      end
    end
    self:turn(turnType)
  end
end

function Train:turn(turnType)
  local turnTypeString = (turnType == TURN_LEFT and 'lt') or (turnType == TURN_RIGHT and 'rt') or 'str'
  io.write(turnTypeString..' => ')
  if turnType == TURN_NONE then
    return
  end
  local modifier
  if turnType == TURN_LEFT then
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

for y, line in ipairs(input) do
  for x=1,#line do
    local c = line:sub(x,x)
    if c:match('[\\/+]') then
      if not tracks[x] then tracks[x] = {} end
      if c == '+' then
        tracks[x][y] = INTERSECTION
      else
        tracks[x][y] = c == '\\' and TRACK_TURN_ONE or TRACK_TURN_TWO
      end
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

local function checkForCollisions(trains)
  local positions = {}
  for _, train in ipairs(trains) do
    if positions[train.x] and positions[train.x][train.y] then
      return {x=train.x, y=train.y}
    end
    if not positions[train.x] then positions[train.x] = {} end
    positions[train.x][train.y] = true
  end
  return false
end

local function tick(tracks, trains)
  table.sort(trains, function(a, b)
    if a.y == b.y then
      return a.x < b.x
    end
    return a.y < b.y
  end)
  for _, train in ipairs(trains) do
    io.write(string.format("%s => ", tostring(train)))
    train:move(tracks)
    print(train)
    local collision = checkForCollisions(trains)
    if collision then
      return collision
    end
  end
  return nil
end

local collisionPoint
local tickNum = 0
repeat
  collisionPoint = tick(tracks, trains)
  tickNum = tickNum+1
until collisionPoint ~= nil
print(string.format('%d,%d', collisionPoint.x-1, collisionPoint.y-1))
