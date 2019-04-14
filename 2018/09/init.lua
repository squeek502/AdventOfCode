local input = io.open('input.txt'):read('*l')

local numPlayers, lastMarbleWorth = input:match("(%d+) players; last marble is worth (%d+) points")
numPlayers, lastMarbleWorth = tonumber(numPlayers), tonumber(lastMarbleWorth)

local function modIndex(index, size)
  return ((index-1) % size) + 1
end

local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.new(v)
  local self = setmetatable({}, LinkedList)
  self.head = {value=v}
  self.head.next = self.head
  self.head.prev = self.head
  return self
end

function LinkedList:insert(v)
  local node = {value=v, prev=self.head, next=self.head.next}
  self.head.next.prev = node
  self.head.next = node
  self.head = node
end

function LinkedList:get(deltaFromHead)
  local node = self.head
  for i=1,math.abs(deltaFromHead or 0) do
    node = deltaFromHead > 0 and node.next or node.prev
  end
  return node
end

function LinkedList:moveHead(delta)
  self.head = self:get(delta)
end

function LinkedList:remove(deltaFromHead)
  local node = self:get(deltaFromHead)
  node.prev.next, node.next.prev = node.next, node.prev
  return node
end

local function computeScores(numPlayers, lastMarbleWorth)
  local scores = {}
  for i=1,numPlayers do
    scores[i] = 0
  end
  local marbles = LinkedList.new(0)
  for marble=1, lastMarbleWorth do
    if marble % 23 == 0 then
      marbles:moveHead(-7)
      local removed = marbles:remove().value
      local playerNum = modIndex(marble, numPlayers)
      scores[playerNum] = scores[playerNum] + marble + removed
      marbles:moveHead(1)
    else
      marbles:moveHead(1)
      marbles:insert(marble)
    end
  end
  return scores
end

local function highScore(scores)
  local highScore, player = -math.huge, nil
  for i, score in ipairs(scores) do
    if score > highScore then
      highScore = score
      player = i
    end
  end
  return highScore, player
end

-- Part 1
local score1 = highScore(computeScores(numPlayers, lastMarbleWorth))
print(score1)

-- Part 2
local score2 = highScore(computeScores(numPlayers, lastMarbleWorth*100))
print(score2)
